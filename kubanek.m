function kubanek(subjectID,CARflag)
%% Load data
% Set data flag to correspond to desired dataset
% subjectID = 1;
% subjectID = 2;
% subjectID = 3;

trainingData = loadTrainingData(subjectID);
gloveData = loadTrainingLabels(subjectID);
numChannels = length(trainingData(1,:));

%% Pre-process data

% preProcessedData = preProcess(trainingData, numChannels);
if CARflag == 1
    preProcessedData = meanCAR(trainingData, numChannels);
else
    preProcessedData = medCAR(trainingData, numChannels);
end

%% Feature Extraction
% Define window length/displacement
fs = 1000;
winLen = 100e-3;    % 100 ms
winDisp = 50e-3;    % 50 ms

% X = BuildFeatures(trainingData, fs, winLen, winDisp, numChannels);
X = BuildFeatures(preProcessedData, fs, winLen, winDisp, numChannels);
% [coeff,score,latent,tsquared,explained,mu] = pca(X);

%% Downsample dataglove

downSampleFactor = winDisp * 1000;
Y = downSample(gloveData, downSampleFactor);
Y = Y(5:end,:);

%% SVM
% addpath('libsvmmatlab');

% Classify into 1 of 2 states
% classifier_model_cell = svmProbs(X,Y);
% saveClassifier(classifier_model_cell,subjectID);

%% Logistic Regression

% classifier_model_cell = logRegression(X,Y);
% saveClassifier(classifier_model_cell,subjectID);

%% Lasso

% Generate models
% fprintf('Performing lasso\n');
% [B1, fitinfo] = lasso(X,Y(:,1),'CV',5);
% fprintf('Finger 1 done\n');
% [B2, fitinfo] = lasso(X,Y(:,2),'CV',5);
% fprintf('Finger 2 done\n');
% [B3, fitinfo] = lasso(X,Y(:,3),'CV',5);
% fprintf('Finger 3 done\n');
% [B4, fitinfo] = lasso(X,Y(:,4),'CV',5);
% fprintf('Finger 4 done\n');
% [B5, fitinfo] = lasso(X,Y(:,5),'CV',5);
% Beta = [B1(:,1),B2(:,1),B3(:,1),B4(:,1),B5(:,1)];
% fprintf('Lasso done\n');
% 
% if dataflag == 1
%     save('subject1_BetaMatrix.mat','Beta');
% elseif dataflag == 2
%     save('subject2_BetaMatrix.mat','Beta');
% else
%     save('subject3_BetaMatrix.mat','Beta');
% end

%% Predict and spline interpolation

% Linear Regression
Beta = (X' * X) \ (X' * Y);
yHat =  X * Beta;
yPredict = splineInterpolation(yHat, 310000);

% Logistic Regression Probabilities
% model = loadClassifier(subjectID);
% flex_probs = zeros(size(yHat));
% fprintf('Log Regression Prediction\n');
% for i = 1:5
%     fprintf('Finger %d\n',i);
%     pihat = mnrval(model.model_cell{i},X);
%     flex_probs(:,i) = pihat(:,2);
% end
% yHat_classified = yHat .* flex_probs;
% yPredict2 = splineInterpolation(yHat_classified, 310000);

% SVM Probabilities
% model = loadClassifier(subjectID);
% flex_probs = zeros(size(yHat));
% for i = 1:5
%     fprintf('Finger %d\n',i);
%     [svm_label, svm_accuracy, svm_probs] =...
%         svmpredict(Y(:,i), X(:,2:end), model.model_cell{i}, '-b 1');
%     flex_probs(:,i) = svm_probs(:,2);
% end
% yHat_classified = yHat .* flex_probs;
% yPredict2 = splineInterpolation(yHat_classified, 310000);


%% Evaluate Model

fprintf('Subject %d\n',subjectID);
correlations = evaluateModel(yPredict, gloveData)
% correlations_classified = evaluateModel(yPredict2, gloveData)

%% Save Beta Matrix

saveBetaMatrix(Beta,subjectID);
end