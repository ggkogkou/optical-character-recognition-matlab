function cropped_img = cropBlackPadding(img)
    
    %   Crop black padding from an input RGB image
    %   ------------------------------------------
    %
    %   Brief:
    %   This function takes an RGB image as input and
    %   crops the black padding from the image. The resulting cropped image
    %   contains only the non-black regions
    %
    %   Input:
    %   - img: An M-by-N-by-3 RGB image, where M and N are the dimensions of
    %     the image and 3 represents the red, green, and blue channels
    %
    %   Output:
    %   - cropped_img: The RGB image without black padding, containing only
    %     the non-black regions
    %
    %   Example:
    %   % Crop black padding from an RGB image
    %   img = imread('input_image.png');
    %   cropped_img = cropBlackPadding(img);
    %   imshow(cropped_img);

    % Convert RGB to grayscale
    img_grayscale = rgb2gray(img);
    
    % Find the projections of the rows and columns
    rows_proj = sum(img_grayscale, 2);
    cols_proj = sum(img_grayscale, 1);
    
    % Find the first and last non-zero elements in rows_proj
    row_idx1 = find(rows_proj ~= 0, 1, 'first');
    row_idx2 = find(rows_proj ~= 0, 1, 'last');
    
    % Find the first and last non-zero elements in cols_proj
    col_idx1 = find(cols_proj ~= 0, 1, 'first');
    col_idx2 = find(cols_proj ~= 0, 1, 'last');
    
    % Crop the black padding rows and obtain the final image
    cropped_img = img(row_idx1:row_idx2, col_idx1:col_idx2, :);

end
