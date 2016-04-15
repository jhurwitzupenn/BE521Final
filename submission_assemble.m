predicted_dg = cell(3,1);
predicted_dg{1} = predict_Y_1;
predicted_dg{2} = predict_Y_2;
predicted_dg{3} = predict_Y_3;
save('predicted_dg.mat','predicted_dg');