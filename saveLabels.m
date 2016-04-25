function saveLabels(Y, subjectID)
    if subjectID == 1
        save('subject1_labels.mat','Y');
    elseif subjectID == 2
        save('subject2_labels.mat','Y');
    else
        save('subject3_labels.mat','Y');
    end
end