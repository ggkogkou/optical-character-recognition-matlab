function [dataset] = createDataset(img, txt_file)

    clc; clear;
    img = imread("text1.png");
    txt_file = "text1.txt";
    
    % Segment characters from the image
    [line_characters, characters] = segmentCharactersFromImage(img);
    
    % Read the text file to get the corresponding labels
    fid = fopen(txt_file, 'r');
    if fid < 0
        error('Cannot open file: %s', txt_file);
    end

    text = fscanf(fid, '%c');

    % Remove leading and trailing whitespace characters
    text = strtrim(text);
    fclose(fid);

    % Remove empty lines and trailing spaces at the end of each line
    output_file_no_blanks = 'test_file.txt';
    removeEmptyLinesAndSpaces(txt_file, output_file_no_blanks);


    fid = fopen(output_file_no_blanks, 'r');
    if fid < 0
        error('Cannot open file: %s', output_file_no_blanks);
    end

    output_file_no_blanks = fscanf(fid, '%c');

    % Remove leading and trailing whitespace characters
    output_file_no_blanks = strtrim(output_file_no_blanks);
    fclose(fid);

    length(output_file_no_blanks)
    
    % Create the dataset and extract contours
    num_characters = length(characters)
    dataset = cell(num_characters, 2);
    
    for i=1 : min(num_characters, length(text))

        % Find contours
        char_i = characters{i};
        contour = getContour(double(char_i));

        % Assign the label based on the text file
        label = text(i); % Typecast label to a cell
        
        % Add the data point to the dataset
        dataset{i, 1} = contour;
        dataset{i, 2} = label;

    end

end

