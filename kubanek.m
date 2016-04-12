%% Load data
load('subject_data.mat');

%% Prefiltering
x = subject1trainingData;   % testing script with this data
fs = 1000;  % 1000 Hz
numchannels = length(subject1trainingData(1,:));

% Prefilter data
for i = 1:numchannels
    x(:,i) = apply_Kramer(x(:,i));
end

%% Feature Extraction
% Define window length/displacement
winLen = 100e-3;    % 100 ms
winDisp = 50e-3;    % 50 ms
TimeAvg = @(x) mean(x);

NumWins = @(xLen, fs, winLen, winDisp) floor((((xLen/(winLen*fs))-1)*winLen/winDisp) + 1);
numwindows = NumWins(length(x), fs, winLen, winDisp);
TimeDomainAvg = zeros(numwindows,numchannels);
FreqAvg5to15 = zeros(numwindows,numchannels);
FreqAvg20to25 = zeros(numwindows,numchannels);
FreqAvg75to115 = zeros(numwindows,numchannels);
FreqAvg125to160 = zeros(numwindows,numchannels);
FreqAvg160to175 = zeros(numwindows,numchannels);

% Extract features
for i = 1:numchannels
    TimeDomainAvg(:,i) = MovingWinFeats(x(:,i), fs, winLen, winDisp, TimeAvg);
    FreqAvg5to15(:,i) = MovingWinFeats_Freq(x(:,i), fs, winLen, winDisp, [5,15]);
    FreqAvg20to25(:,i) = MovingWinFeats_Freq(x(:,i), fs, winLen, winDisp, [20,25]);
    FreqAvg75to115(:,i) = MovingWinFeats_Freq(x(:,i), fs, winLen, winDisp, [75,115]);
    FreqAvg125to160(:,i) = MovingWinFeats_Freq(x(:,i), fs, winLen, winDisp, [125,160]);
    FreqAvg160to175(:,i) = MovingWinFeats_Freq(x(:,i), fs, winLen, winDisp, [160,175]);
end

%% Downsample dataglove
glove_data = subject1gloveData;
downsampling_factor = 50;
glove_length = 310000/downsampling_factor;
downsampled_glove_data = zeros(glove_length,5);
for i = 1:5
    downsampled_glove_data(:,i) = decimate(glove_data(:,i),downsampling_factor);
end

%% Linear regression

% Construct X matrix
M = numwindows;
N = 3;
X = zeros(M,N*numchannels*6+1);
for i = 1:M-2
    X(i,:) = [1, reshape(TimeDomainAvg(i:i+N-1,1:62),1,numchannels*N),...
        reshape(FreqAvg5to15(i:i+N-1,1:62),1,186),...
        reshape(FreqAvg20to25(i:i+N-1,1:62),1,186),...
        reshape(FreqAvg75to115(i:i+N-1,1:62),1,186),...
        reshape(FreqAvg125to160(i:i+N-1,1:62),1,186),...
        reshape(FreqAvg160to175(i:i+N-1,1:62),1,186)];
end

Y = downsampled_glove_data(2:end,:);
Beta = (X'*X)\(X'*Y);
Y_hat = X*Beta;

%% Spline Interpolation

for i = 1:5
    predict_Y(:,i) = spline(linspace(1,310000,numwindows),Y_hat(:,i),...
        1:310000);
    predict_Y(1,i) = Y_hat(1,i);
    predict_Y(end,i) = Y_hat(end,i);
end

% need to check predict_Y

save('kubanek.mat','Beta');