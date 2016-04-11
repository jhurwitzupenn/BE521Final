function y = apply_Kramer(x)
    % powerline filter
    % 60hz
    [b,a] = butter(3,[59 61]./(1000/2),'stop');
    % 120hz
    [b2,a2] = butter(3,[119 121]./(1000/2),'stop');
    % lowpass
    [blow,alow] = butter(3,150/(1000/2),'low');
    % highpass
    [bhigh,ahigh] = butter(3,1/(1000/2),'high');
    
    % Apply filters
    y = filtfilt(b, a, x);
    y = filtfilt(b2, a2, y);
    y = filtfilt(blow, alow, y);
    y = filtfilt(bhigh, ahigh, y);
end