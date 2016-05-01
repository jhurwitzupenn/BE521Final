function [predicted_dg] = make_predictions(test_ecog)

% Inputs: test_ecog - 3 x 1 cell array containing ECoG for each subject, where test_ecog{i} 
% to the ECoG for subject i. Each cell element contains a N x M testing ECoG,
% where N is the number of samples and M is the number of EEG channels.
% Outputs: predicted_dg - 3 x 1 cell array, where predicted_dg{i} contains the 
% data_glove prediction for subject i, which is an N x 5 matrix (for
% fingers 1:5)

% Run time: The script has to run less than 1 hour. 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% The following is a sample script.

% Load Model. The variable models contains weights for each person,
% each channel, and each finger.


% Predict using linear predictor for each subject
%create cell array with one element for each subject
predicted_dg = cell(3,1);

%for each subject
for subjectID = 1:3 
    
    %get the testing ecog
    testingData = test_ecog{subjectID};
    numChannels = length(testingData(1,:));
    
    % Apply mean CAR filter
    preProcessedData = meanCAR(testingData, numChannels);
    
    % Extract features
    fs = 1000;
    winLen = 100e-3;    % 100 ms
    winDisp = 50e-3;    % 50 ms
    X = BuildFeatures(preProcessedData, fs, winLen, winDisp, numChannels);
    
    % Normalize X
    X = zscore(X);
    X(:,1) = ones(length(X),1);
    
    % Load Beta matrix
    Beta_matrix = loadBetaMatrix(subjectID);
    
    % Linear Regression
    yHat = X*Beta_matrix;
    
    % Smoothing and thresholding
    threshold = 1.15;
    negthresh = -1.4;
    yHat2 = yHat;
    for i = 1:5
        curr_finger = yHat(:,i);
        smoothed_y = smooth(curr_finger,11,'lowess');
        idx = find(curr_finger < threshold & curr_finger > negthresh);
        yHat2(idx,i) = smoothed_y(idx);
    end
    
    % Interpolation
    yPredict = splineInterpolation(yHat2, 147500,winDisp);
    
    % More smoothing
    post_thresh = threshold;
    yPredict2 = yPredict;
    numavg = 1501;
    for i = 1:5
        curr_finger = yPredict(:,i);
        smoothed_y = smooth(curr_finger,numavg);
        idx = find(curr_finger < post_thresh);
        yPredict2(idx,i) = smoothed_y(idx);
    end
    
    % Zero out low amplitudes
    thresh = 0.4;
    negthresh = -3;
    for i = 1:5
        curr_finger = yPredict2(:,i);
        idx = find(curr_finger < thresh & curr_finger > negthresh);
        yPredict2(idx,i) = 0;
    end
    
    % Zero out lone peaks
    peakthresh = 0.1;
    nonzeroneighbors = 400;
    for i = 1:5
        curr_finger = yPredict2(:,i);
        [pks,locs] = findpeaks(curr_finger);
        locations = locs(abs(pks) > peakthresh);

        % Get negative peaks as well
        [pks,locs] = findpeaks(-curr_finger);
        locations = [locations;locs];

        % Remove zeros
        locations(pks == 0) = [];

        % For each location, check how many neighbors are zero
        for j = 1:length(locations)
            locidx = locations(j);
            beforearray = curr_finger(1:locidx);
            afterarray = curr_finger(locidx:end);

            start = find(beforearray == 0,1,'last');
            if isempty(start)
                start = 1;
            end
            stop = find(afterarray == 0,1,'first');
            if isempty(stop)
                stop = length(curr_finger);
            end

            if length(start:stop) < nonzeroneighbors
                yPredict2(start:stop,i) = 0;
            end
        end
    end
    
    predicted_dg{subjectID} = yPredict2;
end

