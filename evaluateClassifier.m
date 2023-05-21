function [weighted_accuracy, confusion_matrix] = evaluateClassifier(test_set, trained_classifier, ...
                                                                    unique_labels, interpolation_points)
    
    % Evaluate the performance of a trained kNN classifier on a test set
    % ------------------------------------------------------------------
    %
    % Inputs:
    %   - test_set: A cell array containing the test samples and their labels
    %   - trained_classifiers: A cell array of the trained kNN classifier
    %   - unique_labels: A cell array containing the unique labels in the training set
    %   - interpolation_points: The number of interpolation points to use for feature extraction
    %
    % Outputs:
    %   - weighted_accuracy: The weighted accuracy of the classifier
    %   - confusion_matrix: The confusion matrix showing the successful
    %                       predictions
    %   
    %   This function evaluates the performance of a trained kNN classifier on a given test set. It extracts
    %   feature vectors from the test samples using the contourDescriptor method. The evaluation is performed
    %   specifically for a single class
    %
    %   The test set should be provided as a cell array, where each element contains the feature vector of a
    %   sample as well as its corresponding label. The feature vectors should be column vectors, and the labels
    %   can be of any data type as long as they match the labels used during training
    %
    %   The trained classifiers should be a cell array containing the corresponding trained kNN classifiers for the class
    %   The unique labels should be a cell array containing all the unique labels in the training set
    %
    %   The function calculates the confusion matrix to compare the predicted labels against the actual labels
    %   in the test set. It then calculates the accuracy and weighted accuracy of the classifier based on the
    %   confusion matrix

    % Extract the feature vectors
    test_set = produceFeatureVectors(test_set, interpolation_points);
    
    % Evaluate the contour characters
    
    % Determine the size of the test samples
    num_labels = size(test_set, 1);
    
    % Extract the feature vectors and labels from the test set
    feature_vectors = cell(num_labels, 1);
    labels = cell(num_labels, 1);
    
    for i=1 : num_labels
        % Iteratively get all of the feature vectors and labels
        feature_vectors{i} = transpose(test_set{i, 1});
        labels{i} = test_set{i, 2};
    end
    
    % Convert the test feature vectors and labels to matrices
    X_test = cell2mat(feature_vectors);
    Y_test = string(labels);
        
    % Find the unique labels of the train set to create the confusion matrix
    num_unique_labels = length(unique_labels);
    
    % Initialize confusion matrix
    confusion_matrix = zeros(num_unique_labels);
    
    % Predict the label based on the test sample's feature vector and update the confusion matrix
    for i=1 : num_labels
        % Get the feature vector of the current test sample
        feature_vector = X_test(i, :);
    
        % Get the actual label of the test sample
        actual_label = Y_test(i);
    
        % Use the trained classifier to predict the label
        predicted_label = predict(trained_classifier, feature_vector);
    
        % Find the cell of the confusion matrix to store the prediction
        actual_idx = find(strcmp(actual_label, unique_labels));
        predicted_idx = find(strcmp(predicted_label{1}, unique_labels));
    
        % Update the confusion matrix based on the true and predicted classes
        confusion_matrix(actual_idx, predicted_idx) = confusion_matrix(actual_idx, predicted_idx) + 1;
    
    end
    
    % Calculate performance metrics and handle possible division by 0
    accuracy = sum(diag(confusion_matrix)) / sum(confusion_matrix(:));
    class_accuracy = diag(confusion_matrix) ./ sum(confusion_matrix, 2);
    class_accuracy(isnan(class_accuracy)) = 0;  % Set NaN values to 0
    weighted_accuracy = sum(class_accuracy .* (sum(confusion_matrix, 2) / sum(confusion_matrix(:))));
    weighted_accuracy = sum(weighted_accuracy(isfinite(weighted_accuracy)));  % Exclude NaN values

    
    % Display the results
    display_results = false;

    if ~display_results
        return;
    end

    disp('Confusion Matrix:');
    disp(confusion_matrix);
    fprintf('Accuracy: %.2f%%\n', accuracy * 100);
    fprintf('Weighted Accuracy: %.2f%%\n', weighted_accuracy * 100);

end

