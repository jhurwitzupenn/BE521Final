% powerline filter
% 60hz
[b,a] = butter(3,[59 61]./(1000/2),'stop');
% 120hz
[b2,a2] = butter(3,[119 121]./(1000/2),'stop');
% lowpass
[blow,alow] = butter(3,150/(1000/2),'low');
% highpass
[bhigh,ahigh] = butter(3,1/(1000/2),'high');
L = 310000;
NFFT = 2^nextpow2(L);
f = 1000/2*linspace(0,1,NFFT/2+1);
y = filtfilt(b, a, subject1trainingData(1, :));
y = filtfilt(b2, a2, y);
y = filtfilt(blow, alow, y);
y = filtfilt(bhigh, ahigh, y);
fft_unfilt = fft(subject1trainingData(1, :), NFFT);
fft_filt = fft(y, NFFT);

figure 
hold on
subplot(2, 2, 1)
plot(subject1trainingData(1, :));
title('unfiltered data')
subplot(2, 2, 2)
plot(y)
title('Filtered Data')
subplot(2, 2, 3)
plot(f, 2*abs(fft_unfilt(1:NFFT/2+1)))
ylim([0 10e7])
title('fft unfiltered Data')
subplot(2, 2, 4)
plot(f, 2*abs(fft_filt(1:NFFT/2+1)))
ylim([0 10e7])
title('fft filtered data')
hold off