function [ Y ] = downSample( Y, downSampleFactor )
    newLength = length(Y)/downSampleFactor;
    downSampled = zeros(newLength, 5);
    for i = 1:5
        downSampled(:,i) = decimate(Y(:,i), downSampleFactor);
    end
    Y = downSampled;
end

