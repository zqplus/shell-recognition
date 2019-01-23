%-------------------------------------------------------------------
% Preprocessing texture feature of shell data from raw data
%-------------------------------------------------------------------

clear all;
num_class=60;                                                              %set the overall number of shell species
load_mat=[];    
for cc=1:num_class
    A=xlsread('shelldata/selected_shell/texture_feature_raw.xlsx',cc);         %load data from xlsx file
    [m,n]=find(isnan(A)==1);                                               %find NaN elements in matrix
    A(m,:)=[];                                                             %remove NaN elements in matrix
    row_sample=3;                                                          %a sample is composed of 3 rows of feature
    ss=size(A,1)/row_sample;                                               %the number of samples
    E_A=zeros(ss,size(A,2)*row_sample);
    for i=1:ss
        f_r = (i-1)*3+1;                                                
        pro_mx = A(f_r:f_r+row_sample-1,:);                                %extract feature value of one sample
        useful_mx=pro_mx;
        useful_mx=useful_mx(:)';                                           %flatten the feature matrix in a vactor corresponding to one sample
        E_A(i,:)=useful_mx;
    end
    v_label=repmat(cc,ss,1);
    E_A=[E_A v_label];                                                     %add label information at the end of the sample
    load_mat=[load_mat;E_A];
end

X = load_mat(:,1:size(load_mat,2)-1);
Y = load_mat(:,size(load_mat,2));
save('shell_texture1_flatten_v3.mat','X','Y');                             %save shell texture feature and make it a file