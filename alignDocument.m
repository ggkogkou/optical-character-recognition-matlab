function [aligned_img] = alignDocument(img)

    %   Align a text image with skew [-45, 45] degrees
    %   ----------------------------------------------
    %
    %   Brief:
    %   This function takes an input image 'img' and performs
    %   deskewing to align the text image. The function returns 'aligned_img',
    %   which is the fully aligned image.
    %
    %   The alignment process involves finding the approximate rotation angle
    %   using the FFT, rotating the image by the estimated angle, and then
    %   iteratively refining the rotation angle to find the exact skew angle
    %
    %   Input:
    %   - img: Input image of the text
    %
    %   Output:
    %   - aligned_img: Aligned text image
    %
    %   Example:
    %   % Load and align a text image
    %   img = imread('text1.png');
    %   aligned_img = alignDocument(img);
    %   imshow(aligned_img);
    %
    %   See also: findRotationAngle, rotateImage, cropBlackPadding

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

