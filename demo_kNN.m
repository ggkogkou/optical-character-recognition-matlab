% Load the image and text files
clc; clear;
img = imread("text1.png");
txt = 'text1.txt';

% Create the dataset
dataset = createDataset(img, txt);

% Split the dataset into training and test sets
[train_set, test_set] = splitDataset(dataset, 0.7);

% Train the character classifiers
[trained_classifiers, unique_labels] = trainCharacterClassifiers(train_set);

% Separate the test dataset depending to the number of contours
[test_1, ~, ~, ~] = separateCharactersIntoClasses(test_set);

% Extract the feature vectors
test_1 = produceFeatureVectors(test_1, 400);

% Evaluate the contour characters

% Determine the size of the test samples
num_labels = size(test_1, 1);

% Extract the feature vectors and labels from the test set
feature_vectors_test = cell(num_labels, 1);
labels_test = cell(num_labels, 1);

for i=1 : num_labels
    % Iteratively get all of the feature vectors and labels
    feature_vectors_test{i} = transpose(test_1{i, 1});
    labels_test{i} = test_1{i, 2};
end

% Convert the test feature vectors and labels to matrices
X_test = cell2mat(feature_vectors_test);
Y_test = string(labels_test);

% Get classifier for single contour characters
classifier_selected = trained_classifiers{1};

% Find the unique labels of the train set to create the confusion matrix
unique_labels_test_1 = unique_labels{1};
num_unique_labels_test_1 = length(unique_labels_test_1);

% Initialize confusion matrix
confusion_matrix = zeros(num_unique_labels_test_1);

% Predict the label based on the test sample's feature vector and update the confusion matrix
for i=1 : num_labels
    % Get the feature vector of the current test sample
    feature_vector = X_test(i, :);

    % Get the actual label of the test sample
    actual_label = Y_test(i);

    % Use the trained classifier to predict the label
    predicted_label = predict(classifier_selected, feature_vector);

    % Find the cell of the confusion matrix to store the prediction
    actual_idx = find(strcmp(actual_label, unique_labels_test_1));
    predicted_idx = find(strcmp(predicted_label{1}, unique_labels_test_1));

    % Update the confusion matrix based on the true and predicted classes
    confusion_matrix(actual_idx, predicted_idx) = confusion_matrix(actual_idx, predicted_idx) + 1;

end

% Calculate performance metrics
accuracy = sum(diag(confusion_matrix)) / sum(confusion_matrix(:));

% Display the results
disp('Confusion Matrix:');
disp(confusion_matrix);
fprintf('Accuracy: %.2f%%\n', accuracy * 100);
