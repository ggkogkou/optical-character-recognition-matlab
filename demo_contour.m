% A demo that showcases the getContour functionality

% Display the contours of "a", "f", "l" and "f"
a = imread("a.png");
f = imread("f.png");
l = imread("l.png");
e = imread("e.png");

% Get the contour cell arrays
a_contour = getContour(a);
f_contour  = getContour(f);
l_contour  = getContour(l);
e_contour  = getContour(e);

