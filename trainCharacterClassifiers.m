function [trained_classifiers, unique_labels] = trainCharacterClassifiers(dataset)

    % Train character classifiers using kNN algorithm
    % -----------------------------------------------
    %
    % Brief:
    %   This function trains separate character classifiers using the kNN (k-Nearest Neighbors) algorithm.
    %   It takes as input a dataset containing feature vectors for each character and returns a cell array
    %   of trained kNN classifiers, where each classifier corresponds to a character class.
    %
    % Inputs:
    %   - dataset: Cell array of characters after splitting
    %
    % Output:
    %   - trained_classifiers: Cell array of trained kNN classifiers for each character class
    %
    % Example:
    %   img = imread("text1.png"); txt = 'text1.txt';
    %   dataset = createDataset(img, txt);
    %   [dataset, ~] = splitDataset(dataset, 0.7);
    %   trained_classifiers = trainCharacterClassifiers(dataset)

    % Separate dataset into classes based on the number of contours
    [dataset_1, dataset_2, dataset_3, ~] = separateCharactersIntoClasses(dataset);

    % Extract feature vectors for each dataset using the contourDescriptor method
    dataset_1 = produceFeatureVectors(dataset_1, 400);
    dataset_2 = produceFeatureVectors(dataset_2, 400);
    dataset_3 = produceFeatureVectors(dataset_3, 400);

    % Initialize the cell array to store trained classifiers
    trained_classifiers = cell(3, 1);

    % Nearest Neighbors
    k = 4;

    % Find the unique labels of the train set
    unique_labels = cell(3, 1);
    
    % Train kNN classifiers for each character class
    for class_i=1 : 3
        % Select the dataset for the current class
        if class_i == 1
            current_dataset = dataset_1;
        elseif class_i == 2
            current_dataset = dataset_2;
        elseif class_i == 3
            current_dataset = dataset_3;
        end
        
        % Prepare the feature vectors and labels for training
        feature_vectors = cell(size(current_dataset, 1), 1);
        labels = cell(size(current_dataset, 1), 1);
        
        % Convert the feature vectors and labels to the appropriate format for kNN
        for i=1 : size(current_dataset, 1)
            % Get the feature vectors and label for the current character
            feature_vectors{i} = transpose(current_dataset{i, 1});
            labels{i} = current_dataset{i, 2};
        end

        % Typecast the cell arrays to appropriate format
        X = cell2mat(feature_vectors);
        Y = string(labels);

        % Update unique labels cell array
        unique_labels{class_i} = unique(Y);

        % S parameter for distance metric
        S = ones(1, size(X, 2));
        
        % Train kNN classifier
        Mdl = fitcknn(X, Y, 'NumNeighbors', k, 'Distance', 'seuclidean', 'Scale', S);%'Standardize', true);
        
        % Store the trained classifier
        trained_classifiers{class_i} = Mdl;
    end
    
end

