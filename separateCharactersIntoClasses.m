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
    %   class_labels = separateCharactersIntoClasses(dataset);
    
    % Get the number of characters in the dataset
    num_characters = length(dataset);
    
    % Initialize the cell arrays to store class labels and divided datasets
    class_labels = cell(num_characters, 1);
    dataset_1 = cell(0);
    dataset_2 = cell(0);
    dataset_3 = cell(0);
    dataset_blank = cell(0);
    
    % Iterate over each character in the dataset
    count_dataset_1 = 1; count_dataset_2 = 1; count_dataset_3 = 1; count_blanks = 1;
    for i=1 : num_characters
        % Get the contours and label for the current character
        contours = dataset{i, 1};
        label = dataset{i, 2};

        % Assign the character to a class based on the number of contours
        if strcmp(label, 'BLANK')
            % Treat blank spaces separately
            class_labels{i} = 'Class Blank';
            dataset_blank{count_blanks, 1} = contours;
            dataset_blank{count_blanks, 2} = label;
            count_blanks = count_blanks + 1;
        else
            num_contours = numel(contours);
            class_labels{i} = ['Class ', num2str(num_contours)];
            if num_contours == 1
                dataset_1{count_dataset_1, 1} = contours{1};
                dataset_1{count_dataset_1, 2} = label;
                count_dataset_1 = count_dataset_1 + 1;
            elseif num_contours == 2
                % bwboundaries has stored the exterior boundaries first
                dataset_2{count_dataset_2, 1} = contours{1};
                dataset_2{count_dataset_2, 2} = strcat(label, '_outside');
                dataset_2{count_dataset_2+1, 1} = contours{2};
                dataset_2{count_dataset_2+1, 2} = strcat(label, '_inside');
                count_dataset_2 = count_dataset_2 + 2;
            elseif num_contours >= 3
                % bwboundaries has stored the exterior boundaries first
                dataset_3{count_dataset_3, 1} = contours{1};
                dataset_3{count_dataset_3, 2} = strcat(label, '_outside');

                % Determine which hole boundary is northern
                dataset_3{count_dataset_3+1, 1} = contours{2};
                dataset_3{count_dataset_3+1, 2} = strcat(label, '_inside_up');
                dataset_3{count_dataset_3+2, 1} = contours{3};
                dataset_3{count_dataset_3+2, 2} = strcat(label, '_inside_down');
                count_dataset_3 = count_dataset_3 + 3;
            end
        end
    end

end

