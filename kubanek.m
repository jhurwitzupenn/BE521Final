function kubanek(subjectID, CARflag, changeFeatures, changeLabels, visualizePredictions)

% Define window length/displacement
fs = 1000;
winLen = 100e-3;    % 100 ms
winDisp = 50e-3;    % 50 ms
if changeFeatures == 1
    fprintf('REQUESTED REBUILD OF TRAINING FEATURES\n');
    %% Load data
    fprintf('Loading training data\n');
    trainingData = loadTrainingData(subjectID);
    fprintf('Loading training labels\n');
    numChannels = length(trainingData(1,:));

    %% Pre-process data
    
    fprintf('Applying CAR filter\n');
    if CARflag == 1
        fprintf('Used mean CAR filter\n');
        preProcessedData = meanCAR(trainingData, numChannels);
    else
        fprintf('Used median CAR filter\n');
        preProcessedData = medCAR(trainingData, numChannels);
    end

    %% Feature Extraction    
    fprintf('Extracting Features\n');
    X = BuildFeatures(preProcessedData, fs, winLen, winDisp, numChannels);

    % Cache the features
    fprintf('Saving Features\n');
    saveFeatures(X, subjectID);
end

gloveData = loadTrainingLabels(subjectID);
%% Generate Labels
if changeLabels == 1
    fprintf('REQUESTED REBUILD OF LABELS\n');
    fprintf('Generating labels\n');
    downSampleFactor = winDisp * 1000;
    fprintf('Downsampling labels\n');
    Y = downSample(gloveData, downSampleFactor);
    Y = round(Y(5:end,:));
    
    % Cache the labels
    fprintf('Saving Labels\n');
    saveLabels(Y, subjectID);
end

%% Predict and spline interpolation

try
    X = loadFeatures(subjectID);
catch
    error('Label file not found');
end

try
    Y = loadLabels(subjectID);
catch
    error('Label file not found');
end

%% SVM classification
% addpath('libsvmmatlab');

% Classify into 1 of 2 states
% classifier_model_cell = svmProbs(X,Y);
% saveClassifier(classifier_model_cell,subjectID);

% if subjectID == 1
%     struct_model = load('classifier_SVM_1.mat');
% elseif subjectID == 2
%     struct_model = load('classifier_SVM_2.mat');
% else
%     struct_model = load('classifier_SVM_3.mat');
% end
% 
% prob_fingers = zeros(size(Y));
% for i = 1:5
%     [predicted_label, accuracy, probs] = svmpredict(Y(:,i),...
%         X, struct_model.model_cell{i}, '-b 1');
%     prob_fingers(:,i) = probs(:,2);
% end

%%

% Linear Regression
Beta = (X' * X) \ (X' * Y);
yHat =  X * Beta;
yPredict = splineInterpolation(yHat, 310000, winDisp);

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
yPredict_Log_Linear = splineInterpolation(yLogLinReg, 310000,winDisp);

% Smooth out low amplitude oscillations
threshold = 1.0;
yPredict2 = yPredict;
for i = 1:5
    curr_finger = yPredict(:,i);
    smoothed_y = smooth(curr_finger,1001);
    idx = find(curr_finger < threshold);
    yPredict2(idx,i) = smoothed_y(idx);
end

%% Evaluate Model

fprintf('Subject %d\n',subjectID);
correlations = evaluateModel(yPredict, gloveData)
correlations_postProcessedFeatures = evaluateModel(yPredict2, gloveData)
correlation_logreg = evaluateModel(yPredict_Log_Linear, gloveData)

%% Save Beta Matrix

saveBetaMatrix(Beta, subjectID);

%% Visualize
if visualizePredictions == 1
    samplevector = 1:310000;
    for i = 1:5
        figure;
        plot(samplevector,gloveData(:,i),'b',...
            samplevector,yPredict(:,i),'r',...
            samplevector,yPredict2(:,i),'k');
        legend('Glove data','Predicted','Smoothed Predicted');
        xlabel('Sample'); ylabel('Output'); grid on;
        title(sprintf('Subject %i, Finger %i',subjectID,i));
    end
end

end