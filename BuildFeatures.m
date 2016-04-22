function [ X ] = BuildFeatures( data, fs, winLen, winDisp, numChannels )
    TimeAvg = @(x) mean(x);
    NumWins = @(xLen, fs, winLen, winDisp) floor((((xLen/(winLen*fs))-1) * ...
                                                    winLen/winDisp) + 1); 

    numWins = NumWins(length(data), fs, winLen, winDisp);
    TimeDomainAvg = zeros(numWins, numChannels);
    FreqAvg5to15 = zeros(numWins, numChannels);
    FreqAvg20to25 = zeros(numWins, numChannels);
    FreqAvg75to115 = zeros(numWins, numChannels);
    FreqAvg125to160 = zeros(numWins, numChannels);
    FreqAvg160to175 = zeros(numWins, numChannels);

    fprintf('Generating features\n');
    f = 1:175;
    for i = 1:numChannels
        TimeDomainAvg(:,i) = MovingWinFeats(data(:,i), fs, winLen, winDisp, TimeAvg);
        [s,f,~] = spectrogram(data(:,i),winLen*1e3,round((winLen-winDisp)*1e3)...
            ,f,fs);
        
        FreqAvg5to15(:,i) = mean(abs(s(5:15,:)))';
        FreqAvg20to25(:,i) = mean(abs(s(20:25,:)))';
        FreqAvg75to115(:,i) = mean(abs(s(75:115,:)))';
        FreqAvg125to160(:,i) = mean(abs(s(125:160,:)))';
        FreqAvg160to175(:,i) = mean(abs(s(160:175,:)))';
%         FreqAvg5to15(:,i) = MovingWinFeats_Freq(data(:,i), fs, winLen, winDisp, [5,15]);
%         FreqAvg20to25(:,i) = MovingWinFeats_Freq(data(:,i), fs, winLen, winDisp, [20,25]);
%         FreqAvg75to115(:,i) = MovingWinFeats_Freq(data(:,i), fs, winLen, winDisp, [75,115]);
%         FreqAvg125to160(:,i) = MovingWinFeats_Freq(data(:,i), fs, winLen, winDisp, [125,160]);
%         FreqAvg160to175(:,i) = MovingWinFeats_Freq(data(:,i), fs, winLen, winDisp, [160,175]);
    end
    fprintf('Generating features done\n');

%     X = zeros(numWins,numChannels*6+1);
%     delay = 2;
%     for i = 4:numWins
%         X(i,:) = [1, reshape(TimeDomainAvg(i-delay,1:numChannels),1,numChannels),...
%             reshape(FreqAvg5to15(i-delay,1:numChannels),1,numChannels),...
%             reshape(FreqAvg20to25(i-delay,1:numChannels),1,numChannels),...
%             reshape(FreqAvg75to115(i-delay,1:numChannels),1,numChannels),...
%             reshape(FreqAvg125to160(i-delay,1:numChannels),1,numChannels),...
%             reshape(FreqAvg160to175(i-delay,1:numChannels),1,numChannels)];
%     end
    
    delay = 3;
    X = zeros(numWins,numChannels*6*delay+1);
    for i = 4:numWins
        X(i,:) = [1, reshape(TimeDomainAvg(i-delay:i-1,1:numChannels),1,numChannels*delay),...
            reshape(FreqAvg5to15(i-delay:i-1,1:numChannels),1,numChannels*delay),...
            reshape(FreqAvg20to25(i-delay:i-1,1:numChannels),1,numChannels*delay),...
            reshape(FreqAvg75to115(i-delay:i-1,1:numChannels),1,numChannels*delay),...
            reshape(FreqAvg125to160(i-delay:i-1,1:numChannels),1,numChannels*delay),...
            reshape(FreqAvg160to175(i-delay:i-1,1:numChannels),1,numChannels*delay)];
    end
    
    % Remove first 3 rows of zeros
    X(1:3,:) = [];
end