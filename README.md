# Optical Character Recognition (OCR)

<p align="center">
  <img src="https://github.com/ggkogkou/optical-character-recognition-matlab/blob/master/cover.png" />
</p>

This repository provides an Optical Character Recognition (OCR) system implemented in MATLAB. The system is designed to extract text from images and perform character recognition using contour-based features and the k-Nearest Neighbors (kNN) algorithm. It offers a comprehensive set of features and functions for preprocessing images, extracting contour descriptors, training character classifiers, and evaluating the performance of the OCR system.

## Installation

To use the OCR system, follow these steps:

1. Clone the repository:

   ```bash
   git clone https://github.com/ggkogkou/optical-character-recognition-matlab.git
   ```

2. Launch MATLAB and navigate to the project directory:

   ```matlab
   cd optical-character-recognition-matlab
   ```

3. Run the `evaluateCharacterRecognition` function to evaluate the performance of the OCR system using the provided test images.

## Usage

To use the OCR system, follow these steps:

1. Prepare the training dataset: Collect a dataset of images containing printed characters. Annotate the characters in the images and split the dataset into training and test sets.

2. Train the classifiers: Use the training dataset to train the kNN classifiers. Extract features from the characters and use them to train the classifiers. Save the trained classifiers in a `.mat` file.

3. Run the OCR system: Use the `readText` function to perform OCR on an input image. Provide the path to the image as an argument to the function. The function will load the trained classifiers, process the image, and return the extracted text.

```matlab
lines = readText('input_image.png');
```

4. Evaluate the results: Compare the extracted text with the ground truth to evaluate the accuracy of the OCR system. Use appropriate evaluation metrics such as character-level accuracy or word-level accuracy.

## Example

```matlab
% Load the input image
img = imread('input_image.png');

% Perform OCR to extract the text
lines = readText(img);

% Display the extracted text
for i = 1:numel(lines)
    disp(lines{i});
end
```

## Features

The OCR system provides several key functionalities:

### Text line extraction: 
The system can extract individual lines of text from an input image.
### Character segmentation: 
It segments the characters within each text line to isolate them for further processing.
### Feature extraction: 
The system extracts relevant features from the segmented characters to represent them numerically.
### Training of classifiers: 
It trains k-Nearest Neighbors (kNN) classifiers using the extracted features to recognize characters.
#### Text reconstruction: 
Based on the trained classifiers, the system reconstructs the text by predicting the characters in each line.
### Output generation: 
The reconstructed text is stored as a cell array and can be written to a text file.

## Requirements

To run the OCR system, ensure that you have the following prerequisites:

  - MATLAB
  - Image Processing Toolbox: This toolbox provides a collection of functions and algorithms for image preprocessing, segmentation, and manipulation.
  - Statistics and Machine Learning Toolbox: This toolbox contains the necessary functions and algorithms for machine learning, including kNN classification.

## Contributing

See [CONTRIBUTING](CONTRIBUTING.md)

## License

This project is licensed under the [GPL-3.0 License](LICENSE).

Please feel free to explore the repository further and make any necessary modifications to meet your specific needs.
