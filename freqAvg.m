function output = freqAvg(input, freqrange, fs)
    % input is the input signal
    % freqrange is the bounds of the desired frequency range
    % [f_lower, f_upper]
    % fs is the sampling frequency in Hz
    
    % Perform fft
    L = length(input);
    NFFT = 2^nextpow2(L);
    input_fft = fft(input,NFFT);
    f = fs/2*linspace(0,1,NFFT/2+1);
    
    % Average signal amplitude in desired frequency range
    lower_idx = find(f >= freqrange(1),1);
    upper_idx = find(f <= freqrange(2),1,'last');
    output = mean(abs(input_fft(lower_idx:upper_idx)));
end