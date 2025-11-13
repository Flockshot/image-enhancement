% Reads Image2 from the directory and stores in img2 variable.
% From the image we can see it has salt and pepper noise present in it, and
% to fix that I will be using median filter.
img2 = imread("Image2.png");

% size() functions returns the number of rows and columns in the image.
% storing the number of rows and columns as m and n.
[m, n] = size(img2);

% Creating new matrix of the image. Then adding 2 rows and columns of 0s to
% right and bottom.
% Basically adding extra layer of 0s to help in convolution.
img2Big = img2;
img2Big(m:m+2, n:n+2) = 0;


% https://www.mathworks.com/help/matlab/ref/circshift.html
% Using the circshift function to shift the img2Big one column to right and
% one row to bottom. To ensure that the image data is in the middle and one
% row of 0s appear below the data and one row appears on top, similarly for
% column, one column of 0s on right and one on right.
% Basically shifting the image data in the middle of the matrix.
% Doing all this to help with filter indexing in convolution.
img2BigShifted = circshift(img2Big,[1 1]);


% Initializing matrix for output image and input edges with 0s.
img2Output = zeros(m,n);
img2Edges = zeros(m,n);


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
        grid3x3 = img2BigShifted(x-1:x+1, y-1:y+1);

        % Using the formula provided in the slides for sobel operator.
        % Using it for calculation of derivative in y direction and x direction.
        fy1 = grid3x3(3,1)+weight*grid3x3(3,2)+grid3x3(3,3);
        fy = grid3x3(1,1)+weight*grid3x3(1,2)+grid3x3(1,3);
        fx1 = grid3x3(1,3)+weight*grid3x3(2,3)+grid3x3(3,3);
        fx = grid3x3(1,1)+weight*grid3x3(2,1)+grid3x3(3,1);

        % Applying the formula for sobel operater by finding the gradients
        % and storing the value in img2Edges, which will hold the edges of
        % input image.
        % Using x-1, y-1 here because our for loop starts from index 2, but
        % our output image will start from index 1.
        % Using sobel filter here, because it is a sharpening filter that
        % is used to find the edges of an image.
        % abs(fy1-fy) gives horizontal edges (derivative in y direction)
        % abs(fx1-fx) gives vertical edges (derivative in x direction)
        % combining both gives proper edges in the image.
        img2Edges(x-1, y-1) = abs(fy1-fy) + abs(fx1-fx);
        

        % https://www.mathworks.com/help/dsp/ref/convert2dto1d.html
        % First converting the filter grid3x3 to 1d, and then sorting the
        % values, because we are going to use median filter for output.
        sorted = sort(grid3x3(:), 2);
        
        % Taking the median of the sorted values in the filter mask grid
        % and the storing the value in the output image.
        % Using median filter for the output because in the slides it was
        % written it was the best known filter for removing the noise.
        % Using x-1, y-1 here because our for loop starts from index 2, but
        % our output image will start from index 1.
        img2Output(x-1,y-1) = median(sorted);
        
    end
end

% Initializing matrix for output image edges with 0s.
img2EdgesOutput = zeros(m,n);

% https://www.mathworks.com/help/matlab/ref/circshift.html
% Creating new matrix of the output image. Then adding 2 rows and columns
% of 0s to right and bottom.
% Basically adding extra layer of 0s to help in convolution.
% Then using the circshift function to shift the outputResized one column
% to right and one row to bottom. To ensure that the image data is in the
% middle and one row of 0s appear below the data and one row appears on
% top, similarly for column, one column of 0s on right and one on right.
% Basically shifting the image data in the middle of the matrix.
% Doing all this to help with filter indexing in convolution.
outputResized = img2Output;
outputResized(m:m+2, n:n+2) = 0;
outputShifted = circshift(outputResized,[1 1]);


% Loop for doing the convolution.
% Since our matrix has extra 0s on each side of the matrix, our data index
% starts from index 2, and since the data is shifted to right, I'm doing
% m+1 as the final index.
for x=2:(m+1)
    for y=2:(n+1)
        
        % creating the filter grid of 3x3, and filling it with output img data
        % x-1:x+1 and y-1:y+1 represents the filter centered on the pixel value.
        grid3x3 = outputShifted(x-1:x+1, y-1:y+1);
        
        % Using the formula provided in the slides for sobel operator.
        % Using it for calculation of derivative in y direction and x direction.
        fy1 = grid3x3(3,1)+weight*grid3x3(3,2)+grid3x3(3,3);
        fy = grid3x3(1,1)+weight*grid3x3(1,2)+grid3x3(1,3);
        fx1 = grid3x3(1,3)+weight*grid3x3(2,3)+grid3x3(3,3);
        fx = grid3x3(1,1)+weight*grid3x3(2,1)+grid3x3(3,1);

        % Applying the formula for sobel operater by finding the gradients
        % and storing the value in img2EdgesOutput, which will hold the edges
        % of the output image.
        % Using x-1, y-1 here because our for loop starts from index 2, but
        % our output image will start from index 1.
        % Using sobel filter here, because it is a sharpening filter that
        % is used to find the edges of an image.
        % abs(fy1-fy) gives horizontal edges (derivative in y direction)
        % abs(fx1-fx) gives vertical edges (derivative in x direction)
        % combining both gives proper edges in the image.
        img2EdgesOutput(x-1, y-1) = abs(fy1-fy) + abs(fx1-fx);

    end
end


% Creates a figure showing input image output image and edges of both input
% image and output image.
% Using subplot to show all 4 images on same figure, with proper labels.
% We can see from the edges images that we remove only noise from the image
% which means that we preserve the edges and the integrity of the image is
% fully intact.
figure;
subplot(2,2,1), imshow(img2), xlabel("Image2.png");
subplot(2,2,2), imshow(uint8(img2Output)), xlabel("Image2Output.png");
subplot(2,2,3), imshow(uint8(img2Edges)), xlabel("Image2.png Edges");
subplot(2,2,4), imshow(uint8(img2EdgesOutput)), xlabel("Image2Output.png Edges");
