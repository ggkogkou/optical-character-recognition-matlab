function [angle] = findRotationAngle(img)

    % Function that makes an initial prediction about the skew angle
    % --------------------------------------------------------------
    %
    % @param img is the input rotated image
    %
    % @return angle is an approximation of the skew angle
    %
    % --------------------------------------------------------------
    %
    % If angle > 0, image is rotated clockwisely
    % else if angle < 0, image is rotated counterclockwisely
    %
    % --------------------------------------------------------------
    %
    % Convert image to grayscale 
    % Apply Gaussian blur to filter higher frequencies
    sigma_blur = 4;

    % Calculate magnitude of image FFT
    % Center FFT and compute logarithm of magnitude
    img_fft_log = log(1 + abs(fftshift(fft2(imgaussfilt(rgb2gray(img), sigma_blur)))));

    % Plot logarithm of FFT
    figure(2)
    imshow(img_fft_log, [])

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


    figure(3)
    imshow(cropped_fft, [])

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

end

