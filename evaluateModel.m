function [ accuracy ] = evaluateModel( yPredict, gloveData )
    % need to check predict_Y
    numCorrect = sum(yPredict == gloveData);
    accuracy = numCorrect / length(yPredict);
end

