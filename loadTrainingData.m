function [ x ] = loadTrainingData( subjectID )
    load('subject_data.mat')
    fprintf('Loading training data\n');
    if subjectID == 1
        x = subject1trainingData;
    elseif subjectID == 2
        x = subject2trainingData;
    else
        x = subject3trainingData;
    end
end