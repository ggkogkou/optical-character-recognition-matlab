function [angle] = findRotationAngle(img)

    %   Estimate the skew angle of a rotated image
    %
    %   ------------------------------------------
    %
    %   Brief:
    %   Take an input rotated image 'img' and estimates the skew angle. The
    %   function returns 'angle', which is an approximation of the skew angle
    %
    %   The estimation process involves converting the image to grayscale,
    %   applying Gaussian blur to filter higher frequencies, computing the
    %   magnitude of the image's FFT (Fast Fourier Transform), focusing on the
    %   upper half of the FFT, selecting the brightest pixels, and calculating
    %   the rotation angle based on the position of the brightest pixel
    %
    %   Input:
    %   - img: Input rotated image
    %
    %   Output:
    %   - angle: Approximation of the skew angle in degrees
    %
    %   Example:
    %   % Load and estimate the skew angle of a rotated image
    %   img = imread('rotated_text.png');
    %   angle = findRotationAngle(img);
    %   fprintf("Skew angle estimate: %.2f degrees\n", angle);
    %
    %   See also: fft2, imgaussfilt, atan2, rad2deg

    % Standard deviation of the Gaussian distribution
    sigma_blur = 4;

    % Convert image to grayscale and calculate magnitude of image FFT
    % Center FFT and compute logarithm of magnitude
    img_fft_log = log(1 + abs(fftshift(fft2(imgaussfilt(rgb2gray(img), sigma_blur)))));

    % Focus on the upper half of the image, since FFT is symmetric
    img_height = size(img_fft_log, 1);
    img_width = size(img_fft_log, 2);

    half_img_height = ceil(img_height/2);
    half_img_width = ceil(img_width/2);

    % Check the central area of the image where the dominant line is easier
    % to be detected
    crop_x_start = half_img_width-ceil(0.05*img_width);
    crop_x_end = half_img_width+ceil(0.05*img_width);

    crop_y_start = half_img_height-ceil(0.05*img_height);
    crop_y_end = half_img_height+ceil(0.05*img_height);

    cropped_fft = img_fft_log(crop_y_start:crop_y_end, crop_x_start:crop_x_end);

    % Blur a bit the cropped FFT to enhance the dominant line
    cropped_fft = imgaussfilt(cropped_fft, 2);

    % Select the brightest pixel of FFT
    % At a second stage, check if the 2 border pixels are also the next
    % brighest
    [~, max_idx] = maxk(cropped_fft(1, :), 3);

    % Calculate distance from the mid-vertical
    dist_from_vertical = abs(ceil(size(cropped_fft, 2)/2) - max_idx(1));

    % Calculate rotation angle (convert to degrees)
    angle = atan2(dist_from_vertical, ceil(size(cropped_fft, 1)/2));
    angle = rad2deg(angle);

    % Determine if the image is rotated clockwise or counter-clockwise
    if max_idx(1) < ceil(size(cropped_fft, 1)/2)
        angle = -angle;
    end

    % Plot FFTs
    figure(1)
    imshow(img_fft_log, [])

    figure(2)
    imshow(cropped_fft, [])

end

