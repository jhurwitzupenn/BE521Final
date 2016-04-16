%% Load data
% load('subject_data.mat');

%% Prefiltering

% Set data flag to correspond to desired dataset
% dataflag = 1;
% dataflag = 2;
dataflag = 3;

if dataflag == 1
    x = subject1testingData;   % testing script with this data
elseif dataflag == 2
    x = subject2testingData;
else
    x = subject3testingData;
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
% fprintf('Generating features\n');
% for i = 1:numchannels
%     TimeDomainAvg(:,i) = MovingWinFeats(x(:,i), fs, winLen, winDisp, TimeAvg);
%     FreqAvg5to15(:,i) = MovingWinFeats_Freq(x(:,i), fs, winLen, winDisp, [5,15]);
%     FreqAvg20to25(:,i) = MovingWinFeats_Freq(x(:,i), fs, winLen, winDisp, [20,25]);
%     FreqAvg75to115(:,i) = MovingWinFeats_Freq(x(:,i), fs, winLen, winDisp, [75,115]);
%     FreqAvg125to160(:,i) = MovingWinFeats_Freq(x(:,i), fs, winLen, winDisp, [125,160]);
%     FreqAvg160to175(:,i) = MovingWinFeats_Freq(x(:,i), fs, winLen, winDisp, [160,175]);
% end
% fprintf('Generating features done\n');
% 
% if dataflag == 1
%     save('subject1_testfeatures.mat','TimeDomainAvg','FreqAvg5to15','FreqAvg20to25',...
%     'FreqAvg75to115','FreqAvg125to160','FreqAvg160to175');
% elseif dataflag == 2
%     save('subject2_testfeatures.mat','TimeDomainAvg','FreqAvg5to15','FreqAvg20to25',...
%     'FreqAvg75to115','FreqAvg125to160','FreqAvg160to175');
% else
%     save('subject3_testfeatures.mat','TimeDomainAvg','FreqAvg5to15','FreqAvg20to25',...
%     'FreqAvg75to115','FreqAvg125to160','FreqAvg160to175');
% end
if dataflag == 1
    load('subject1_testfeatures.mat');
elseif dataflag == 2
    load('subject2_testfeatures.mat');
else
    load('subject3_testfeatures.mat');
end

%% Linear regression

% Construct X matrix
M = numwindows;
N = 3;
% X = zeros(M,N*numchannels*6+1);
X = zeros(M,numchannels*6+1);
% for i = 1:M-2
%     X(i,:) = [1, reshape(TimeDomainAvg(i:i+N-1,1:numchannels),1,numchannels*N),...
%         reshape(FreqAvg5to15(i:i+N-1,1:numchannels),1,numchannels*N),...
%         reshape(FreqAvg20to25(i:i+N-1,1:numchannels),1,numchannels*N),...
%         reshape(FreqAvg75to115(i:i+N-1,1:numchannels),1,numchannels*N),...
%         reshape(FreqAvg125to160(i:i+N-1,1:numchannels),1,numchannels*N),...
%         reshape(FreqAvg160to175(i:i+N-1,1:numchannels),1,numchannels*N)];
% end
% for i = 4:M
%     X(i,:) = [1, reshape(TimeDomainAvg(i-N:i-1,1:numchannels),1,numchannels*N),...
%         reshape(FreqAvg5to15(i-N:i-1,1:numchannels),1,numchannels*N),...
%         reshape(FreqAvg20to25(i-N:i-1,1:numchannels),1,numchannels*N),...
%         reshape(FreqAvg75to115(i-N:i-1,1:numchannels),1,numchannels*N),...
%         reshape(FreqAvg125to160(i-N:i-1,1:numchannels),1,numchannels*N),...
%         reshape(FreqAvg160to175(i-N:i-1,1:numchannels),1,numchannels*N)];
% end
for i = 4:M
    X(i,:) = [1, reshape(TimeDomainAvg(i-N,1:numchannels),1,numchannels),...
        reshape(FreqAvg5to15(i-N,1:numchannels),1,numchannels),...
        reshape(FreqAvg20to25(i-N,1:numchannels),1,numchannels),...
        reshape(FreqAvg75to115(i-N,1:numchannels),1,numchannels),...
        reshape(FreqAvg125to160(i-N,1:numchannels),1,numchannels),...
        reshape(FreqAvg160to175(i-N,1:numchannels),1,numchannels)];
end

% Load correct Beta
if dataflag == 1
    load('subject1_BetaMatrix.mat');
elseif dataflag == 2
    load('subject2_BetaMatrix.mat');
else
    load('subject3_BetaMatrix.mat');
end
Y_hat = X*Beta;

%% Spline Interpolation

predict_Y = zeros(147500,5);
x = 1:50:147450;
xx = 1:147450;

for i = 1:5
    temp_values = zeros(147500,1);
    
    % Values are integers from [-2 to 7], so round predicted values
    temp_values(51:147500) = round(spline(x,Y_hat(:,i),xx));
    temp_values(temp_values < -2) = -2;
    temp_values(temp_values > 7) = 7;
    
    % Zero-pad the first 50 angles
    temp_values(1:50) = zeros(50,1);
    predict_Y(:,i) = temp_values;
end

if dataflag == 1
    save('predicted_1.mat','predict_Y');
elseif dataflag == 2
    save('predicted_2.mat','predict_Y');
else
    save('predicted_3.mat','predict_Y');
end