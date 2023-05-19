function feature_vectors = produceFeatureVectors(dataset, interpolation_points)

    % Generate feature vectors for contours in a dataset
    % --------------------------------------------------
    %
    % Brief:
    %   This function takes a dataset of contours as input and generates feature vectors
    %   for each contour. The feature vectors are computed using interpolation and contour
    %   descriptor functions.
    %
    % Input:
    %   - dataset: A cell array representing the dataset of contours
    %
    % Output:
    %   - feature_vectors: A cell array containing the computed feature vectors for each contour

    

    % Get the number of rows in the dataset
    num_rows = size(dataset, 1);

    % Initialize the feature_vectors cell array
    feature_vectors = cell(0, 2);

    % Loop through each data point in the dataset
    for i=1 : num_rows
        % Get the contour of the current data point
        contour_i = dataset{i, 1};
        label_i = dataset{i, 2};

        % Initialize the feature_i cell array to store feature vectors

        % Interpolate the contour points
        interpolated_contour = interpolateContour(contour_i, interpolation_points);

        % Compute the feature vector using the contour descriptor
        feature_i = contourDescriptor(interpolated_contour);

        % Store the feature vectors for the data point
        feature_vectors{i, 1} = feature_i;
        feature_vectors{i ,2} = label_i;
    end

end

