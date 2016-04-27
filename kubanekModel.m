function [correlation, correlation_classified]= kubanekModel(trainingData_i, gloveData_i, CARflag)
    numChannels = length(trainingData_i(1,:))

    if CARflag == 1
        preProcessedData = meanCAR(trainingData_i, numChannels);
    else
        preProcessedData = medCAR(trainingData_i, numChannels);
    end
    
    ppSize = size(preProcessedData)
    fs = 1000;
    winLen = 100e-3;    % 100 ms
    winDisp = 50e-3;    % 50 ms
    X = BuildFeatures(preProcessedData, fs, winLen, winDisp, numChannels);
    downSampleFactor = winDisp * 1000;
    Y = downSample(gloveData_i, downSampleFactor);
    Y = Y(5:end,:);

    % Linear Regression
    sx = size(X)
    sy = size(Y)
    Beta = (X' * X) \ (X' * Y);
    yHat =  X * Beta;
    yHatSize = size(yHat)
    yPredict = splineInterpolation(yHat, ppSize(1), winDisp);
    % Smooth out low amplitude oscillations
    threshold = 0.6;
    yPredict2 = yPredict;
    for j = 1:5
        curr_finger = yPredict(:,j);
        smoothed_y = smooth(curr_finger,1001);
        idx = find(curr_finger < threshold);
        yPredict2(idx,j) = smoothed_y(idx);
    end
    correlation = evaluateModel(yPredict, gloveData_i)
    correlation_classified = evaluateModel(yPredict2, gloveData_i)
end