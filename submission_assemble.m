load('predicted_1.mat');
predict_Y_1 = predict_Y;
load('predicted_2.mat');
predict_Y_2 = predict_Y;
load('predicted_3.mat');
predict_Y_3 = predict_Y;

predicted_dg = cell(3,1);
predicted_dg{1} = predict_Y_1;
predicted_dg{2} = predict_Y_2;
predicted_dg{3} = predict_Y_3;
save('predicted_dg3.mat','predicted_dg');