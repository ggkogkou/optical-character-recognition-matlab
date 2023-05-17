function [dataset] = createDataset(img, txt_file)

    clc; clear;
    img = imread("text1.png");

    % Step 1: Segment characters from the image
    characters = segmentCharactersFromImage(image);
    
    % Step 2: Read the text file to get the corresponding labels
    fid = fopen(textFile, 'r');
    text = fscanf(fid, '%c');
    fclose(fid);
    
    % Step 3: Extract contours and create the dataset
    dataset = table('Size', [length(characters), 2], 'VariableTypes', {'cell', 'char'}, 'VariableNames', {'Contour', 'Label'});
    
    for i = 1:length(characters)
        characterImage = characters{i};
        
        % Step 4: Apply getcontour function to extract the contour
        contour = getcontour(characterImage);
        
        % Step 5: Assign the label based on the text file
        label = text(i);
        
        % Step 6: Add the data point to the dataset
        dataset = [dataset; {contour, label}];
    end

end

