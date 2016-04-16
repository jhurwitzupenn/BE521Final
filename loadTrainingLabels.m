function [ y ] = loadTrainingLabels( subjectID )
    load('subject_data.mat')
    if subjectID == 1
        y = subject1gloveData;
    elseif subjectID == 2
        y = subject2gloveData;
    else
        y = subject3gloveData;
    end
end

