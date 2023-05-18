function trained_classifiers = trainCharacterClassifiers(dataset)

    % Train character classifiers using kNN algorithm
    % -----------------------------------------------
    %
    % Brief:
    %   This function trains separate character classifiers using the kNN (k-Nearest Neighbors) algorithm.
    %   It takes as input a dataset containing feature vectors for each character and returns a cell array
    %   of trained kNN classifiers, where each classifier corresponds to a character class.
    %
    % Inputs:
    %   - dataset: Cell array of feature vectors for each character in the dataset
    %
    % Output:
    %   - trained_classifiers: Cell array of trained kNN classifiers for each character class
    %
    % Example:
    %   dataset = produceFeatureVectors(original_dataset);
    %   trained_classifiers = trainCharacterClassifiers(dataset);
    %
    %   Detailed Description:
    %       This function trains separate character classifiers using the kNN (k-Nearest Neighbors) algorithm.
    %       It takes as input a dataset containing feature vectors for each character and returns a cell array
    %       of trained kNN classifiers, where each classifier corresponds to a character class.
    %
    %   See also: produceFeatureVectors, separateCharactersIntoClasses, fitcknn

    img = imread("text1.png"); txt = 'text1.txt'; dataset = createDataset(img, txt);
    [dataset, ~] = splitDataset(dataset, 0.7);
    
    % Separate dataset into classes based on the number of contours
    [dataset_1, dataset_2, dataset_3, ~] = separateCharactersIntoClasses(dataset);

    dataset_1 = produceFeatureVectors(dataset_1);
    dataset_2 = produceFeatureVectors(dataset_2);
    dataset_3 = produceFeatureVectors(dataset_3);
    
    % Initialize the cell array to store trained classifiers
    trained_classifiers = cell(3, 1);
    
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
        
        for i=1 : size(current_dataset, 1)
            % Get the feature vectors and label for the current character
            feature_vectors{i} = transpose(current_dataset{i, 1});
            labels{i} = current_dataset{i, 2};
        end

        % Typecast the cell arrays to appropriate format
        X = cell2mat(feature_vectors);
        Y = string(labels);
        
        % Train kNN classifier
        Mdl = fitcknn(X, Y);
        
        % Store the trained classifier
        trained_classifiers{class_i} = Mdl;
    end
    
end
