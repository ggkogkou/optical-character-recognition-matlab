# Optical Character Recognition (OCR)

<p align="center">
  <img src="https://github.com/ggkogkou/optical-character-recognition-matlab/blob/master/cover.png" />
</p>

This repository provides an Optical Character Recognition (OCR) system implemented in MATLAB. The system is designed to extract text from images and perform character recognition using contour-based features and the k-Nearest Neighbors (kNN) algorithm. It offers a comprehensive set of features and functions for preprocessing images, extracting contour descriptors, training character classifiers, and evaluating the performance of the OCR system.

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Functionality](#functionality)
  - [Image Preprocessing](#image-preprocessing)
  - [Contour-based Feature Extraction](#contour-based-feature-extraction)
  - [k-Nearest Neighbors (kNN) Classification](#k-nearest-neighbors-knn-classification)
  - [Extended Test Set](#extended-test-set)
- [Requirements](#requirements)
- [Contributing](#contributing)
- [License](#license)

## Features

- **Image Preprocessing**: The OCR system applies a series of image processing techniques, such as binarization, noise removal, and contour extraction, to enhance the text extraction process.

- **Contour-based Feature Extraction**: The contour descriptors of characters are computed using the discrete Fourier transform (DFT) of the contour points. These descriptors capture the shape characteristics of the characters, enabling accurate character recognition.

- **k-Nearest Neighbors (kNN) Classification**: Separate kNN classifiers are trained for different character classes based on the number of contours. The classifiers utilize the extracted contour features to classify characters effectively.

- **Extended Test Set**: The test set is expanded to represent each contour of a letter separately. This allows the OCR system to handle characters with multiple contours, ensuring robust recognition performance.

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

The main function `evaluateCharacterRecognition` performs the evaluation of the OCR system using a test dataset. It calculates the weighted accuracy and displays the confusion matrix.

To use the OCR system on your own images:

1. Provide the image file and its corresponding text file in the `img` and `txt` variables, respectively, in the `evaluateCharacterRecognition` function.

2. Adjust the parameters, such as the train/test split ratio and the number of DFT coefficients, according to your requirements.

## Functionality

The OCR system provides several key functionalities:

### Image Preprocessing

The system applies various image preprocessing techniques to enhance the text extraction process. These techniques include:

- Binarization: Converting the image into a binary representation, separating the foreground (text) from the background.
- Noise Removal: Removing noise and artifacts from the image, improving the quality of the extracted text.
- Contour Extraction: Identifying and extracting contours from the binary image, representing the shape of individual characters.

### Contour-based Feature Extraction

The OCR system computes contour descriptors for each character using the discrete Fourier transform (DFT) of the contour points. These descriptors capture the shape characteristics of the characters and serve as the input features for the character classifiers.

### k-Nearest Neighbors (kNN) Classification

The system trains separate kNN classifiers for each character class based on the number of

 contours. The trained classifiers utilize the extracted contour features to perform character recognition. The kNN algorithm compares the features of a test character with the features of the training characters and assigns it to the most similar class.

### Extended Test Set

The test set is expanded to represent each contour of a letter separately. This allows the OCR system to handle characters with multiple contours accurately. By considering each contour as a separate character instance, the system enhances the recognition performance for complex characters.

## Requirements

- MATLAB R2019a or later

## Contributing

See [CONTRIBUTING](CONTRIBUTING.md)

## License

This project is licensed under the [GPL-3.0 License](LICENSE).

Please feel free to explore the repository further and make any necessary modifications to meet your specific needs.
