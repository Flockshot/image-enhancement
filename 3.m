% Reads Image3 from the directory and stores in img3 variable.
img3 = imread("Image3.png");

% size() functions returns the number of rows and columns in the image.
% storing the number of rows and columns as m and n.
[m, n] = size(img3);

% Creating new matrix of the image. Then adding 2 rows and columns of 0s to
% right and bottom.
% Basically adding extra layer of 0s to help in convolution.
img3Big = img3;
img3Big(m:m+2, n:n+2) = 0;

% https://www.mathworks.com/help/matlab/ref/circshift.html
% Using the circshift function to shift the img3Big one column to right and
% one row to bottom. To ensure that the image data is in the middle and one
% row of 0s appear below the data and one row appears on top, similarly for
% column, one column of 0s on right and one on right.
% Basically shifting the image data in the middle of the matrix.
% Doing all this to help with filter indexing in convolution.
img3BigShifted = circshift(img3Big,[1 1]);

% Initializing matrix for output image and input edges with 0s.
img3Output = zeros(m,n);
img3Edges = zeros(m,n);

% Initializing the weight for sobel filter.
% Choosing 2 to give more importance to the center pixel in regards to the
% edges.
weight = 2;

% Loop for doing the convolution.
% Since our matrix has extra 0s on each side of the matrix, our data index
% starts from index 2, and since the data is shifted to right, I'm doing
% m+1 as the final index.
for x=2:(m+1)
    for y=2:(n+1)
        
        % creating the filter grid of 3x3, and filling it with img data
        % x-1:x+1 and y-1:y+1 represents the filter centered on the pixel value.
        grid3x3 = img3BigShifted(x-1:x+1, y-1:y+1);
        
    
        % Taking the min of the values in the filter mask grid and then 
        % storing the value in the output image.
        % Using min filter as according to the slides it darkens the image,
        % and hence this removes the less brighter stars and only the
        % brightest star will remain, which is what we need.
        % Using x-1, y-1 here because our for loop starts from index 2, but
        % our output image will start from index 1.
        img3Output(x-1,y-1) = min(grid3x3(:), [], 'all');
        
    end
end

% Using uint8 to convert the double matrix to type unint8 suitable for images.
properOutput = uint8(img3Output);
% Creating new matrix and initializing to 0s to further process the image by thresholding.
properOutputSegmentation = zeros(m,n);

% Loop to iterate through the whole output image.
% Using this for thresholding with value of 80, Thresholding because we
% need to segment the brightest star, and thresholding is one way of doing
% so. Above we initialized the matrix with all 0s, now only the pixels with
% intensity greater than 80 from the output image will make it into the
% further processed output image.
for x=1:m
    for y=1:n
        if(properOutput(x,y)>=80)
            properOutputSegmentation(x,y) = properOutput(x,y);
        end
    end
end


% Creates a figure showing input image output image
% Using subplot to show both images on same figure, with proper labels.
figure;
subplot(2,2,1), imshow(img3), xlabel("Image3.png");
subplot(2,2,2), imshow(uint8(properOutputSegmentation)), xlabel("Image3Output.png");
