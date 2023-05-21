function trainAndEvaluateClassifiers(img, txt_path)

% Train and evaluate kNN classifiers for different classes of characters
% ----------------------------------------------------------------------
%
% Brief:
%   The function loads the image and text files containing character samples and their labels. 
%   It then creates a dataset by pairing each character sample with its corresponding label
%
%   The dataset is split into training and test sets, with 70% of the samples used for training and the remaining
%   30% for testing. The function then separates the training set into three classes based on the number of contours
%   in each character sample
%
%   Next, the function trains kNN classifiers for each class using the `trainClassifier` function. The number of
%   interpolation points used for feature extraction is specified for each class
%
%   The test set is also separated into three classes based on the number of contours. The `evaluateClassifier`
%   function is then called to evaluate the performance of each classifier on its corresponding test set. The
%   weighted accuracy of each classifier is calculated
%
%   Finally, the results are displayed, showing the weighted accuracy for
%   each class and the trained classifiers are saved for future use
%
% Inputs:
%   - img: The text image itself (not just the path)
%   - txt: Path to the text file containing corresponding ASCII characters
%
% Outputs:
%   None

    % Create the dataset
    dataset = createDataset(img, txt_path);
    
    % Split the dataset into training and test sets
    [train_set, test_set] = splitDataset(dataset, 0.7);
    
    % Separate train dataset into classes based on the number of contours
    [train_set_1, train_set_2, train_set_3, ~] = separateCharactersIntoClasses(train_set);
    
    % Initialize a cell array to store the trained classifiers
    trained_classifiers = cell(3, 1);
    
    % Initialize a cell array to store the unique labels of the dataset
    unique_labels = cell(3, 1);
    
    % Choose interpolation points for each class
    N1 = 400; N2 = 400; N3 = 400;
    
    % Train the character classifiers
    [trained_classifiers{1}, unique_labels{1}] = trainClassifier(train_set_1, N1);
    [trained_classifiers{2}, unique_labels{2}] = trainClassifier(train_set_2, N1);
    [trained_classifiers{3}, unique_labels{3}] = trainClassifier(train_set_3, N1);
    
    % Separate the test dataset depending to the number of contours
    [test_set_1, test_set_2, test_set_3, ~] = separateCharactersIntoClasses(test_set);
    
    % Evaluate classifiers - one for each class
    [weighted_accuracy_1, ~] = evaluateClassifier(test_set_1, trained_classifiers{1}, unique_labels{1}, N1);
    [weighted_accuracy_2, ~] = evaluateClassifier(test_set_2, trained_classifiers{2}, unique_labels{2}, N2);
    [weighted_accuracy_3, ~] = evaluateClassifier(test_set_3, trained_classifiers{3}, unique_labels{3}, N3);

    % Display the results
    %disp('Confusion Matrix:'); disp(confusion_matrix);
    %fprintf('Accuracy: %.2f%%\n', accuracy * 100);
    fprintf('Class 1 -> Weighted Accuracy: %.3f%%\n', weighted_accuracy_1 * 100);
    fprintf('Class 2 -> Weighted Accuracy: %.3f%%\n', weighted_accuracy_2 * 100);
    fprintf('Class 3 -> Weighted Accuracy: %.3f%%\n', weighted_accuracy_3 * 100);
    
    % Save the trained classifiers in order to be used with new data
    save('trained_classifiers.mat', 'trained_classifiers');

end

