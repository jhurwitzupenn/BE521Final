function [avg_train_corr_all_fingers, avg_test_corr_all_fingers]= kubanekCrossVal(subjectID,k)
%% kfold cross validation on the kubanek model uses 'kubanekmodel.m'
try
    X = loadFeatures(subjectID);
catch
    error('Label file not found');
end
try
    Y = loadLabels(subjectID);
catch
    error('Label file not found');
end

% negthresh = 1:.05:1.2;

avg_train_corr_all_fingers = zeros(length(negthresh),1);
avg_test_corr_all_fingers = zeros(length(negthresh),1);

for j = 1:length(negthresh)
    fprintf('Iteration %i\n',j);
    
    indices = crossvalind('Kfold',length(Y(:,1)),k);
    corr_trains = zeros(k, 5);
    corr_tests = zeros(k, 5);

        for i=1:k
    %         fprintf('Fold %i\n',i);
            test = (indices == i); 
            train = ~test;
            [ctrain, ctest] = kubanekModel(test,train,X,Y,negthresh(j));
            corr_trains(i, :) = ctrain;
            corr_tests(i, :) = ctest;
        end
    avg_corr_train = mean(corr_trains);
    avg_corr_test = mean(corr_tests);
    
    avg_train_corr_all_fingers(j) = mean(avg_corr_train);
    avg_test_corr_all_fingers(j) = mean(avg_corr_test);
end
end