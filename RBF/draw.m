x_car_data=x_car.data;

y_car_data=y_car.data;

x_model_data=x_model.data;

y_model_data=y_model.data;

x_ideal_data=x_ideal.data;

y_ideal_data=y_ideal.data;

plot(x_car_data,y_car_data,'b');

hold on;

plot(x_model_data,y_model_data,'r--');

hold on;

plot(x_ideal_data,y_ideal_data,'k--');
