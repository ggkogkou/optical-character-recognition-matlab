function [aligned_img] = alignDocument(img)

    % Function to determine deskew angle of text image and align it
    % --------------------------------------------------------------
    %
    % @see https://www.mdpi.com/2076-3417/10/7/2236
    %
    % @brief Align vertically a text image that has skew [-45,45] degrees
    %
    % @param img is the input image
    %
    % @return img_deskewed is the fully deskewed image
    %
    % --------------------------------------------------------------
    %
    % Essentially this function uses findRotationAngle() to make an initial
    % estimation of the rotation angle. After reverting this rotation, next
    % step is to determine whether the aproximate angle is larger or smaller
    % than the real one, and then iterate through a number of small angles 
    % in order to find the exact skew angle.
    % The key is to search all angles as long as the STD of the projections
    % is increasing. At the peak STD, the document is considered aligned.
    %
    % --------------------------------------------------------------
    %
    % Read the image
    img = imread('text1.png');
    img = imrotate(img, -32);

    interp_method = "nearest";

    % Find approximate rotation angle using FFT
    angle_approx = findRotationAngle(img);
    fprintf("An approximation skew angle is %.4f\n", angle_approx);

    % Rotate the image by that angle
    img = rotateImage(img, angle_approx, interp_method);
    fprintf("Rotation of %.4f was performed\n", angle_approx);

    % Implement Projection Profiling Method to find exact rotaton angle
    % -----------------------------------------------------------------
    % Determine whether the approximate deskew angle is bigger or smaller
    % than the actual rotation angle
    % -------------------------------------------------------------------
    % For that purpose, check in which direction the standard deviation 
    % of the sum of the projections increases
    theta = -0.1;

    % Case 1: Counter-clockwise rotation check
    rotated_img = rotateImage(img, abs(theta), interp_method);
    rotated_img_grayscale = rgb2gray(rotated_img);
    std_counter_clockwise = std(sum(rotated_img_grayscale, 2));

    % Case 2: Clockwise rotation check
    rotated_img = rotateImage(img, theta, interp_method);
    rotated_img_grayscale = rgb2gray(rotated_img);
    std_clockwise = std(sum(rotated_img_grayscale, 2));

    if std_counter_clockwise > std_clockwise
        % Image still needs to be rotated in counter-clockwise direction
        step_size = 0.5;
        theta = step_size;
    elseif std_counter_clockwise < std_clockwise
        % Image still needs to be rotated in clockwise direction
        step_size = -0.5;
        theta = step_size;
    else
        % Image is aligned perfectly
        aligned_img = rotated_img;
        return;
    end

    % To make the search more efficient, new angles are calculated until
    % the first one that has standard deviation of projections smaller than
    % the previous
    % Loop forward to find maximum standard deviation
    prev_std = max(std_counter_clockwise, std_clockwise);
    while true
        % Rotate the image
        rotated_test = rotateImage(rotated_img, theta, interp_method);
        rotated_test = cropBlackPadding(rotated_test);
        std_test = std(sum(rgb2gray(rotated_test), 2));

        if std_test > prev_std
            prev_std = std_test;
            theta = theta + step_size;
        else
            % Undo the last iteration to get the theta for maximum STD
            theta = theta - step_size; % undo the previous addition
            step_size = step_size / 5;
            break;
        end
    end

    % Rotate the image by the angle found at this stage
    rotated_img = cropBlackPadding(rotateImage(img, theta));
    prev_std = std(sum(rgb2gray(rotated_img), 2));

    % Loop backward to find more accurate result
    theta = -step_size;
    while true
        % Rotate the image
        rotated_test = rotateImage(rotated_img, theta, interp_method);
        rotated_test = cropBlackPadding(rotated_test);
        std_test = std(sum(rgb2gray(rotated_test), 2));

        if std_test > prev_std
            prev_std = std_test;
            theta = theta - step_size;
        else
            % Undo the last iteration to get the theta for maximum STD
            theta = theta + step_size;
            break;
        end
    end

    % Rotate the image by the refined angle to deskew it and crop unnecessary
    % padding
    aligned_img = cropBlackPadding(rotateImage(rotated_img, theta, interp_method));

    figure(1)
    imshow(aligned_img)

end

