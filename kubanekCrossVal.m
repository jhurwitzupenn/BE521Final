function [corr_trains, corr_tests]= kubanekCrossVal(subjectID, k)
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

indices = crossvalind('Kfold',length(Y(:,1)),k);
corr_trains = zeros(k, 5);
corr_tests = zeros(k, 5);

    for i=1:k
%         fprintf('Fold %i\n',i);
        test = (indices == i); 
        train = ~test;
        [ctrain, ctest] = kubanekModel(test, train,X,Y);
        corr_trains(i, :) = ctrain;
        corr_tests(i, :) = ctest;
    end
avg_corr_train = mean(corr_trains)
avg_corr_test = mean(corr_tests)
end