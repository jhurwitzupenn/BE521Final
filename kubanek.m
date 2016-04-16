%% Load data
% load('subject_data.mat');

%% Prefiltering

% Set data flag to correspond to desired dataset
% dataflag = 1;
% dataflag = 2;
dataflag = 3;

if dataflag == 1
    x = subject1trainingData;   % testing script with this data
elseif dataflag == 2
    x = subject2trainingData;
else
    x = subject3trainingData;
end

fs = 1000;  % 1000 Hz
numchannels = length(x(1,:));

% Prefilter data
% for i = 1:numchannels
%     x(:,i) = apply_Kramer(x(:,i));
% end

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
fprintf('Generating features\n');
for i = 1:numchannels
    TimeDomainAvg(:,i) = MovingWinFeats(x(:,i), fs, winLen, winDisp, TimeAvg);
    FreqAvg5to15(:,i) = MovingWinFeats_Freq(x(:,i), fs, winLen, winDisp, [5,15]);
    FreqAvg20to25(:,i) = MovingWinFeats_Freq(x(:,i), fs, winLen, winDisp, [20,25]);
    FreqAvg75to115(:,i) = MovingWinFeats_Freq(x(:,i), fs, winLen, winDisp, [75,115]);
    FreqAvg125to160(:,i) = MovingWinFeats_Freq(x(:,i), fs, winLen, winDisp, [125,160]);
    FreqAvg160to175(:,i) = MovingWinFeats_Freq(x(:,i), fs, winLen, winDisp, [160,175]);
end
fprintf('Generating features done\n');
%% Downsample dataglove

if dataflag == 1
    glove_data = subject1gloveData;
elseif dataflag == 2
    glove_data = subject2gloveData;
else
    glove_data = subject3gloveData;
end

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
% for i = 1:M-2
%     X(i,:) = [1, reshape(TimeDomainAvg(i:i+N-1,1:numchannels),1,numchannels*N),...
%         reshape(FreqAvg5to15(i:i+N-1,1:numchannels),1,numchannels*N),...
%         reshape(FreqAvg20to25(i:i+N-1,1:numchannels),1,numchannels*N),...
%         reshape(FreqAvg75to115(i:i+N-1,1:numchannels),1,numchannels*N),...
%         reshape(FreqAvg125to160(i:i+N-1,1:numchannels),1,numchannels*N),...
%         reshape(FreqAvg160to175(i:i+N-1,1:numchannels),1,numchannels*N)];
% end
for i = 4:M
    X(i,:) = [1, reshape(TimeDomainAvg(i-N:i-1,1:numchannels),1,numchannels*N),...
        reshape(FreqAvg5to15(i-N:i-1,1:numchannels),1,numchannels*N),...
        reshape(FreqAvg20to25(i-N:i-1,1:numchannels),1,numchannels*N),...
        reshape(FreqAvg75to115(i-N:i-1,1:numchannels),1,numchannels*N),...
        reshape(FreqAvg125to160(i-N:i-1,1:numchannels),1,numchannels*N),...
        reshape(FreqAvg160to175(i-N:i-1,1:numchannels),1,numchannels*N)];
end

Y = downsampled_glove_data(1:end-1,:);
Beta = (X'*X)\(X'*Y);
Y_hat = X*Beta;

if dataflag == 1
    save('subject1_BetaMatrix.mat','Beta');
elseif dataflag == 2
    save('subject2_BetaMatrix.mat','Beta');
else
    save('subject3_BetaMatrix.mat','Beta');
end

%% Lasso

% Generate models
% [B1, fitinfo] = lasso(X,Y(:,1));


%% Spline Interpolation

predict_Y = zeros(310000,5);
x = 1:50:309950;
xx = 1:309950;

for i = 1:5
    temp_values = zeros(310000,1);
    
    % Values are integers from [-2 to 7], so round predicted values
    temp_values(51:310000) = round(spline(x,Y_hat(:,i),xx));
%     temp_values(1:end-50) = round(spline(x,Y_hat(:,i),xx));
    temp_values(temp_values < -2) = -2;
    temp_values(temp_values > 7) = 7;
    
    % Zero-pad the first 50 angles
    temp_values(1:50) = zeros(50,1);
%     temp_values(end-49:end) = zeros(50,1);
    predict_Y(:,i) = temp_values;
end

% need to check predict_Y
correct_matrix = ~logical(predict_Y - glove_data);
percent_correct = mean(correct_matrix)

% save('kubanek.mat','Beta');