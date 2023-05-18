function classifiers = trainCharacterClassifiers(trainFeatures, trainLabels)

    % Trains separate character classifiers for each class using the KNN algorithm
    img = imread("text1.png"); txt_file = 'text1.txt';
    dataset = createDataset(img, txt_file);
    [trainData, ~] = splitDataset(dataset, 0.7);
    [trainFeatures, trainLabels] = featureExtraction(trainData);
        
    % Use separateCharactersIntoClasses to get class labels
    classLabels = separateCharactersIntoClasses(trainData)
    
    % Parameters for the KNN algorithm
    k = 5;  % Number of neighbors to consider
    
    % Determine the unique class labels in the training data
    uniqueLabels = unique(classLabels)
    numClasses = numel(uniqueLabels);
    
    % Initialize the cell array to store the trained classifiers
    classifiers = cell(numClasses, 1);
    
    % Train a separate classifier for each class
    for i = 1:numClasses
        % Extract the features and labels for the current class
        classLabel = uniqueLabels{i};
        classIndices = strcmp(classLabels, classLabel);
        classFeaturesCurr = trainFeatures(classIndices, :);
        classLabelsCurr = trainLabels(classIndices);
        
        % Train the K-nearest neighbors classifier for the current class
        knnClassifier = fitcknn(classFeaturesCurr, classLabelsCurr, 'NumNeighbors', k);
        
        % Store the trained classifier in the cell array
        classifiers{i} = knnClassifier;
    end
end
