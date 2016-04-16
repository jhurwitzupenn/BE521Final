%% Load data
% Set data flag to correspond to desired dataset
subjectID = 1;
% subjectID = 2;
% subjectID = 3;

trainingData = loadTrainingData(subjectID);
gloveData = loadTrainingLabels(subjectID);
numChannels = length(trainingData(1,:));

%% Pre-process data

preProcessedData = preProcess(trainingData, numChannels);

%% Feature Extraction
% Define window length/displacement
fs = 1000;
winLen = 100e-3;    % 100 ms
winDisp = 50e-3;    % 50 ms

% X = BuildFeatures(trainingData, fs, winLen, winDisp, numChannels);

%% Downsample dataglove

downSampleFactor = winDisp * 1000;
Y = downSample(gloveData, downSampleFactor);
Y = Y(1:end-1,:);

%% Lasso

% Generate models
% fprintf('Performing lasso\n');
% [B1, fitinfo] = lasso(X,Y(:,1),'NumLambda',5);
% fprintf('Finger 1 done\n');
% [B2, fitinfo] = lasso(X,Y(:,2),'NumLambda',5);
% fprintf('Finger 2 done\n');
% [B3, fitinfo] = lasso(X,Y(:,3),'NumLambda',5);
% fprintf('Finger 3 done\n');
% [B4, fitinfo] = lasso(X,Y(:,4),'NumLambda',5);
% fprintf('Finger 4 done\n');
% [B5, fitinfo] = lasso(X,Y(:,5),'NumLambda',5);
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

%% Evaluate Model

accuracy = evaluateModel(yPredict, gloveData)

%% Save Beta Matrix

saveBetaMatrix(Beta,subjectID);