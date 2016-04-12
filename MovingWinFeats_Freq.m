function output = MovingWinFeats_Freq(x, fs, winLen, winDisp, freqrange)

NumWins = @(xLen, fs, winLen, winDisp) floor((((xLen/(winLen*fs))-1)*winLen/winDisp) + 1);
outputlength = NumWins(length(x), fs, winLen, winDisp);
output = zeros(outputlength,1);
start = 1;

% For each window, calculate the number of features
for i = 1:outputlength
    currentwindow = x(start:(start+winLen*fs-1));
    output(i) = freqAvg(currentwindow,freqrange,fs);
    start = start + winDisp*fs;
end
end