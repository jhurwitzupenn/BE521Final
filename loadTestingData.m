function [ x ] = loadTestingData( subjectID )
    load('subject_data.mat')
    fprintf('Loading testing data\n');
    if subjectID == 1
        x = subject1testingData;
    elseif subjectID == 2
        x = subject2testingData;
    else
        x = subject3testingData;
    end
end