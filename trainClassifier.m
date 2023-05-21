function [trained_classifier, unique_labels] = trainClassifier(train_set, interpolation_points)

    % Trains a kNN classifier using a given training set
    % --------------------------------------------------
    %
    % Brief:
    %   This function trains a kNN classifier using the given training set. It extracts feature vectors
    %   from the training samples using the contourDescriptor method. The kNN classifier is trained
    %   with the specified number of interpolation points and the standardized Euclidean distance metric
    %
    %   Note that the training samples should be in the format of a cell array, where each element
    %   contains the feature vector of a sample as well as its corresponding label. The feature vectors
    %   should be column vectors, and the labels can be of any data type as long as they are unique
    %
    %   The trained classifier and the unique labels in the training set are returned as output
    %
    % Inputs:
    %   - train_set: A cell array containing the training samples and their labels
    %   - interpolation_points: The number of interpolation points to use for feature extraction
    %
    % Outputs:
    %   - trained_classifier: The trained kNN classifier
    %   - unique_labels: A cell array containing the unique labels in the training set

    % Extract feature vectors for each dataset using the contourDescriptor method
    train_set = produceFeatureVectors(train_set, interpolation_points);

    % Nearest Neighbors
    k = 4;
    
    % Train kNN classifiers for the given train set

    % Prepare the feature vectors and labels for training
    feature_vectors = cell(size(train_set, 1), 1);
    labels = cell(size(train_set, 1), 1);
    
    % Convert the feature vectors and labels to the appropriate format for kNN
    for i=1 : size(train_set, 1)
        % Get the feature vectors and label for the current character
        feature_vectors{i} = transpose(train_set{i, 1});
        labels{i} = train_set{i, 2};
    end

    % Typecast the cell arrays to appropriate format
    X = cell2mat(feature_vectors);
    Y = string(labels);

    % Find the unique labels of the train set
    unique_labels = unique(Y);

    % S parameter for distance metric
    S = ones(1, size(X, 2));
    
    % Train kNN classifier
    Mdl = fitcknn(X, Y, 'NumNeighbors', k, 'Distance', 'seuclidean', 'Scale', S);%'Standardize', true);
    
    % Store the trained classifier
    trained_classifier = Mdl;

end

