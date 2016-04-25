function [Y] = loadLabels(subjectID)
    if subjectID == 1
        load('subject1_labels.mat','Y');
    elseif subjectID == 2
        load('subject2_labels.mat','Y');
    else
        load('subject3_labels.mat','Y');
    end
end