# Document Alignment

Document Alignment is a MATLAB-based project that aims to align text documents by correcting their skew angles. This tool is particularly useful when dealing with scanned or photographed documents that are not perfectly aligned, which can cause difficulties in subsequent processing steps such as optical character recognition (OCR).

The project provides a set of MATLAB functions that perform various steps of the alignment process, including:

1. Finding the approximate rotation angle using Fast Fourier Transform (FFT)
2. Rotating the image by the estimated angle
3. Iteratively refining the rotation angle to find the exact skew angle
4. Cropping black padding from the aligned image
5. Locating and extracting contours of individual characters in the aligned image

## Getting Started

To use the Document Alignment project, follow these steps:

1. Clone the GitHub repository to your local machine.
2. Install MATLAB on your computer if you haven't already.
3. Open MATLAB and navigate to the project directory.
4. Use the `alignDocument` function to align your text document.

```matlab
img = imread('text.png');
aligned_img = alignDocument(img);
imshow(aligned_img);
```

## Dependencies

The Document Alignment project has the following dependencies:

- MATLAB (R2018b or later)
- Image Processing Toolbox

Make sure you have these dependencies installed before using the project.

## Contributing

Contributions to the Document Alignment project are welcome! If you have any ideas for improvements or new features, feel free to open an issue or submit a pull request. Please follow the established code style and contribute in a respectful manner.

## License

The Document Alignment project is released under the [MIT License](LICENSE). You are free to use, modify, and distribute the code for personal and commercial purposes.

## Acknowledgments

The Document Alignment project relies on various algorithms and techniques. We would like to acknowledge the following resources:

- [MathWorks MATLAB Documentation](https://www.mathworks.com/help/matlab/) - Official documentation for MATLAB and its toolboxes

## Contact

If you have any questions, suggestions, or feedback, please feel free to contact us at [ggkogkou@ece.auth.gr](mailto:ggkogkou@ece.auth.gr).

Happy document alignment!

