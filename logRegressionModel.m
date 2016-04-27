function [B] = logRegressionModel(subjectID,finger)

X = loadFeatures(subjectID);
labels = loadLabels(subjectID);
Y = double(logical(round(labels)));
Y = Y + 1;

fprintf('Performing Log Regression\nFinger %i\n',finger);
[B,dev,stats] = mnrfit(X(:,2:end),Y(:,finger));

end