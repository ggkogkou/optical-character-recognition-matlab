function img_rotated = rotateImage(img, angle)

    % Function that performs image rotation by a specified angle
    % --------------------------------------------------------------
    %
    % @param img is the input image
    % @param angle rotation angle
    %
    % @returns img_rotated is the rotated image
    %
    % --------------------------------------------------------------
    %
    % The equations to find the new coordinate that corresponds to the old
    % one are:
    %
    % x_new = x_original * cosθ + y * sinθ
    % y_new = - x_original * sinθ + y * cosθ
    %
    % or, in matrix form, X_new = R * X_old 
    %
    % Additionally the equations to map back the new coordinates to the
    % original image are:
    %
    % X_new = R * X_old => X_old = R^(-1) * X_new = R * X_new
    %
    % --------------------------------------------------------------
    % 
    % Check whether rotation angle is zero or not
    if angle == 0
        img_rotated = img;
        return;
    end

    % Convert to radians and create transformation matrix
    a = angle*pi/180;
    
    % Declare Rotation Matrix
    R = [cos(a) sin(a); -sin(a) cos(a)];

    % Original image size
    [img_height, img_width, p] = size(img);

    % Transform the coordinates of the corners to find the new image size
    corners = [1, 1; 1, img_width; img_height, 1; img_height, img_width];
    corners_rotated = round(corners*R);

    % Necessary check for the validity of the new coordinates
    % -------------------------------------------------------
    % Transformed corners have to be normalized in order to start from
    % (1,1) and end at (max_row,max_col)
    % ----------------------------------
    % Add 1 to ensure that indexing starts from 1.
    corners_rotated = corners_rotated - min(corners_rotated) + 1;

    % From the new corners, extract the new image dimensions
    rot_img_height = max(corners_rotated(:, 1));
    rot_img_width = max(corners_rotated(:, 2));

    % Initiliaze the new image
    img_rotated = zeros(rot_img_height, rot_img_width, p, class(img));

    % Iterate through the new image and map the pixels from original image
    % Interpolate missing pixels using Bilinear Interpolation method
    for i=1 : rot_img_height
        for j=1 : rot_img_width

            % Map back to the original image as explained above
            original_pixel = ([i j] - corners_rotated(1,:)) / R;

            % Ensure that the calculated pixel is within the bounds of the
            % original image
            if ~(min(original_pixel, [], "all") >= 1 && all(original_pixel <= [img_height img_width]))
                continue;
            end

            % Determine the four neighboring pixels for bilinear interpolation
            nearest_floor = floor(original_pixel);
            nearest_ceil = ceil(original_pixel);

            % Compute the relative areas of the four neighboring pixels
            w1 = (nearest_ceil(2)-original_pixel(2))  * (nearest_ceil(1)-original_pixel(1));
            w2 = (original_pixel(2)-nearest_floor(2)) * (original_pixel(1)-nearest_floor(1));
            w3 = (nearest_ceil(2)-original_pixel(2))  * (original_pixel(1)-nearest_floor(1));
            w4 = (original_pixel(2)-nearest_floor(2)) * (nearest_ceil(1)-original_pixel(1));
            neighbors = [w1, w2; w3, w4];

            % Copy the colors of the original image to the rotated
            % Compute the weighted average of the colors to get the interpolated color
            neighobors_resized = repmat(neighbors, [1 1 size(img, 3)]);

            weighted_average = img(nearest_floor(1):nearest_ceil(1), nearest_floor(2):nearest_ceil(2), :);
            weighted_average = double(weighted_average) .* neighobors_resized;

            % Assign the interpolated color to the output image                    
            img_rotated(i, j, :) = sum(sum(weighted_average), 2);

        end
    end

end

