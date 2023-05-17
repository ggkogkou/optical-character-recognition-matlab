function [cleared_file] = removeEmptyLinesAndSpaces(input_file)

    % Remove empty lines and trailing spaces from a text file
    % -------------------------------------------------------
    %
    % Brief:
    %   This function removes empty lines and trailing spaces from a text file,
    %   resulting in a cleared text. It reads the content of the input file,
    %   removes spaces at the end of each line, filters out empty lines, and
    %   returns the cleared text as a single string.
    %
    % Inputs:
    %   input_file (string) - The path to the input text file
    %
    % Output:
    %   cleared_file (string) - The cleared text as a single string
    %
    % Example:
    %   cleared_file = removeEmptyLinesAndSpaces('text1.txt');

    % Open the input and output files
    file_id_in = fopen(input_file, 'r');

    % Read the file into a cell array
    data = textscan(file_id_in, '%s', 'Delimiter', '\n');

    % Remove spaces at the end of each line
    trimmed_lines = strtrim(data{1});

    % Filter out empty lines
    non_empty_lines = trimmed_lines(~cellfun('isempty', trimmed_lines));

    % Return cleared text as string
    cleared_file = strjoin(non_empty_lines);

end
