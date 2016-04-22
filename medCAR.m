function [output] = medCAR(input, numChannels)
    med_channels = median(input,2);
    output = zeros(size(input));
    for i = 1:numChannels
        output(:,i) = input(:,i) - med_channels;
    end
end