function [output] = meanCAR(input, numChannels)
    mean_channels = mean(input,2);
    output = zeros(size(input));
    for i = 1:numChannels
        output(:,i) = input(:,i) - mean_channels;
    end
end