function [ y ] = loadTrainingLabels( subjectID )
    fprintf('Loading training labels\n');
    if subjectID == 1
        load('subject_data.mat','subject1gloveData');
        y = subject1gloveData;
    elseif subjectID == 2
        load('subject_data.mat','subject2gloveData');
        y = subject2gloveData;
    else
        load('subject_data.mat','subject3gloveData');
        y = subject3gloveData;
    end
end