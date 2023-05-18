function [trainFeatures, trainLabels] = featureExtraction(trainData)

    % Extract features from the training data
    % ---------------------------------------
    %
    % Inputs:
    %   trainData - Training data in the form of a cell array with contour
    %               information and labels
    %
    % Outputs:
    %   trainFeatures - Extracted features (contour descriptors) for training
    %                   samples
    %   trainLabels - Corresponding labels for the training samples

    img = imread("text1.png"); txt_file = 'text1.txt'; dataset = createDataset(img, txt_file); [trainData, ~] = splitDataset(dataset, 0.7);
    
    % Preallocate arrays for the features and labels
    numSamples = size(trainData, 1);
    % Get the maximum number of points among all contours in the training data
    maxPoints = max(cellfun(@(contour) size(contour, 1), trainData(:, 1)));
    trainFeatures = cell(numSamples, 1);
    trainLabels = cell(numSamples, 1);
    
    % Iterate over each sample in the dataset
    for i = 1:size(trainData, 1)
        contours = trainData{i, 1};
        label = trainData{i, 2};
        
        % Initialize an empty cell array to store the interpolated contours
        interpolatedContours = cell(size(contours));
        
        % Interpolate each contour to match the maximum number of points
        for j = 1:numel(contours)
            contour = contours{j};
            interpolatedContour = interpolateContour(contour, maxPoints);
            interpolatedContours{j} = interpolatedContour;
        end
        
        % Compute the descriptor for each interpolated contour
        descriptors = cellfun(@contourDescriptor, interpolatedContours, 'UniformOutput', false);
        
        % Concatenate the descriptors into a single feature vector
        feature = cat(1, descriptors{:});
        
        % Store the feature vector and label in the trainFeatures and trainLabels arrays
        trainFeatures{i} = feature;
        trainLabels{i} = label;
        
    end

end

