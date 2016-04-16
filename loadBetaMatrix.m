function [ x ] = loadBetaMatrix( subjectID )
    if subjectID == 1
        load('subject1_BetaMatrix.mat');
    elseif subjectID == 2
        load('subject2_BetaMatrix.mat');
    else
        load('subject3_BetaMatrix.mat');
    end
    x = Beta;
end