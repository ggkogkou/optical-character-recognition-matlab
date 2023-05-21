function [lines] = readText(img)

    % Extract text from an image and saves it to a file
    % -------------------------------------------------
    %
    % Brief:
    %   This function takes an input image 'img', performs text extraction
    %   from the image, reconstructs the text lines, and returns the lines as a
    %   cell array of strings
    %
    % Input:
    %   - img: Input image containing text
    %
    % Output:
    %   - lines: Cell array of strings representing the reconstructed text lines
    
    % Perform text line extraction to get individual lines
    [lines_extracted, ~] = segmentCharactersFromImage(img);
    num_lines = numel(lines_extracted);

    % Define interpolation points for feature extraction
    interpolation_points = 400;

    % Get the trained classifier
    trained_classifier = load("trained_classifiers.mat");

    % Get the different characters from each line and extract contours
    character_contours_per_line = cell(num_lines, 1);

    for i = 1:num_lines
        % Get the corresponding line as a cell array of cell arrays
        line = lines_extracted{i};
        num_chars = numel(line);
        characters_of_line = cell(num_chars, 2);

        % Extract contours
        for j = 1:num_chars
            char_j = line{j};
            contour = getContour(double(char_j));

            % Label to keep the index of the character or if it's blank
            label = string(j);

            % Handle blank spaces separately
            if isempty(contour)
                label = 'BLANK';
            end

            % Add the data point to the dataset
            characters_of_line{j, 1} = contour;
            characters_of_line{j, 2} = label;
        end

        % Add the sub-cell array to the total cell array
        character_contours_per_line{i} = characters_of_line;
    end

    % Reconstruct lines of text, cell array of strings
    text_reconstructed = cell(num_lines, 1);

    % Separate the dataset into classes depending on the number of contours
    for line_i = 1:num_lines
        % Get the dataset of the characters of the line
        line = character_contours_per_line{line_i}; % 2D cell array
        line_length = size(line, 1);
        generated_text = cell(1, line_length);

        % Initialize with blanks
        for j = 1:line_length
            generated_text{j} = ' ';
        end

        % Separate the dataset into classes depending on the number of contours
        [class_1, class_2, class_3, ~] = separateCharactersIntoClasses(line);

        for class_i = 1:3
            % Select the corresponding class
            if class_i == 1 && ~isempty(class_1)
                selected_class = class_1;
            elseif class_i == 2 && ~isempty(class_2)
                selected_class = class_2;
            elseif class_i == 3 && ~isempty(class_3)
                selected_class = class_3;
            else
                continue;
            end

            % Extract feature vectors from contours
            selected_class = produceFeatureVectors(selected_class, interpolation_points);

            num_labels = size(selected_class, 1);

            % Extract the feature vectors and labels from the dataset
            feature_vectors = cell(num_labels, 1);
            labels = cell(num_labels, 1);

            for j = 1:num_labels
                % Iteratively get all of the feature vectors
                feature_vectors{j} = transpose(selected_class{j, 1});
                labels{j} = selected_class{j, 2};
            end

            % Convert the feature vectors and labels to matrices
            feature_vectors = cell2mat(feature_vectors);
            labels = string(labels);

            % Make the prediction, predicted_char is a cell array
            predicted_char = predict(trained_classifier.trained_classifiers{class_i}, feature_vectors);

            % Iterate through the line and assign appropriate letters
            count_predictions = 1;
            for j = 1:num_labels
                % Extract text: keep the first character of the predicted label
                predicted_letter = predicted_char{count_predictions};
                if (class_i == 3 && mod(j, 3) ~= 1) || (class_i == 2 && mod(j, 2) ~= 1)
                    continue;
                elseif class_i > 1
                    predicted_letter = extractBefore(predicted_letter, '_');
                end

                % Determine the position of letters in the line
                position_in_line = labels(j);
                if class_i == 1
                    position_in_line = str2double(position_in_line);
                else
                    position_in_line = extractBefore(position_in_line, '_');
                    position_in_line = str2double(position_in_line);
                end

                % Expand the string
                generated_text{1, position_in_line} = predicted_letter;

                % Keep track of predictions
                count_predictions = count_predictions + 1;
            end

        end

        text_reconstructed{line_i} = generated_text;
    end

    % Obtain the text lines as strings
    lines = cell(num_lines, 1);
    for line_i = 1:num_lines
        lines{line_i} = strjoin(text_reconstructed{line_i}, '');
    end

end

