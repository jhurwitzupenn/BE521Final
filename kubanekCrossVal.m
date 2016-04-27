function [correlations, correlations_classified]= kubanekCrossVal(subjectID, k, CARflag)
%% kfold cross validation on the kubanek model uses 'kubanekmodel.m'

trainingData = loadTrainingData(subjectID);
gloveData = loadTrainingLabels(subjectID);
trainingDataSize = size(trainingData)

% gloveData = gloveData';
gloveDataSize = size(gloveData)

numChannels = length(trainingData(1,:))

indices = crossvalind('Kfold',310000,10);
% cp = classperf(gloveData(1, :));
correlations = zeros(k, 5);
correlations_classified = zeros(k, 5);
    for i=1:k
        i
        test = (indices == i); 
        train = ~test;
        trainingData_i = trainingData(train', :);
        gloveData_i = gloveData(train', :);
        [c, cc] = kubanekModel(trainingData_i, gloveData_i,CARflag )
        correlations(i, :) = c;
        correlations_calssified(i, :) = cc;
    end
    
end