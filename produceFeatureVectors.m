function feature_vectors = produceFeatureVectors(dataset)

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

    img = imread("text1.png"); txt_file = 'text1.txt'; dataset = createDataset(img, txt_file); [dataset, ~] = splitDataset(dataset, 0.7);

    % Initialize interpolation points variable
    interpolation_points = -1;

    % Loop through each data point in the dataset
    for i = 1:length(dataset)
        tmp = dataset{i};

        % Check if the length of the data point is less than or equal to 1
        if length(tmp) <= 1
            % Update the interpolation points variable
            interpolation_points = max(interpolation_points, length(tmp));
            % Skip to the next data point
            continue;
        end

        % Loop through each contour in the data point
        for j = 1:length(tmp)
            tmp2 = tmp{j};
            % Update the interpolation points variable
            interpolation_points = max(interpolation_points, length(tmp2));
        end
    end

    % Get the number of rows in the dataset
    num_rows = size(dataset, 1);

    % Initialize the feature_vectors cell array
    feature_vectors = cell(num_rows, 1);

    % Loop through each data point in the dataset
    for i = 1:num_rows
        % Get the contour of the current data point
        contour_i = dataset{i, 1};

        % Initialize the feature_i cell array to store feature vectors
        feature_i = cell(size(contour_i));

        % Loop through each contour in contour_i
        for j=1 : length(contour_i)
            % Get the contour points
            contour_points = contour_i{j};

            % Interpolate the contour points
            interpolated_contour = interpolateContour(contour_points, interpolation_points);

            % Compute the feature vector using the contour descriptor
            feature_i{j} = contourDescriptor(interpolated_contour);
        end

        % Store the feature vectors for the data point
        feature_vectors{i} = feature_i;
    end

end

