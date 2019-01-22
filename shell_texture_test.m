image=imread('Carpiscula procera193.jpg');
%%%%%%% this function is used to extract raw texture features of shell %%%%
%%%%%%% using gabor filter %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

% Active contour   %%% note some deviation point could be remove
% successfully when using active contour, may be useful in some shell
% images 
iterations = 5;
BW = activecontour(X, BW, iterations, 'Chan-Vese');

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
    if sub_size_x > 160
        maskedRgbImage = bsxfun(@times, RGB, cast(shell_single, 'like', RGB));
        figure, imshow(maskedRgbImage);
        axis on
        xlabel x
        ylabel y
        shell_single_used=shell_single;
    end
%     maskedRgbImage = bsxfun(@times, RGB, cast(shell_single, 'like', RGB));
%     figure, imshow(maskedRgbImage);
%     axis on
%     xlabel x
%     ylabel y
end

%%%%%%%%%%crop shell image randomly, have 200 small samples, each size is
%%%%%%%%%%20*20 pixel, then record corresponding coordinate%%%%%%%%%%%%%
size_record_y=0;
record_x=[];
record_y=[];
while size_record_y<200
    ra=randi(281,1,1);
    rb=randi(381,1,1);
    crop_try=shell_single_used(ra:(ra+19),rb:(rb+19)); 
    if (crop_try == 1)
        record_x(end+1)=ra;  %%%% record crop point coordinate
        record_y(end+1)=rb;
    end
    [size_record_x,size_record_y]=size(record_x);
end

%%%%%% using gabor filter to extract texture feature%%%%%%%%%
gabor_results=[];
for i =1:200
    rgb_crop=imcrop(maskedRgbImage,[record_y(i),record_x(i),19,19]);  %%%% crop 20*20 images from shell image  %%% fuck record_y record_x 
    rgb_gray = rgb2gray(rgb_crop); %%%% this gabor in matlab only can deal with 2d maxtrix %%%%
%     figure(i+1)
%     imshow(rgb_gray);
    wavelength = 5;
    orientation = [0 45 90 135];
    g = gabor(wavelength,orientation); 
    outMag = imgaborfilt(rgb_gray,g); %%%% generate 20*20*4 matrix, as using 4 orientation 
%     gabor_results=[gabor_results;outMag];
    gabor_results=cat(3,gabor_results,outMag);  %%%% concatenating 20 matrixs on 3rd dimension, after that obtaining 20*20*80 matrix%%%%
end                                               %%%% 800 means 4*200, 200 matrix concatenating together %%%%%%%%%%%%

%%%%%% using wavelength of 10
for i =1:200
    rgb_crop=imcrop(maskedRgbImage,[record_y(i),record_x(i),19,19]);  %%%% crop 20*20 images from shell image
    rgb_gray = rgb2gray(rgb_crop); %%%% this gabor in matlab only can deal with 2d maxtrix %%%%
    wavelength = 10;
    orientation = [0 45 90 135];
    g = gabor(wavelength,orientation); 
    outMag = imgaborfilt(rgb_gray,g); %%%% generate 20*20*4 matrix, as using 4 orientation 
%     gabor_results=[gabor_results;outMag];
    gabor_results=cat(3,gabor_results,outMag);  %%%% concatenating 20 matrixs on 3rd dimension, after that obtaining 20*20*80 matrix%%%%
end                                               %%%% 80 means 4*20, 20 matrix concatenating together %%%%%%%%%%%%

%%%%%% using wavelength of 15
for i =1:200
    rgb_crop=imcrop(maskedRgbImage,[record_y(i),record_x(i),19,19]);  %%%% crop 20*20 images from shell image
    rgb_gray = rgb2gray(rgb_crop); %%%% this gabor in matlab only can deal with 2d maxtrix %%%%
    wavelength = 15;
    orientation = [0 45 90 135];
    g = gabor(wavelength,orientation); 
    outMag = imgaborfilt(rgb_gray,g); %%%% generate 20*20*4 matrix, as using 4 orientation 
%     gabor_results=[gabor_results;outMag];
    gabor_results=cat(3,gabor_results,outMag);  %%%% concatenating 20 matrixs on 3rd dimension, after that obtaining 20*20*80 matrix%%%%
end                                               %%%% 80 means 4*20, 20 matrix concatenating together %%%%%%%%%%%%


%%%%%% using wavelength of 20
for i =1:200
    rgb_crop=imcrop(maskedRgbImage,[record_y(i),record_x(i),19,19]);  %%%% crop 20*20 images from shell image
    rgb_gray = rgb2gray(rgb_crop); %%%% this gabor in matlab only can deal with 2d maxtrix %%%%
    wavelength = 20;
    orientation = [0 45 90 135];
    g = gabor(wavelength,orientation); 
    outMag = imgaborfilt(rgb_gray,g); %%%% generate 20*20*4 matrix, as using 4 orientation 
%     gabor_results=[gabor_results;outMag];
    gabor_results=cat(3,gabor_results,outMag);  %%%% concatenating 20 matrixs on 3rd dimension, after that obtaining 20*20*80 matrix%%%%
end                                               %%%% 80 means 4*20, 20 matrix concatenating together %%%%%%%%%%%%

%%%%%% using wavelength of 25
for i =1:200
    rgb_crop=imcrop(maskedRgbImage,[record_y(i),record_x(i),19,19]);  %%%% crop 20*20 images from shell image
    rgb_gray = rgb2gray(rgb_crop); %%%% this gabor in matlab only can deal with 2d maxtrix %%%%
    wavelength = 25;
    orientation = [0 45 90 135];
    g = gabor(wavelength,orientation); 
    outMag = imgaborfilt(rgb_gray,g); %%%% generate 20*20*4 matrix, as using 4 orientation 
%     gabor_results=[gabor_results;outMag];
    gabor_results=cat(3,gabor_results,outMag);  %%%% concatenating 20 matrixs on 3rd dimension, after that obtaining 20*20*80 matrix%%%%
end                                               %%%% 80 means 4*20, 20 matrix concatenating together %%%%%%%%%%%%

%%%%%%%  calculate 3 sub-features for 20*20, then 20*20*4000 matrix would
%%%%%%%  be regenerated to 3*4000 matrix, 4000 means using different gabor
%%%%%%%  filters (20 filters) for 200 sub-samples %%%%%%%%%%%%%%%%%%%%%%%%
[gabor_x,gabor_y,gabor_z] = size(gabor_results);
window = gabor_x * gabor_y;
average_value=[];
gabor_results_three = [];
for i = 1:gabor_z
    gabor_k1=gabor_results(:,:,i);
    sum_value=sum(gabor_k1(:));
    average_value = sum_value/window; %%% calculate average value
    energy_tem = gabor_k1.^2;
    energy_sum = sum(energy_tem(:));
    energy_gabor = energy_sum/window;   %%%% calculate energy 
    %entropy_gabor = entropy(gabor_k1);
    gabor_k2 = abs(gabor_k1)/window;
    entropy_gabor = - sum(gabor_k2(gabor_k2~=0).*log2(gabor_k2(gabor_k2~=0)));  %%%% calculate entropy 
    three_features = [average_value energy_gabor entropy_gabor];
    gabor_results_three = cat(1,gabor_results_three,three_features);   %%%%  4000 results with 3 features %%%% here is raw result of texture extraction for shell images %%
end


