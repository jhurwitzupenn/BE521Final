function [X] = loadFeatures(subjectID)
    if subjectID == 1
        load('subject1_features.mat','X');
    elseif subjectID == 2
        load('subject2_features.mat','X');
    else
        load('subject3_features.mat','X');
    end
end