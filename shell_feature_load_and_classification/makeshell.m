%------------------------------------------------------------------------
% assemble all features to make a compeleted shell data
%------------------------------------------------------------------------


clear all;
load('shell_color_v3.mat');                                                %load color feature of shell
f_c=X;
load('shell_shape_v4.mat');                                                %load shape feature of shell
f_s=X;
load('shell_texture1_flatten_v3.mat');                                     %load texture feature of shell
[coeff2,score2,latent,tsquared,explained,mu2] = pca(X);                    %principle component analysis on texture to reduce the dimensions
f_t=score2(:,1:10);                                                        %pick top 10 infleutial components and calculate their projected values  
X=[f_c,f_s,f_t];                                                           %put features altogether
X=zscore(X);                                                               %feature standarization
save('new_shell_compv7.mat','X','Y');
