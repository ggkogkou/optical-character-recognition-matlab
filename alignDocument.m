function [img_deskewed] = alignDocument(img)

    % Function to determine deskew angle of text image and align it
    % --------------------------------------------------------------
    %
    % @param img is the input rotated image
    %
    % @return img_deskewed is the deskewed image
    %
    % --------------------------------------------------------------
    %
    % Read the image
    img = imread('text1.png');

    rr = rotateImage(img, -30);
    imshow(rr, [])



end

