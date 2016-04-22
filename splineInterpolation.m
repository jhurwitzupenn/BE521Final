function [ yPredict ] = splineInterpolation( yHat, outputlength, winDisp )
    yPredict = zeros(outputlength,5);
    winDisp = winDisp * 1e3; % convert from ms to samples
    padding = winDisp*4;
%     padding = winDisp*6;
    x = 1:winDisp:outputlength-padding;
    xx = 1:outputlength-padding;
    for i = 1:5
        temp_values = zeros(outputlength,1);
        temp_values(padding+1:outputlength) = spline(x, yHat(:,i),xx);
        % Zero-pad the first 200 angles
        temp_values(1:padding) = zeros(padding,1);
        % temp_values(end-49:end) = zeros(50,1);
        yPredict(:,i) = temp_values;
    end
end