% 1 if train 0 otherwise
train = 1;
% 1 if test 0 otherwise
test = 0;
% 1 if features method changes (requires rebuilt features), 0 otherwise
changeFeatures = 0;
% 1 if labels method changes (requires rebuilt labels), 0 otherwise
changeLabels = 0;
% Set to 1 for mean CAR, anything else for median CAR
CARflag = 2;
% 1 if visualize 0 otherwise
visualizePredictions = 0;

if train == 1
    for i = 1:3
        kubanek(i,CARflag, changeFeatures, changeLabels, visualizePredictions);
    end
end

if test == 1
    for i = 1:3
        kubanek_test(i,CARflag);
    end
    submission_assemble;
end