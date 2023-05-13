function c = getcontour(x)

    %   Locate and extract contours of a letter image
    %   ---------------------------------------------
    %
    %   Brief:
    %   This function locates and extracts the contours of a letter image.
    %   It first converts the input letter image to grayscale and binarizes it using
    %   an appropriate threshold. Then, morphological operations are performed to
    %   enhance the contours. The image is dilated and the outline is obtained by
    %   subtracting the dilated image from the binary image. Thinning is applied to
    %   reduce the thickness of the edges. Finally, the contours are identified using
    %   the bwboundaries function, and the coordinates are stored in a cell array
    %
    %   Input:
    %   - x: Image of a single letter
    %
    %   Output:
    %   - contours: Cell array containing the contours of the letter
    %
    %   Example:
    %   x = imread('a.png');
    %   contours = getcontour(x);
    %   figure(1);
    %   imshow(x);
    %   hold on;
    %   for k=1 : numel(contours)
    %       contour = contours{k};
    %       plot(contour(:, 2), contour(:, 1), 'r', 'LineWidth', 2);
    %   end
    %   hold off;
    %   title('Letter Contours');
    %
    %   See also: RGB2GRAY, IMBINARIZE, IMDILATE, BWMORPH, BWLABEL, BWBOUNDARIES

    % Convert the letter to grayscale
    img_gray = im2gray(x);

    % Binarize the image using an appropriate threshold
    threshold = graythresh(img_gray);
    img_binary = imbinarize(img_gray, threshold);

    % Perform morphological operations to enhance the contours
    img_dilated = imdilate(img_binary, strel('disk', 1));
    img_outline = img_dilated - img_binary;
    img_thinned = bwmorph(img_outline, 'thin', Inf);

    % Find the contours using bwboundaries
    boundaries = bwboundaries(img_thinned, 'noholes');

    % Initialize cell array to store contours
    c = cell(numel(boundaries), 1);

    % Extract the contour points for each contour
    for k=1 : numel(boundaries)
        contour = boundaries{k};
        contour = fliplr(contour); % Reverse the order of coordinates
        c{k} = contour;
    end

end

