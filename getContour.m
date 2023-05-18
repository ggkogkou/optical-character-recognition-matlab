function [c] = getContour(x)

    %   Locate and extract contours of a letter image
    %   ---------------------------------------------
    %
    %   Brief:
    %   - This function locates and extracts the contours of a letter image.
    %   - It first converts the input letter image to grayscale and binarizes it using
    %   an appropriate threshold. Then, morphological operations are performed to
    %   enhance the contours.
    %   - The image is dilated and the outline is obtained by subtracting the
    %   dilated image from the binary image.
    %   - Thinning is applied to reduce the thickness of the edges.
    %   - Finally, the contours are identified using the bwboundaries function,
    %   and the coordinates are stored in a cell array
    %
    %   Input:
    %   - x: Image of a single letter
    %
    %   Output:
    %   - contours: Cell array containing the contours of the letter
    %
    %   Example:
    %   % Read the letter image
    %   letter = imread('a.png');
    %   % Get the contours using getcontour function
    %   contours = getContour(letter);
    %   % Display the original letter image
    %   figure; imshow(letter); hold on;
    %   % Plot the contours on the image
    %   for i=1 : numel(contours)
    %   contour = contours{i};
    %   plot(contour(:, 1), contour(:, 2), 'r', 'LineWidth', 2);
    %   end
    %   hold off; title('Letter Contours');

    % Convert the letter to grayscale
    img_grayscale = im2gray(x);

    % Binarize the image using an appropriate threshold
    threshold = graythresh(img_grayscale);
    img_binary = imbinarize(img_grayscale, threshold);

    % Add white background as padding to avoid character ending exactly on
    % the edge of the image
    padding = 10;
    img_binary = padarray(img_binary, [padding, padding], 1, 'both');

    % Perform morphological operations to enhance the contours
    img_dilated = imdilate(img_binary, strel('disk', 1));
    img_outline = img_dilated - img_binary;
    img_thinned = bwmorph(img_outline, 'thin', Inf);

    % Find the contours using bwboundaries
    boundaries = bwboundaries(img_thinned, 'noholes');

    % Initialize cell array to store contours
    c = cell(numel(boundaries), 1);

    % Extract the contour points for each contour
    for i=1 : numel(boundaries)
        c{i} = fliplr(boundaries{i});
    end

end

