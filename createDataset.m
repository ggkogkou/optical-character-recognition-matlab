function [dataset] = createDataset(img, txt_file)

    % Extract contours from segmented characters and creates a dataset
    % ----------------------------------------------------------------
    %
    % Brief:
    %   This function takes an input image containing segmented characters and
    %   an ASCII text file as input. It extracts the contours of the characters
    %   and creates a dataset with corresponding labels from the text file.
    %
    % Input arguments:
    %   - img: An input image containing segmented characters. It should be a
    %          grayscale image
    %   - txt_file: The path to an ASCII text file containing the labels for
    %               the characters in the image
    %
    % Output:
    %   - dataset: A cell array representing the dataset. Each row of the array
    %              contains a character contour and its corresponding label.
    %
    % Example:
    %   img = imread('text1.png');
    %   txt_file = 'text1.txt';
    %   dataset = createDataset(img, txt_file);
    img = imread("text1.png"); txt_file = 'text1.txt';
    % Segment characters from the image
    [~, characters] = segmentCharactersFromImage(img);

    % Remove empty lines and trailing spaces at the end of each line of the
    % ASCII text file
    text_no_blanks = removeEmptyLinesAndSpaces(txt_file);

    % Create the dataset and extract contours
    num_characters = length(characters);
    num_common = min(num_characters, length(text_no_blanks));
    dataset = cell(num_common, 2);
    
    for i=1 : num_common

        % Find contours
        char_i = characters{i};
        contour = getContour(double(char_i));

        % Assign the label based on the text file
        label = text_no_blanks(i); % Typecast label to a cell
        
        % Add the data point to the dataset
        dataset{i, 1} = contour;
        dataset{i, 2} = label;

    end

end

