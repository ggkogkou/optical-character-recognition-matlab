function interpolatedContour = interpolateContour(contour, numPoints)

    % Interpolate a contour to have a specified number of points
    %
    % Inputs:
    %   contour - Original contour points [x, y]
    %   numPoints - Number of points for interpolation
    %
    % Output:
    %   interpolatedContour - Interpolated contour with numPoints
    
    % Compute the number of points in the original contour
    originalPoints = size(contour, 1);
    
    % Generate interpolation indices
    interpolationIndices = linspace(1, originalPoints, numPoints);
    
    % Perform interpolation to obtain the resampled contour
    interpolatedContour = interp1(1:originalPoints, double(contour), interpolationIndices);

end

