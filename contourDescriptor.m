function [descriptor] = contourDescriptor(contour)

    % Compute the outline descriptor for a given contour
    % --------------------------------------------------
    %
    % Brief:
    %   This function computes the outline descriptor for a given contour. It
    %   first converts the contour points into a complex sequence and then
    %   computes the discrete Fourier transform (DFT) of the sequence. The
    %   resulting DFT coefficients form the outline descriptor, excluding the
    %   first term.
    %
    % Input:
    %   contour - The contour points [x, y]
    %
    % Output:
    %   descriptor - The descriptor computed using the DFT of the contour
    %
    % Example:
    %   contour = [x, y];
    %   descriptor = contourDescriptor(contour);

    % Compute the complex sequence r[i]
    r = contour(:, 1) + 1i * contour(:, 2);
    
    % Compute the DFT of the sequence
    Ri = fft(r);
    
    % Compute the measure of the contour (excluding the first term)
    descriptor = abs(Ri(2:end));

end

