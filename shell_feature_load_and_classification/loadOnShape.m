%-------------------------------------------------------------------
% Preprocessing shape feature of shell data from raw data
%-------------------------------------------------------------------

clear all;
num_class=60;                                                              %set overall number of shell species
load_mat=[];
for cc=1:num_class
    A=xlsread('shelldata/selected_shell/shape_feature.xlsx',cc);           %load data from xlsx file
    [m,n]=find(isnan(A)==1);                                               %find NaN value in matrix
    A(m,:)=[];                                                             %remove NaN value in matrix
    A=A(:,1:size(A,2)-1);                                                  
    row_sample=2;                                                          %a sample is composed of 2 rows of value
    ss=size(A,1)/row_sample;                                               %the number of samples of one species
    E_A=zeros(ss,size(A,2)*2);
    for i=1:ss
        f_r = (i-1)*row_sample+1;                                          
        sample_feature = A(f_r:f_r+row_sample-1,:);                        %load features of one sample
        E_A(i,:)=sample_feature(:)';                                       %flatten features into one vector corresponding to one sample
    end
    v_label=repmat(cc,ss,1);                                    
    E_A=[E_A v_label];                                                     %add label information at the end of one sample
    load_mat=[load_mat;E_A];                                        
end
X = load_mat(:,1:size(load_mat,2)-1);
Y = load_mat(:,size(load_mat,2));
save('shell_shape_v4.mat','X','Y');                                        %save the shell shape features and make it a file