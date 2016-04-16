% Suppress warnings
warning('off','all');

% Load dataset
addpath(genpath('../ieeg-matlab-1.13.2/'));
session = IEEGSession('I521_A0012_D001', 'jhurwitz', '../jhu_ieeglogin.bin');
session.openDataSet('I521_A0012_D002');
session.openDataSet('I521_A0012_D003');
session.openDataSet('I521_A0013_D001');
session.openDataSet('I521_A0013_D002');
session.openDataSet('I521_A0013_D003');
session.openDataSet('I521_A0014_D001');
session.openDataSet('I521_A0014_D002');
session.openDataSet('I521_A0014_D003');
%%

% more samples in the test sets than the training sets
numsamples1 = session.data(1).rawChannels(1).get_tsdetails.getNumberOfSamples;
numsamples2 = numsamples1;
numsamples3 = session.data(3).rawChannels(1).get_tsdetails.getNumberOfSamples;

% get first subject data
subject1trainingData = session.data(1).getvalues(1:numsamples1,1:62);
subject1gloveData = session.data(2).getvalues(1:numsamples2,1:5);
subject1testingData = session.data(3).getvalues(1:numsamples3,1:62);
%%
% get second subject data
subject2trainingData = session.data(4).getvalues(1:numsamples1,1:48);
subject2gloveData = session.data(5).getvalues(1:numsamples2,1:5);
subject2testingData = session.data(6).getvalues(1:numsamples3,1:48);
%%
% get third subject data
subject3trainingData = session.data(7).getvalues(1:numsamples1,1:64);
subject3gloveData = session.data(8).getvalues(1:numsamples2,1:5);
subject3testingData = session.data(9).getvalues(1:numsamples3,1:64);