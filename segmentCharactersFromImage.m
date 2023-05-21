function [line_characters, chars] = segmentCharactersFromImage(img)

    % Segment characters from an input image
    % --------------------------------------
    %
    % Brief:
    %   The function takes an input image and performs character segmentation
    %   to extract individual characters from the image. The image is first
    %   converted to grayscale and then binarized using an appropriate
    %   threshold. Line extraction is performed by summing the binary values
    %   along each row of the binarized image. Characters are then extracted
    %   from each line by calculating column projections. Underlined characters
    %   are detected using row projections. The segmented characters are stored
    %   in a cell array, with each subcell representing a line of characters
    %
    % Input:
    %   img - An input image containing text. It should be a grayscale image
    %
    % Output:
    %   line_characters - A 2D cell array containing the extracted characters
    %                     from the input image. Each subcell array represents a line
    %                     of characters
    %   chars - A 1D cell array containing the extracted characters as one row
    %
    % Example:
    %   img = imread('text1.png');
    %   line_characters = segmentCharactersFromImage(img);

    % Convert to grayscale
    img_grayscale = im2gray(img);

    % Binarize the image using an appropriate threshold
    threshold = graythresh(img_grayscale);
    img_binarized = imbinarize(img_grayscale, threshold);

    % Add white background as padding to avoid character ending exactly on
    % the edge of the image
    padding = 40;
    img_binarized = padarray(img_binarized, [padding, padding], 1, 'both');

    % Line/Row Extraction
    rows_proj = sum(img_binarized, 2);

    num_rows = size(img_binarized, 1);
    num_cols = size(img_binarized, 2);

    line_break_threshold = sum(ones(1, num_cols));

    % Cell arrays to store the extracted lines
    line_bounds = cell(0);
    lines = cell(0);

    % The binarized image has black text in white background
    % White: 1, Black: 0
    % So, if the sum is approximately equal to the number of pixel columns,
    % it means that the line is full white and thus it is a line break
    line_start = 0; is_line_start = true; count = 1;
    for i=1 : num_rows
        % Locate the lines
        if rows_proj(i) < line_break_threshold && is_line_start
            % Start of a new line
            line_start = i;
            is_line_start = false;
        elseif rows_proj(i) >= line_break_threshold && ~is_line_start
            % End of a line
            line_end = i;
            is_line_start = true;
            line_bounds{count} = [line_start, line_end];
            count = count + 1;
        end

    end

    % Extract the lines of text
    for i=1 : length(line_bounds)
        indices = line_bounds{i};
        lines{i} = img_binarized(indices(1):indices(2), :);
    end
    
    % The same process is applied for the individual character extraction

    % 2D cell array to store the extracted characters. Each subcell array
    % is the corresponding line
    line_characters = cell(0);

    % Iterate through all of the lines
    line_num = 1;
    while true
        % Access the line
        line = lines{line_num};

        % Cell arrays to store the extracted character bounds and characters
        character_bounds = cell(0);
        characters = cell(0);

        % Calculate column projections of the line
        cols_proj = sum(line, 1);

        num_rows = size(line, 1);

        % Set the threshold for character break detection
        character_break_threshold = sum(ones(num_rows, 1));

        % Count white pixels to determine if a black is a blank space
        count_whites = 0;

        % Determine the width of a letter
        letter_start_idx = find(cols_proj ~= character_break_threshold, 1);
        letter_width = find(cols_proj(letter_start_idx:end) == character_break_threshold, 1) - 1;

        % Set the threshold for blank space character detection
        blank_space_threshold = floor(0.9 * letter_width);

        % Crop the line in the beginning of the process
        line_start = letter_start_idx;
        line_end = numel(cols_proj) - find(fliplr(cols_proj) ~= character_break_threshold, 1) + 10;

        line = line(:, line_start:line_end);
        cols_proj = cols_proj(line_start:line_end);

        % Update number of columns
        num_cols = size(line, 2);

        char_start = 0; is_char_start = true; count = 1; 
        found_blank_space = false; % Forbid two blank spaces in a row
        for i=1 : num_cols
            % Locate the characters
            if cols_proj(i) < character_break_threshold && is_char_start
                % Start of a new character
                char_start = i;
                is_char_start = false;
            elseif cols_proj(i) >= character_break_threshold && ~is_char_start
                % End of a character
                char_end = i;
                is_char_start = true;
                character_bounds{count} = [char_start, char_end];
                count = count + 1;
                count_whites = 0;
                found_blank_space = false;
            elseif cols_proj(i) >= character_break_threshold && count_whites > blank_space_threshold && ~found_blank_space
                % Find blank space
                blank_space_start = i - blank_space_threshold + 1;
                blank_space_end = i;
                character_bounds{count} = [blank_space_start, blank_space_end];
                count = count + 1;
                count_whites = 0;
                found_blank_space = true;
            else
                count_whites = count_whites + 1;
            end

        end

        % Extract the characters from the line
        for i=1 : length(character_bounds)
            % Get indices found above
            indices = character_bounds{i};

            characters{i} = line(:, indices(1):indices(2));
        end

        % Add characters from the analyzed line to the total cell array
        line_characters{line_num} = characters;

        % Go to the next line
        line_num = line_num + 1;
        if line_num > length(lines)
            break;
        end

    end

    % Transfer character in a cell array in continuous form
    % Initialize an empty cell array to store the characters
    
    % Concatenate all characters into a single cell array
    chars = [line_characters{:}];

    testing = false;
    if ~testing
        return;
    end

    figure
    for i=5 : length(line_characters)
        tmp = line_characters{i};
        for j=10 : length(tmp)
            tmp2 = tmp{j};
            imshow(tmp2);
        end
    end

end

