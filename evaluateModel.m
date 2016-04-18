function [ correlations ] = evaluateModel( yPredict, gloveData )
    % need to check predict_Y
    correlations = zeros(1, 5);
    for i = 1:5
        correlations(i) = corr(yPredict(:, i), gloveData(:, i));
    end
end

