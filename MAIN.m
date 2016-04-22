% Set to 1 for mean CAR, anything else for median CAR
CARflag = 2;
for i = 1:3
    kubanek(i,CARflag);
end
for i = 1:3
    kubanek_test(i,CARflag);
end
submission_assemble;