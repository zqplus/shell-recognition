%%%%% this script is aimed to extract shape feature of shell image %%%%%
clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
imtool close all;  % Close all imtool figures.
clear;  % Erase all existing variables.
workspace;  % Make sure the workspace panel is showing.
format longg;
format compact;
fontSize = 20;
% Read in the color image.
folder = 'C:\Users\zq\Desktop\shell\all_shape_feature';  %%% you should change to your file path 
baseFileName = 'Conus textile341.jpg'; %%% this test shell image has been upload 
% Get the full filename, with path prepended.
fullFileName = fullfile(folder, baseFileName);
if ~exist(fullFileName, 'file')
  % Didn't find it there.  Check the search path for it.
  fullFileName = baseFileName; % No path this time.
  if ~exist(fullFileName, 'file')
    % Still didn't find it.  Alert user.
    errorMessage = sprintf('Error: %s does not exist.', fullFileName);
    uiwait(warndlg(errorMessage));
    return;
  end
end
rgbImage = imread(fullFileName);
% Get the dimensions of the image.  
[rows columns numberOfColorBands] = size(rgbImage);
% Display the original color image.
subplot(2, 2, 1);
imshow(rgbImage, []);
axis on;
title('Original Color Image', 'FontSize', fontSize);
% Enlarge figure to full screen.
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);

% Convert RGB image into L*a*b* color space.
X = rgb2lab(rgbImage);

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

% Active contour   %%% note some deviation point could be remove
% successfully when using active contour, may be useful in some shell
% images 
% iterations = 5;
% BW = activecontour(X, BW, iterations, 'Chan-Vese');


binaryImage=BW;

subplot(2,2,2);
imshow(binaryImage, []);
axis on;
title('Binary Image', 'FontSize', fontSize);
[labeledImage numberOfBlobs] = bwlabel(binaryImage, 8);     % Label each blob so we can make measurements of it
% Get the centroid.
blobMeasurements = regionprops(labeledImage, 'Centroid');
xCenter = blobMeasurements(1).Centroid(1);
yCenter = blobMeasurements(1).Centroid(2);
% bwboundaries() returns a cell array, where each cell contains the row/column coordinates for an object in the image.
% Plot the borders of all the coins on the original grayscale image using the coordinates returned by bwboundaries.
subplot(2,2,3);
imshow(rgbImage);
axis on;
title('Outlines, from bwboundaries()', 'FontSize', fontSize);
hold on;
% Plot the centroid.
plot(xCenter, yCenter, 'r+', 'MarkerSize', 20, 'LineWidth', 3);
boundaries = bwboundaries(binaryImage);
numberOfBoundaries = size(boundaries);

[boun_a, boun_b]=size(boundaries{1});
max_boundary = boun_a;
max_k=1;
for k = 1:numberOfBoundaries
    [bo_a, bo_b]=size(boundaries{k});
    if bo_a > max_boundary
        max_boundary=bo_a;
        max_k=k;
    end
end



%for k = 1 : numberOfBoundaries
for k = max_k : max_k
  thisBoundary = boundaries{k};
  plot(thisBoundary(:,2), thisBoundary(:,1), 'r', 'LineWidth', 3);
  % for each boundary, calculate the angle an distance as a function of boundary point.
  numberOfBoundaryPoints = length(thisBoundary);
  angles = zeros(1, numberOfBoundaryPoints);
  distances = zeros(1, numberOfBoundaryPoints);
  for p = 1 : numberOfBoundaryPoints
    xb = thisBoundary(p,2);
    yb = thisBoundary(p,1);
    angles(p) = atand((yb-yCenter) / (xb-xCenter));
    distances(p) = sqrt((xb-xCenter)^2+(yb-yCenter)^2);
  end
  % Plot them
  subplot(4, 2, 6);
  plot(angles, 'LineWidth', 3);
  caption = sprintf('Angles for blob #%d', k);
  title(caption, 'FontSize', fontSize);
  grid on;
  subplot(4, 2, 8);
  plot(distances, 'LineWidth', 3);
  grid on;
  caption = sprintf('Distances for blob #%d', k);
  title(caption, 'FontSize', fontSize);
  % Prompt user for the next blob, if there is one.
  if numberOfBoundaries > 1
    promptMessage = sprintf('Do you want to Continue processing,\nor Cancel processing?');
    titleBarCaption = 'Continue?';
    button = questdlg(promptMessage, titleBarCaption, 'Continue', 'Cancel', 'Continue');
    if strcmpi(button, 'Cancel')
      break;
    end
  end
end
hold off;

%%%%%%this part is aim to calculate corresponding distances based on every
%%%%%%5 degree (you also can change different degree you want), then
%%%%%%generate shape features in obtain variant.
%%%%%%
correct_a1=round(angles); %%%%%% obtain angle values, note the range only from -90 to 90 degree, you should 
trans_point=find(correct_a1 <= -88);     %%%% convert to 0 to 360 degree or sort of monotonous increasing degree
trans_point1=trans_point(1:1);  %%% two point should be converted around -90 degree 
k1=correct_a1;
trans_p2=0;
trans_pp2=0;
trans2_p=0;
trans2_pp=0;
k1=[correct_a1(1:trans_point1-1),correct_a1(trans_point1:end)+180]; %%% finish converting one point just plus 180
trans_add=find(k1 >= 268);
if length(trans_add)==0
    trans_add=0;
end
trans_add_point=trans_add(end);

trans2_p=find(k1 >= 269);
if length(trans2_p)==0
    trans2_p=0;
end
trans_p2=trans2_p(end:end);

trans2_pp=find(k1 >= 270);
if length(trans2_pp)==0
    trans2_pp=0;
end
trans_pp2=trans2_pp(end:end);

if trans_p2>trans_add_point
    trans2=trans_p2;
else
    trans2=trans_add_point;   
end

if trans_pp2>trans_p2
    trans2=trans_pp2;
elseif trans_pp2<trans_p2
    trans2=trans_p2;
end

% if trans_pp2>trans_p2
%     trans2=trans_pp2;
% else
%     trans2=trans_p2;
% end
k2=[k1(1:trans2),k1(trans2+1:end)+180]; %%% continue to converting second point just plus 180 then they are 
m=k2(1:1);                              %%%  monotonous increasing degree
obtain=[];
for i = 1:length(k2)
    if k2(i:i)==m | k2(i:i)==(m+1)|k2(i:i)==(m+2)|k2(i:i)==(m+3)|k2(i:i)==(m+4)|k2(i:i)==(m+5)|k2(i:i)==(m+6)
        obtain(end+1)=distances(i:i);
        %obtain(end+1)=obtain_unify(1:72);
        m=m+5;  %%%% every five degree to find a distance, note if some degree are not continuous, using 
    end         %%%% k2(i:i)==m | k2(i:i)==(m+1) find next degree point is effective
end
obtain=obtain(1:end-1);  %%% here is shape feature result 

