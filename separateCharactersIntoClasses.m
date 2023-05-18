function [dataset_1, dataset_2, dataset_3, dataset_blank] = separateCharactersIntoClasses(dataset)

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
    %   - dataset : Cell array of contours for each character in the dataset
    %
    % Output:
    %   - class_labels : Cell array of class labels for each character
    %
    % Example:
    %   dataset = createDataset(img, txt_file);
    %   [class1, class2, class3, class0] = separateCharactersIntoClasses(dataset);
    
    % Get the number of characters in the dataset
    num_characters = length(dataset);
    
    % Initialize the cell arrays to store class labels and divided datasets
    class_labels = cell(num_characters, 1);
    dataset_1 = cell(num_characters, 1);
    dataset_2 = cell(num_characters, 1);
    dataset_3 = cell(num_characters, 1);
    dataset_blank = cell(num_characters, 1);
    
    % Iterate over each character in the dataset
    for i = 1:num_characters
        % Get the contours and label for the current character
        contours = dataset{i, 1};
        label = dataset{i, 2};

        % Assign the character to a class based on the number of contours
        if strcmp(label, 'BLANK')
            % Treat blank spaces separately
            class_labels{i} = 'Class Blank';
            dataset_blank{i} = dataset(i, :);
        else
            num_contours = numel(contours);
            class_labels{i} = ['Class ', num2str(num_contours)];
            if num_contours == 1
                dataset_1{i} = dataset(i, :);
            elseif num_contours == 2
                dataset_2{i} = dataset(i, :);
            elseif num_contours >= 3
                dataset_3{i} = dataset(i, :);
            end
        end
    end

    % Remove empty cells from the datasets
    dataset_1 = dataset_1(~cellfun('isempty', dataset_1));
    dataset_2 = dataset_2(~cellfun('isempty', dataset_2));
    dataset_3 = dataset_3(~cellfun('isempty', dataset_3));
    dataset_blank = dataset_blank(~cellfun('isempty', dataset_blank));

end

