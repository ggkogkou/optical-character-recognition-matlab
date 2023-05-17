function [distance] = distanceCriterion(descriptor1, descriptor2)
    
    % Computes the distance criterion between two contour descriptors
    % ---------------------------------------------------------------
    %
    % Brief:
    %   This function computes the distance criterion between two contour
    %   descriptors. The contour descriptors are represented as arrays of
    %   DFT coefficients computed using the outlineDescriptor function. The
    %   distance criterion is the squared error distance between the
    %   corresponding coefficients of the two descriptors
    %
    % Input:
    %   descriptor1 - The first contour descriptor
    %   descriptor2 - The second contour descriptor
    %
    % Output:
    %   distance - The squared error between the two descriptors
    %
    % Example:
    %   desc1 = contourDescriptor(contour1);  % Contour 1 descriptor
    %   desc2 = contourDescriptor(contour2);  % Contour 2 descriptor
    %   distance = distanceCriterion(desc1, desc2);

    % Compute the squared error of the descriptors
    distance = abs(descriptor1) - abs(descriptor2);
    distance = sum(distance.^2);

end

