function [ x ] = loadTrainingData( subjectID )
    if subjectID == 1
        load('subject_data.mat','subject1trainingData');
        x = subject1trainingData;
        
        % Remove channel 55
        x(:,55) = [];
    elseif subjectID == 2
        load('subject_data.mat','subject2trainingData');
        x = subject2trainingData;
        
        % Remove channel 21 and 38
        x(:,21) = [];
        x(:,38) = [];
    else
        load('subject_data.mat','subject3trainingData');
        x = subject3trainingData;
    end
end