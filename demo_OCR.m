% A demo script to showcase the functionality of readText function

% Clear console and workspace, and load the text image
clc; clear; img = imread("text1.png"); txt_file = 'text1.txt';

% Use readText to produce text from the text image
lines = readText(img);

% Concatenate the line strings into one text and write it to a file
output_file_dest = 'output.txt';
text = strjoin(lines, '\n');
fileID = fopen(output_file_dest, 'w');
fprintf(fileID, '%s', text);
fclose(fileID);

% Evaluate the OCR
actual_text = removeEmptyLinesAndSpaces(txt_file);
ocr_text = removeEmptyLinesAndSpaces(output_file_dest);

% Ensure that the strings have the same length
if numel(actual_text) ~= numel(actual_text)
    error("Strings must have the same length");
end

num_same_chars = 0;
num_different_chars = 0;

% Iterate over the characters of the strings and compare them
for i=1 : numel(actual_text)
    if actual_text(i) == ocr_text(i)
        num_same_chars = num_same_chars + 1;
    else
        num_different_chars = num_different_chars + 1;
    end
end

% Calculate accuracy
accuracy = num_same_chars / (num_same_chars + num_different_chars);

% Display the results
fprintf("Number of same characters: %d\n", num_same_chars);
fprintf("Number of different characters: %d\n", num_different_chars);
fprintf("Accuracy: %.4f\n", accuracy*100);

