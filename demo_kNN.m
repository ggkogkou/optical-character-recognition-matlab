% A demo script to showcase the usage of the kNN classifier

% Load the image and text files
clc; clear;
img = imread("text1.png");
txt = 'text1.txt';

% Train a new kNN model for character classification
trainAndEvaluateClassifiers(img, txt);

