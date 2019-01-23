%-------------------------------------------------------------------
% KNN classification on shell data
%-------------------------------------------------------------------

clear all;
load new_shell_compv7.mat                                                  %load shell data
 
class_sample=unique(Y);                                                    
numLabels=length(class_sample);                                            %number of species
numInstance=size(X,1);                                                     %number of instance

iters=30;                                                                  %30 iterations using hand-out method for testing
ratio=0.7;                                                                 %testset:trainset=3:7

results=zeros(5,iters);     

for k=1:10                                                                 %search for optimal k value setting

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
    
    %classification using K-NN
    Mdl = fitcknn(train_X,train_Y,'NumNeighbors',k);    
    predictLabel = predict(Mdl,test_X)
    accuracy=sum(predictLabel==test_Y)/length(test_Y);                     %calculate the accuracy of each iteration
    results(k,i)=accuracy;                                                 %save the accuracy
    
end
end
results=results';
fprintf(['Accuracy: ' num2str(mean(results(1,:))*100) '%' '/n']);          
