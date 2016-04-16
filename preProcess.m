function [ x ] = preProcess( x, numChannels )
    % Prefilter data
    for i = 1:numChannels
        x(:,i) = apply_Kramer(x(:,i));
    end
end

