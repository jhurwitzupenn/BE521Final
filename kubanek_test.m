function kubanek_test(subjectID,CARflag, changeFeatures)

% Define window length/displacement
fs = 1000;
winLen = 100e-3;    % 100 ms
winDisp = 50e-3;    % 50 ms
if changeFeatures == 1
    fprintf('REQUESTED REBUILD OF TESTING FEATURES\n');
    %% Load data
    fprintf('Loading testing data\n');
    testingData = loadTestingData(subjectID);
    numChannels = length(testingData(1,:));

    %% Pre-process data

    if CARflag == 1
        fprintf('Used mean CAR filter\n');
        preProcessedData = meanCAR(testingData, numChannels);
    else
        fprintf('Used median CAR filter\n');
        preProcessedData = medCAR(testingData, numChannels);
    end

    %% Feature Extraction
    fprintf('Extracting Features\n');
    X = BuildFeatures(preProcessedData, fs, winLen, winDisp, numChannels);
    
    % Cache the features
    fprintf('Saving Features\n');
    saveTestFeatures(X, subjectID);
end

%% Predict and spline interpolation

try
    X = loadTestFeatures(subjectID);
catch
    error('Test features file not found');
end

try
    fprintf('Loading Beta matrix\n');
    Beta_matrix = loadBetaMatrix(subjectID);
catch
    error('Beta matrix file not found');
end

yHat = X*Beta_matrix;
yPredict = splineInterpolation(yHat, 147500, winDisp);

% Smooth out low amplitude oscillations
threshold = 1.0;
yPredict2 = yPredict;
for i = 1:5
    curr_finger = yPredict(:,i);
    smoothed_y = smooth(curr_finger,1001);
    idx = find(curr_finger < threshold);
    yPredict2(idx,i) = smoothed_y(idx);
end

% Log Regression
if subjectID == 1
    load('classifier_logreg_1.mat');
    B = B1;
elseif subjectID == 2
    load('classifier_logreg_2.mat');
    B = B2;
else
    load('classifier_logreg_3.mat');
    B = B3;
end

probs = zeros(size(X,1),5);
for i = 1:5
    p_mat = mnrval(B(:,i),X(:,2:end));
    probs(:,i) = p_mat(:,2);    % Store probability that it's 1
    fprintf('Fitted finger %i\n',i);
end

yLogLinReg = yHat .* probs;
yPredict_Log_Linear = splineInterpolation(yLogLinReg, 147500,winDisp);

% savePredictions(yPredict2, subjectID);
savePredictions(yPredict_Log_Linear, subjectID);
end