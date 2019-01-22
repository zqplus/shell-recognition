image=imread('Vexillum rubrum(Broderip,1836)41Ó¼±ÊÂÝ¿Æ1.jpg');
% this script is used to extract color histogram from orignial image
% the result is in the color_feature, containing a 3*256 matrix for one
% shell image %%

RGB=image;
% Convert RGB image into L*a*b* color space.
X = rgb2lab(RGB);

% Create empty mask.
BW = false(size(X,1),size(X,2));

% Flood fill
row = 5;
column = 5;
tolerance = 2.000000e-02;
normX = sum((X - X(row,column,:)).^2,3);
normX = mat2gray(normX);
addedRegion = grayconnected(normX, row, column, tolerance);
BW = BW | addedRegion;

% Invert mask
BW = imcomplement(BW);

% find black background pixel numbers 
count_zero = length(find(BW==0));

% label different parts of image
labeledImage = bwlabel(BW);
shell_stats = regionprops(labeledImage,'BoundingBox');

% display RGB segmented images respectively
for i = 1:numel(shell_stats)
%for i = 1:1
    shell_single = ismember(labeledImage, i) > 0;
    %figure, imshow(shell_single);
    sub_size=find(shell_single ==1);
    [sub_size_x, sub_size_y]=size(sub_size);
    if sub_size_x > 200  %%% find the segment shell object %%%
        maskedRgbImage = bsxfun(@times, RGB, cast(shell_single, 'like', RGB)); %%% obtain the color shell object %%%
        %figure, imshow(maskedRgbImage);
        %shell_single_used=shell_single;
    end
%     maskedRgbImage = bsxfun(@times, RGB, cast(shell_single, 'like', RGB));
%     figure, imshow(maskedRgbImage);
%     axis on
%     xlabel x
%     ylabel y
end




%Split into RGB Channels
Red = maskedRgbImage(:,:,1);
Green = maskedRgbImage(:,:,2);
Blue = maskedRgbImage(:,:,3);

%Get histValues for each channel
[yRed, x] = imhist(Red);
[yGreen, x] = imhist(Green);
[yBlue, x] = imhist(Blue);

% substract the background numbers. As backgound is black, should be
% removed,when calculating the color histogram. %%%
back_ground=zeros(256,1);
back_ground(1,1)=count_zero;
yRed=yRed-back_ground;
yGreen=yGreen-back_ground;
yBlue=yBlue-back_ground;

% combine three R,G,B to one matrix,  get the raw results for shell color
% feature %%%
color_feature= [yRed';yGreen';yBlue'];


% %Split into RGB Channels
% Red = image(:,:,1);
% Green = image(:,:,2);
% Blue = image(:,:,3);
% 
% %Get histValues for each channel
% [yRed, x] = imhist(Red);
% [yGreen, x] = imhist(Green);
% [yBlue, x] = imhist(Blue);

%Plot them together in one plot
plot(x, yRed, 'Red', x, yGreen, 'Green', x, yBlue, 'Blue');

