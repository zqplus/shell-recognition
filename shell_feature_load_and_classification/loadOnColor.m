%-------------------------------------------------------------------
% Preprocessing color feature of shell data from raw data
%-------------------------------------------------------------------

clear all;

num_class=60;                                                              %set overall number of shell species
load_mat=[];
for cc=1:num_class
    A=xlsread('shelldata/selected_shell/color_feature_raw.xlsx',cc);           %load data from .xlsx file
    [m,n]=find(isnan(A)==1);                                        
    A(m,:)=[];                                                             %remove the NaN elements
    row_sample=6;                                                          %every 6 rows belongs to one sample
    ss=size(A,1)/row_sample;                                               %number of samples of cc-th class
    E_A=zeros(ss,row_sample*2);
    for i=1:ss
        f_r = (i-1)*6+1;                                            
        pro_mx = A(f_r:f_r+row_sample-1,:);                                %extract data of one sample
        w_mx = repmat(1:256,row_sample,1);                                 %matrix of RGB values
        useful_mx=pro_mx.*w_mx;                                            %calculate the real values from histgram RGB values
        avg_rgb=mean(useful_mx,2);                                         %calculate the average overall RGB value of each row
        std_rgb=std(useful_mx,0,2);                                        %calculate the standard deviation of RGB value of each row
        sample_feature=[avg_rgb' std_rgb'];                                %save average RGB value and standard deviation of RGB value as features of one sample
        E_A(i,:)=sample_feature;                                           %save one sample
    end
    v_label=repmat(cc,ss,1);                                               %make label
    E_A=[E_A v_label];                                                     %add label information at the end of each sample
    load_mat=[load_mat;E_A];
end
X = load_mat(:,1:size(load_mat,2)-1);                   
Y = load_mat(:,size(load_mat,2));
save('shell_color_v3.mat','X','Y');                                        %save the result as color feature of shell