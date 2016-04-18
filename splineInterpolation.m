function [ yPredict ] = splineInterpolation( yHat, outputlength )
    yPredict = zeros(outputlength,5);
    x = 1:50:outputlength-200;
    xx = 1:outputlength-200;
    for i = 1:5
        temp_values = zeros(outputlength,1);
        temp_values(201:outputlength) = spline(x, yHat(:,i),xx);
        % Zero-pad the first 200 angles
        temp_values(1:200) = zeros(200,1);
        % temp_values(end-49:end) = zeros(50,1);
        yPredict(:,i) = temp_values;
    end
end