% A demo to showcase the functionality of the image deskewing feature

% Load an image that is algned
img = imread("text1.png");

% Apply a rotation from -45 to 45 degrees
rot_angle = -30;
img_rot = imrotate(img, rot_angle);
imshow(img_rot)

% Use alignDocument function to undo the skew that was applied
img_aligned = alignDocument(img_rot);

% Plot the deskewed image
figure
imshow(img_aligned)
title("FINAL ALIGNED IMAGE 1st")

% Showcase the deskewing for a skew to the other direction
img_rot = imrotate(img, abs(rot_angle));
img_aligned = alignDocument(img_rot);

% Plot the deskewed image
figure
imshow(img_aligned)
title("FINAL ALIGNED IMAGE 2nd")