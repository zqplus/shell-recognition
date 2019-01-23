%-------------------------------------------------------------------
% Random Forest classification on shell data
%-------------------------------------------------------------------
clear all;
load shell_texture1_flatten_v3.mat                                         %load shell data

class_sample=unique(Y);
numLabels=length(class_sample);                                            %number of species
numInstance=size(X,1);                                                     %number of instance

iters=30;                                                                  %30 iterations using hand-out method for testing
ratio=0.7;                                                                 %testset:trainset=3:7

for t=100:100:800                                                          %search for optimal number of trees

for i=1:iters
    
    %prepare training set and test set using random sampling
    train_X=[];
    train_Y=[];
    test_X=[];
    test_Y=[];
    for cc=1:numLabels
       num_ins=sum(Y==cc);
       SubX=X(Y==cc,:);
       SubY=Y(Y==cc,:);
       train_size=floor(ratio*num_ins);
       train_index=randperm(num_ins,train_size);
       test_index=setdiff(1:num_ins,train_index);
       train_X=[train_X;SubX(train_index,:)];
       train_Y=[train_Y;SubY(train_index,:)];
       test_X=[test_X;SubX(test_index,:)];
       test_Y=[test_Y;SubY(test_index,:)];
    end
  
    %classifier setting
    opts= struct;
    opts.numTrees= t;
    opts.verbose= true;
    
    %classification using Random Forest
    m= forestTrain(train_X, train_Y, opts); 
    yhatTrain = forestTest(m, test_X);
    accuracy=sum(yhatTrain==test_Y)/length(test_Y);                        %calculate the accuracy of each iteration
    results(i)=accuracy;                                                   %save the accuracy
end
    results=results';
    RESULTS(:,t/100)=results;
end
fprintf(['Accuracy: ' num2str(mean(results)*100) '%' '/n']);
