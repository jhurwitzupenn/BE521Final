function [ x ] = loadTrainingData( subjectID )
    fprintf('Loading training data\n');
    if subjectID == 1
        load('subject_data.mat','subject1trainingData');
        x = subject1trainingData;
    elseif subjectID == 2
        load('subject_data.mat','subject2trainingData');
        x = subject2trainingData;
    else
        load('subject_data.mat','subject3trainingData');
        x = subject3trainingData;
    end
end