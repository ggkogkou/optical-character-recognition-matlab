function [dataset] = createDataset(img, txt_file)

    clc; clear;
    img = imread("text1.png");
    txt_file = "text1.txt";
    
    % Segment characters from the image
    [~, characters] = segmentCharactersFromImage(img);
    
    % Read the text file to get the corresponding labels
    buffer = fopen(txt_file, 'r');
    text = fscanf(buffer, '%c');

    % Remove leading and trailing whitespace characters
    text = strtrim(text); 
    fclose(buffer);
    
    % Create the dataset and extract contours
    dataset = table('Size', [length(characters), 2], 'VariableTypes', ...
        {'cell', 'char'}, 'VariableNames', {'Contour', 'Label'});
    
    for i=1 : length(characters)

        char_i = characters{i};

        % Handle line break as if it was a blank space
        if strcmp(char_i, 'line_break')
            tmp = ones(10);
            contour = getContour(tmp);
        else
            contour = getContour(char_i);
        end
    
        % Assign the label based on the text file
        label = text(i);
        
        % Add the data point to the dataset
        dataset{i, 1} = contour;
        dataset{i, 2} = label;

    end

end

