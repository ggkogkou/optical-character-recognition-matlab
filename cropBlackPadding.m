function [cropped_img] = cropBlackPadding(img)
    
    % Function that crops black padding from image
    % --------------------------------------------------------------
    %
    % @param img is the input RGB image
    %
    % @returns cropped_img is the RGB image without black padding
    %
    % --------------------------------------------------------------
    % 
    % Convert RGB to Grayscale
    img_grayscale = rgb2gray(img);

    % Find the projections of the rows and columns
    rows_proj = sum(img_grayscale, 2); row_idx1 = 0; row_idx2 = 0;
    cols_proj = sum(img_grayscale, 1); col_idx1 = 0; col_idx2 = 0;

    % Find the first and last elements that have value >0, meaning that
    % they belong in the text image. All the lines that are full black must
    % be deleted
    for i=1 : length(rows_proj)
        % First non-zero element
        if rows_proj(i) ~= 0
            row_idx1 = i;
            break;
        end
    end

    % For the last non-zero element
    for i=length(rows_proj) : -1 : 1
        % Last non-zero element
        if rows_proj(i) ~= 0
            row_idx2 = i;
            break;
        end
    end

    % Same but for columns
    for i=1 : length(cols_proj)
        % First non-zero element
        if cols_proj(i) ~= 0
            col_idx1 = i;
            break;
        end
    end

    % For the last non-zero element
    for i=length(cols_proj) : -1 : 1
        % Last non-zero element
        if cols_proj(i) ~= 0
            col_idx2 = i;
            break;
        end
    end

    % Crop the black padding rows and obtain final image
    cropped_img = img(row_idx1:row_idx2, col_idx1:col_idx2, :);

end

