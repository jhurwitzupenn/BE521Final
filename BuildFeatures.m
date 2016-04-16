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
    for i = 1:numChannels
        TimeDomainAvg(:,i) = MovingWinFeats(data(:,i), fs, winLen, winDisp, TimeAvg);
        FreqAvg5to15(:,i) = MovingWinFeats_Freq(data(:,i), fs, winLen, winDisp, [5,15]);
        FreqAvg20to25(:,i) = MovingWinFeats_Freq(data(:,i), fs, winLen, winDisp, [20,25]);
        FreqAvg75to115(:,i) = MovingWinFeats_Freq(data(:,i), fs, winLen, winDisp, [75,115]);
        FreqAvg125to160(:,i) = MovingWinFeats_Freq(data(:,i), fs, winLen, winDisp, [125,160]);
        FreqAvg160to175(:,i) = MovingWinFeats_Freq(data(:,i), fs, winLen, winDisp, [160,175]);
    end
    fprintf('Generating features done\n');

    X = zeros(numWins,numChannels*6+1);
    delay = 3;
    for i = 4:numWins
        X(i,:) = [1, reshape(TimeDomainAvg(i-delay,1:numChannels),1,numChannels),...
            reshape(FreqAvg5to15(i-delay,1:numChannels),1,numChannels),...
            reshape(FreqAvg20to25(i-delay,1:numChannels),1,numChannels),...
            reshape(FreqAvg75to115(i-delay,1:numChannels),1,numChannels),...
            reshape(FreqAvg125to160(i-delay,1:numChannels),1,numChannels),...
            reshape(FreqAvg160to175(i-delay,1:numChannels),1,numChannels)];
    end
end

