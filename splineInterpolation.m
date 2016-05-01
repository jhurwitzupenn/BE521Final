function [ yPredict ] = splineInterpolation( yHat, outputlength, winDisp )
    yPredict = zeros(outputlength,5);
    winDisp = round(winDisp * 1e3); % convert from ms to samples
    x = 1:winDisp:winDisp*length(yHat);
    delay = 3;
    padding = delay * winDisp;
    xx = 1:outputlength-padding;
    for i = 1:5
        temp_values = zeros(outputlength,1);
        temp_values(padding+1:outputlength) = spline(x, yHat(:,i),xx);
        % Pad the first 200 angles with first known point
        temp_values(1:padding) =  temp_values(padding+1)*ones(padding,1);
        yPredict(:,i) = temp_values;
    end
end