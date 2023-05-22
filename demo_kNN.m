% A demo script to showcase the usage of the kNN classifier

% Load the image and text files
clc; clear;
img = imread("text1.png");
txt = 'text1.txt';

% Number of interpolation points per class
N1 = 300;
N2 = 400;
N3 = 350;
interpolation_points = {N1, N2, N3};

% Train a new kNN model for character classification
trainAndEvaluateClassifiers(img, txt, interpolation_points);

