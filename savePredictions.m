function savePredictions( predict_Y, subjectID)
    if subjectID == 1
        save('predicted_1.mat','predict_Y');
    elseif subjectID == 2
        save('predicted_2.mat','predict_Y');
    else
        save('predicted_3.mat','predict_Y');
    end
end