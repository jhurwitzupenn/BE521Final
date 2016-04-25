function saveFeatures(X, subjectID)
    if subjectID == 1
        save('subject1_features.mat','X');
    elseif subjectID == 2
        save('subject2_features.mat','X');
    else
        save('subject3_features.mat','X');
    end
end