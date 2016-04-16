function [ yPredict ] = splineInterpolation( yHat )
    yPredict = zeros(310000,5);
    x = 1:50:309950;
    xx = 1:309950;
    for i = 1:5
        temp_values = zeros(310000,1);
        % Values are integers from [-2 to 7], so round predicted values
        temp_values(51:310000) = round(spline(x, yHat(:,i),xx));
        % temp_values(1:end-50) = round(spline(x,Y_hat(:,i),xx));
        temp_values(temp_values < -2) = -2;
        temp_values(temp_values > 7) = 7;
        % Zero-pad the first 50 angles
        temp_values(1:50) = zeros(50,1);
        % temp_values(end-49:end) = zeros(50,1);
        yPredict(:,i) = temp_values;
    end
end

