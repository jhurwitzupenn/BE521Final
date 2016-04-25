function saveBetaMatrix(Beta, subjectID)
    if subjectID == 1
        save('subject1_BetaMatrix.mat','Beta');
    elseif subjectID == 2
        save('subject2_BetaMatrix.mat','Beta');
    else
        save('subject3_BetaMatrix.mat','Beta');
    end
end