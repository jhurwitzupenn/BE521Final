function [correlation_train, correlation_test]= kubanekModel(test, train,...
    X,Y,threshold)

    % Optimized
    numsamplesLMS = 11;
    
    % Normalize X
%     X = zscore(X);
%     X(:,1) = ones(length(X),1);
    
    % Setup features
    Xtrain = X(train,:);
    Ytrain = Y(train,:);
    Xtest = X(test,:);
    Ytest = Y(test,:);

    % Linear Regression
    Beta = (Xtrain' * Xtrain) \ (Xtrain' * Ytrain);
    yHat_train =  Xtrain * Beta;    
    yHat_test =  Xtest * Beta;
    
    % Optimized
    threshold = 1.15;
    negthresh = -1.5;
    
    yHat2_test = yHat_test;
    yHat2_train = yHat_train;
    for i = 1:5
        curr_finger = yHat_test(:,i);
        smoothed_y = smooth(curr_finger,numsamplesLMS,'lowess');
        idx = find(curr_finger < threshold & curr_finger > negthresh);
        yHat2_test(idx,i) = smoothed_y(idx);
    end

    correlation_test = evaluateModel(yHat2_test, Ytest);
    correlation_train = evaluateModel(yHat2_train, Ytrain);
%     correlation_test = evaluateModel(yHat_knn, Ytest);
end