function [correlation_train, correlation_test]= kubanekModel(test, train,...
    X,Y)
    
    % Setup features
    Xtrain = X(train,:);
    Ytrain = Y(train,:);
    Xtest = X(test,:);
    Ytest = Y(test,:);

    % Linear Regression
    Beta = (Xtrain' * Xtrain) \ (Xtrain' * Ytrain);
    yHat_train =  Xtrain * Beta;    
    yHat_test =  Xtest * Beta;

    correlation_train = evaluateModel(yHat_train, Ytrain);
    correlation_test = evaluateModel(yHat_test, Ytest);
end