function [ probs ] = logReg( X, subjectID )
    % Load model
    if subjectID == 1
        load('classifier_logreg_1.mat');
        B = B1;
    elseif subjectID == 2
        load('classifier_logreg_2.mat');
        B = B2;
    else
        load('classifier_logreg_3.mat');
        B = B3;
    end
    
    probs = zeros(size(X,1),5);
    for i = 1:5
        fprintf('Performing Log Regression\nFinger %i\n',i);
        p_mat = mnrval(B(:,i),X(:,2:end));
        probs(:,i) = p_mat(:,2);    % Store probability that it's 1
    end
end