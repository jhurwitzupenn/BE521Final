function [ X ] = BuildFeatures( data, fs, winLen, winDisp, numChannels )
    TimeAvg = @(x) mean(x);
    NumWins = @(xLen, fs, winLen, winDisp) xLen/(winDisp*fs) - winLen/winDisp+1; 

    numWins = NumWins(length(data), fs, winLen, winDisp);
    TimeDomainAvg = zeros(numWins, numChannels);
    FreqAvg5to15 = zeros(numWins, numChannels);
    FreqAvg20to25 = zeros(numWins, numChannels);
    FreqAvg75to115 = zeros(numWins, numChannels);
    FreqAvg125to160 = zeros(numWins, numChannels);
    FreqAvg160to175 = zeros(numWins, numChannels);
    
    VarAvg = @(x) var(x);
    VarianceAvg = zeros(numWins, numChannels);

    f = 1:175;
    for i = 1:numChannels
        TimeDomainAvg(:,i) = MovingWinFeats(data(:,i), fs, winLen, winDisp, TimeAvg);
        VarianceAvg(:,i) = MovingWinFeats(data(:,i), fs, winLen, winDisp, VarAvg);
        [s,f,~] = spectrogram(data(:,i),winLen*1e3,round((winLen-winDisp)*1e3)...
            ,f,fs);
        
        FreqAvg5to15(:,i) = mean(abs(s(5:15,:)))';
        FreqAvg20to25(:,i) = mean(abs(s(20:25,:)))';
        FreqAvg75to115(:,i) = mean(abs(s(75:115,:)))';
        FreqAvg125to160(:,i) = mean(abs(s(125:160,:)))';
        FreqAvg160to175(:,i) = mean(abs(s(160:175,:)))';
    end
    
    delay = 3;
    numwindows = 3;
    X = zeros(numWins,numChannels*7*(numwindows)+1);
    for i = delay+1:numWins
        start = i - delay;
        stop = start+numwindows-1;
        X(i,:) = [1, reshape(TimeDomainAvg(start:stop,1:numChannels),1,numChannels*numwindows),...
            reshape(FreqAvg5to15(start:stop,1:numChannels),1,numChannels*numwindows),...
            reshape(FreqAvg20to25(start:stop,1:numChannels),1,numChannels*numwindows),...
            reshape(FreqAvg75to115(start:stop,1:numChannels),1,numChannels*numwindows),...
            reshape(FreqAvg125to160(start:stop,1:numChannels),1,numChannels*numwindows),...
            reshape(FreqAvg160to175(start:stop,1:numChannels),1,numChannels*numwindows),...
            reshape(VarianceAvg(start:stop,1:numChannels),1,numChannels*numwindows)];
    end
    
    % Remove first delay rows of zeros
    X(1:delay,:) = [];
end