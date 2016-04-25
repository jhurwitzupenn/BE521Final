function [ x ] = loadTestingData( subjectID )
    if subjectID == 1
        load('subject_data.mat','subject1testingData');
        x = subject1testingData;
        
        % Remove channel 55
        x(:,55) = [];
    elseif subjectID == 2
        load('subject_data.mat','subject2testingData');
        x = subject2testingData;
        
        % Remove channel 21 and 38
        x(:,21) = [];
        x(:,38) = [];
    else
        load('subject_data.mat','subject3testingData');
        x = subject3testingData;
    end
end