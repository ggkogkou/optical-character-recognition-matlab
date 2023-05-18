function interpolated_contour = interpolateContour(contour, num_points)

    % Interpolate a contour to have a specified number of points
    % ----------------------------------------------------------
    %
    % Brief:
    %   This function takes a contour represented by a set of points and interpolates
    %   it to have a specified number of points.
    %
    % Input:
    %   - contour: A matrix representing the contour points, where each row
    %              represents the coordinates of a point.
    %   - num_points: The desired number of points after interpolation.
    %
    % Output:
    %   - interpolated_contour: A matrix representing the interpolated contour
    %                           points, where each row represents the coordinates
    %                           of a point
    %

    % Separate the x and y coordinates of the contour points
    x = contour(:, 1);
    y = contour(:, 2);

    % Calculate the indices for the interpolation
    indices = linspace(1, length(x), num_points);

    % Interpolate the x and y coordinates separately
    interpolated_x = interp1(1:length(x), x, indices, 'linear');
    interpolated_y = interp1(1:length(y), y, indices, 'linear');

    % Combine the interpolated x and y coordinates into a matrix
    interpolated_contour = [interpolated_x', interpolated_y'];

end

