function kubanek_test(subjectID,CARflag)
%% Load data
% Set data flag to correspond to desired dataset
% subjectID = 1;
% subjectID = 2;
% subjectID = 3;

testingData = loadTestingData(subjectID);
Beta_matrix = loadBetaMatrix(subjectID);
numChannels = length(testingData(1,:));

%% Pre-process data

if CARflag == 1
    preProcessedData = meanCAR(testingData, numChannels);
else
    preProcessedData = medCAR(testingData, numChannels);
end
% preProcessedData = preProcess(testingData, numChannels);

%% Feature Extraction
% Define window length/displacement
fs = 1000;
winLen = 100e-3;    % 100 ms
winDisp = 50e-3;    % 50 ms

% X = BuildFeatures(testingData, fs, winLen, winDisp, numChannels);
X = BuildFeatures(preProcessedData, fs, winLen, winDisp, numChannels);

%% Predict and spline interpolation

yHat = X*Beta_matrix;
yPredict = splineInterpolation(yHat, 147500);

% Zero out low threshold
% for i = 1:5
%     temp = yPredict(:,i);
%     temp(abs(temp)<1) = 0;
%     yPredict(:,i) = temp;
% end

savePredictions(yPredict, subjectID);
end