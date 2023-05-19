function [test_set_extended] = expandTestSetContours(dataset)

    % Expand the test set by representing each contour of a letter separately
    % -----------------------------------------------------------------------
    %
    % Brief:
    %   This function takes a test set as a cell array and modifies it to 
    %   return a set where, when a letter has more than one contour, all 
    %   of them are represented separately
    %
    % Input:
    %   - test_set: Cell array representing the test set with character contours and labels
    %
    % Output:
    %   - test_set_extended: Cell array representing the extended test set with separate contours for each character
    %
    % Example:
    %   test_set = {
    %       {contour1}, 'A';
    %       {contour1, contour2}, 'B';
    %       {contour1, contour2, contour3}, 'C';
    %       ...
    %   };
    %   test_set_extended = expandTestSetContours(test_set);
    %
    %   The resulting test_set_extended will contain separate rows for each contour:
    %   test_set_extended = {
    %       {contour1}, 'A';
    %       {contour1}, 'B_outside';
    %       {contour2}, 'B_inside';
    %       {contour1}, 'C_outside';
    %       {contour2}, 'C_inside_up';
    %       {contour3}, 'C_inside_down';
    %       ...
    %   };
    
    % Get the number of characters in the dataset
    num_characters = length(dataset);
    
    % Initialize the cell arrays to store class labels and divided datasets
    class_labels = cell(num_characters, 1);
    test_set_extended = cell(0);
    
    % Iterate over each character in the dataset
    count = 1;
    for i=1 : num_characters
        % Get the contours and label for the current character
        contours = dataset{i, 1};
        label = dataset{i, 2};

        % Assign the character to a class based on the number of contours
        if strcmp(label, 'BLANK')
            % Treat blank spaces separately
            class_labels{i} = 'Class Blank';
            test_set_extended{count, 1} = contours;
            test_set_extended{count, 2} = label;
            count = count + 1;
        else
            num_contours = numel(contours);
            class_labels{i} = ['Class ', num2str(num_contours)];
            if num_contours == 1
                test_set_extended{count, 1} = contours{1};
                test_set_extended{count, 2} = label;
                
            elseif num_contours == 2
                % bwboundaries has stored the exterior boundaries first
                test_set_extended{count, 1} = contours{1};
                test_set_extended{count, 2} = strcat(label, '_outside');
                test_set_extended{count+1, 1} = contours{2};
                test_set_extended{count+1, 2} = strcat(label, '_inside');
                count = count + 2;
            elseif num_contours >= 3
                % bwboundaries has stored the exterior boundaries first
                test_set_extended{count, 1} = contours{1};
                test_set_extended{count, 2} = strcat(label, '_outside');

                % Determine which hole boundary is northern
                test_set_extended{count+1, 1} = contours{2};
                test_set_extended{count+1, 2} = strcat(label, '_inside_up');
                test_set_extended{count+2, 1} = contours{3};
                test_set_extended{count+2, 2} = strcat(label, '_inside_down');
                count = count + 3;
            end
        end
    end

end

