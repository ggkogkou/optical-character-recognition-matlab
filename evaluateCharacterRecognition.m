function evaluateCharacterRecognition()

    % Evaluate the performance of a character recognition system
    % ----------------------------------------------------------
    %
    % Brief:
    %   This function evaluates the performance of a character recognition system
    %   using a test dataset. It calculates the weighted accuracy and displays
    %   the confusion matrix

    % Load the image and text files
    img = imread("text1.png");
    txt = 'text1.txt';

    % Create the dataset
    dataset = createDataset(img, txt);

    % Split the dataset into training and test sets
    [train_set, test_set] = splitDataset(dataset, 0.7);

    % Train the character classifiers
    trained_classifiers = trainCharacterClassifiers(train_set);

    % Find rows with empty cell arrays in the test set
    emptyRows = cellfun(@isempty, test_set(:, 1));

    % Remove empty rows from the test set
    test_set(emptyRows, :) = [];

    % Expand the contours in the test set
    test_set = expandTestSetContours(test_set);

    % Initialize the confusion matrix
    num_classes = 3;
    confusion_matrix = zeros(num_classes);

    % Initialize variables for counting the samples in each class
    class_counts = zeros(num_classes, 1);

    % Classify the samples in the test set and update the confusion matrix
    for i = 1:size(test_set, 1)
        % Get the feature vector of the current test sample
        feature_test_set = produceFeatureVectors(test_set, 400);

        % Declare the feature vector
        len_test_set = size(feature_test_set, 1);
        feature_vectors = cell(len_test_set, 1);
        labels = cell(len_test_set, 1);

        % Convert the feature vectors to the appropriate format
        for j = 1:len_test_set
            feature_vectors{j} = transpose(feature_test_set{j, 1});
            labels{j} = feature_test_set{j, 2};
        end

        % Typecast the cell arrays to the appropriate format
        feature_vectors = cell2mat(feature_vectors);
        labels = string(labels);

        % Predict the class using the trained classifiers
        class_predictions = cell(len_test_set, 1);

        for class_i = 1:num_classes
            classifier = trained_classifiers{class_i};
            class_predictions{class_i} = predict(classifier, feature_vectors(i, :));
        end

        % Update the confusion matrix based on the true and predicted classes
        true_class = labels(i);
        true_index = find(strcmp(true_class, class_predictions));

        for class_i = 1:num_classes
            predicted_index = find(strcmp(class_predictions{class_i}, labels(i)));

            if ~isempty(true_index) && ~isempty(predicted_index)
                confusion_matrix(true_index, predicted_index) = confusion_matrix(true_index, predicted_index) + 1;
                class_counts(true_index) = class_counts(true_index) + 1;
            end
        end
    end

    % Calculate the weighted accuracy
    weightedAccuracy = sum(diag(confusion_matrix)) / sum(class_counts);

    % Display the results
    fprintf('Weighted Accuracy: %.2f%%\n\n', weightedAccuracy * 100);
    disp('Confusion Matrix:');
    disp(confusion_matrix);

end

