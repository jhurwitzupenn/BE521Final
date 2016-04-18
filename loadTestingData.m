function [ x ] = loadTestingData( subjectID )
    fprintf('Loading testing data\n');
    if subjectID == 1
        load('subject_data.mat','subject1testingData');
        x = subject1testingData;
    elseif subjectID == 2
        load('subject_data.mat','subject2testingData');
        x = subject2testingData;
    else
        load('subject_data.mat','subject3testingData');
        x = subject3testingData;
    end
end