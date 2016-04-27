subjectID = 1;

% First finger already done
saved = load('finger1_log.mat');
B = saved.B;
B1 = zeros(length(B),5);
B1(:,1) = B;

for finger = 2:5
    [B] = logRegressionModel(subjectID,finger);
    B1(:,finger) = B;
end

save('classifier_logreg_1.mat','B1');

%% Subject 2
subjectID = 2;
B2 = zeros(967,5);

for finger = 1:5
    [B] = logRegressionModel(subjectID,finger);
    B2(:,finger) = B;
end

save('classifier_logreg_2.mat','B2');

%% Subject 3
subjectID = 3;
B3 = zeros(1345,5);

for finger = 1:5
    [B] = logRegressionModel(subjectID,finger);
    B3(:,finger) = B;
end

save('classifier_logreg_3.mat','B3');