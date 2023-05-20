function [c] = getContour(x)

    % Extract the outer boundary and inner contours of a letter image
    % ---------------------------------------------------------------
    %
    % Brief:
    %   This function takes an input letter image and extracts the outer boundary
    %   along with the upper and lower inner contours of the letter. It follows a
    %   series of steps including image binarization, dilation, thinning, and contour
    %   detection to identify the contours
    %
    % Input
    %   x - Input letter image, represented as a grayscale or binary image
    %
    % Output
    %   c - Cell array containing the outer boundary and inner contours. The first
    %       cell contains the outer boundary, and subsequent cells store the inner
    %       contours. Each contour is represented as an Nx2 matrix, where N is the
    %       number of points describing the contour. Each row of the matrix contains
    %       the x and y coordinates of the corresponding point
    %
    % Example:
    %   % Load the letter image
    %   x = imread('letter.png');
    %
    %   % Extract the contours
    %   c = getcontour(x);
    %
    %   % Access the outer boundary
    %   outer_boundary = c{1};
    %
    %   % Access the upper inner contour
    %   upper_inner_contour = c{2};
    %
    %   % Access the lower inner contour
    %   lower_inner_contour = c{3};
    %
    %   % Plot the letter image with contours
    %   figure;
    %   subplot(1, 2, 1);
    %   imshow(x);
    %   title('Original Letter Image');
    %
    %   subplot(1, 2, 2);
    %   imshow(x);
    %   title('Letter Image with Contours');
    %   hold on;
    %
    %   for i = 1:numel(c)
    %       contour = c{i};
    %       plot(contour(:, 2), contour(:, 1), 'r', 'LineWidth', 1);
    %   end
    %
    %   hold off;

    % Convert the letter to grayscale
    x = im2gray(x);

    % Add white as padding to avoid character boundaries on the image edge
    padding = 10;
    x = padarray(x, [padding, padding], 255, 'both');

    % Binarize the image using an appropriate threshold
    threshold = graythresh(x);
    img_binary = imbinarize(x, threshold);

    % Check if the image is blank (all white)
    if all(img_binary(:, :))
        c = cell(0);
        return;
    end

    % Perform morphological operations to enhance the contours
    img_dilated = imdilate(img_binary, strel('disk', 1));
    img_outline = img_dilated - img_binary;
    img_thinned = bwmorph(img_outline, 'thin', Inf);

    % Identify outer boundary and hole contours
    boundaries = bwboundaries(img_thinned, 'noholes');

    % Determine upper and lower inner contours
    outer_boundary = boundaries{1};
    inner_contours = boundaries(2:end);

    % Calculate centroids of inner contours in order to determine which is
    % the upper
    centroids = cellfun(@(contour) mean(contour), inner_contours, 'UniformOutput', false);
    centroidY = cellfun(@(centroid) centroid(1), centroids);
    [~, sortedIndices] = sort(centroidY);

    % Initialize cell array to store contours
    c = cell(numel(boundaries), 1);

    % Store contours in cell array
    c{1} = outer_boundary;
    
    for i=1 : numel(inner_contours)
        c{i+1} = inner_contours{sortedIndices(i)};
    end

    % If using the testing mode, continue to plotting the results
    testing_mode = false;

    if ~testing_mode
        return;
    end

    % Plot letter image with contours
    figure;
    subplot(1, 2, 1);
    imshow(x);
    title('Original Letter Image');
    hold on;
    
    subplot(1, 2, 2);
    imshow(x);
    title('Letter Image with Contours');
    hold on;
    
    for i=1 : numel(c)
        contour = c{i};
        subplot(1, 2, 2);
        plot(contour(:, 2), contour(:, 1), 'r', 'LineWidth', 1);
    end
    
    hold off;

end

