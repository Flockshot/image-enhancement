% Reads Image1 from the directory and stores in img1 variable.
img1 = imread("Image1.png");

% Creates a figure of img1 and its histogram using the function imhist().
% Using subplot to show both image and histogram on same figure, with
% proper labels.
figure;
subplot(1,2,1), imshow(img1), xlabel("Fig.1: Image1.png");
subplot(1,2,2), imhist(img1), xlabel("Fig.2: Image1.png Histogram");

% Using histeq() function to apply histogram equalization technique, this
% balances out the contrast and hence in our image makes it so there is
% more difference between pixel intensity, therefore making the image more
% visible.
img1Eq = histeq(img1);

% Writing the equalized image to the directory with the name "Image1Output.png"
imwrite(img1Eq, "Image1Output.png");

% Creates a figure of the output and its histogram using the function imhist().
% Using subplot to show both image and histogram on same figure, with
% proper labels.
figure;
subplot(1,2,1), imshow(img1Eq), xlabel("Fig.1: Image1Output.png");
subplot(1,2,2), imhist(img1Eq), xlabel("Fig.2: Image1Output.png Histogram");

% We can see from the histogram of the output that the pixel intensities
% are now more far apart making them more balanced, and making our image
% more visible to view.

