function [train_data, test_data] = splitDataset(dataset, train_ratio)

    % Split a dataset into training and test sets
    % -------------------------------------------
    %
    % Brief:
    %   Splits the given dataset into a training set and a test set based on
    %   the specified trainRatio. The dataset is shuffled randomly before
    %   splitting to ensure randomness in the resulting sets
    %
    % Input arguments:
    %   - dataset: Cell array containing the dataset
    %   - trainRatio: Ratio of the dataset to be assigned to the training set
    %     (value between 0 and 1)
    %
    % Output arguments:
    %   - trainData: Training set containing a portion of the dataset
    %   - testData: Test set containing the remaining portion of the dataset
    
    % Shuffle the dataset
    shuffled_data = dataset(randperm(size(dataset, 1)), :);
    
    % Determine the split index
    split_index = round(train_ratio * size(shuffled_data, 1));
    
    % Assign data to training set
    train_data = shuffled_data(1:split_index, :);
    
    % Assign data to test set
    test_data = shuffled_data(split_index+1:end, :);

end

