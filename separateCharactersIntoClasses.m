function class_labels = separateCharactersIntoClasses(dataset)

    % Separate characters into classes based on the number of contours
    % ----------------------------------------------------------------
    %
    % Brief:
    %   This function takes the dataset containing contours of each character and assigns
    %   class labels to each character based on the number of contours. 
    %   The class labels are assigned as '1st class', '2nd class', or '3rd class'
    %   depending on the number of contours
    %
    % Input:
    %   - dataset : Cell array of contours for each character in the dataset.
    %
    % Output:
    %   - class_labels : Cell array of class labels for each character.
    %
    % Example:
    %   dataset = createDataset(img, txt_file);
    %   class_labels = separateCharactersIntoClasses(dataset);
    
    % Get the number of characters in the dataset
    num_characters = size(dataset, 1);
    
    % Initialize the cell array to store class labels
    class_labels = cell(num_characters, 1);
    
    % Iterate over each character in the dataset
    for i = 1:num_characters
        % Count the number of contours for the current character
        num_contours = numel(dataset{i});
        
        % Assign the character to a class based on the number of contours
        if num_contours == 1
            class_labels{i} = '1st class';
        elseif num_contours == 2
            class_labels{i} = '2nd class';
        elseif num_contours >= 3
            class_labels{i} = '3rd class';
        end
    end

end
