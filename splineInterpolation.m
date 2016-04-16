function [ yPredict ] = splineInterpolation( yHat, outputlength )
    yPredict = zeros(outputlength,5);
    x = 1:50:outputlength-50;
    xx = 1:outputlength-50;
    for i = 1:5
        temp_values = zeros(outputlength,1);
        % Values are integers from [-2 to 7], so round predicted values
        temp_values(51:outputlength) = round(spline(x, yHat(:,i),xx));
        % temp_values(1:end-50) = round(spline(x,Y_hat(:,i),xx));
        temp_values(temp_values < -2) = -2;
        temp_values(temp_values > 7) = 7;
        % Zero-pad the first 50 angles
        temp_values(1:50) = zeros(50,1);
        % temp_values(end-49:end) = zeros(50,1);
        yPredict(:,i) = temp_values;
    end
end