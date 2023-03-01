%%
close all;
figure(1)
load('Path.mat');

plot(xr,yr)
hold on
%
plot(simout_5.data(:,1),simout_5.data(:,2),'--')%速度5m/s跟踪路径

plot(simout_10.data(:,1),simout_10.data(:,2),':')%速度10m/s
 
plot(simout_15.data(:,1),simout_15.data(:,2),'-.')%速度15m

xlabel('X/m');
ylabel('Y/m');
legend("期望路径","跟踪路径-5m/s","跟踪路径-10m/s","跟踪路径-15m/s") %添加图例


%figure(2)
%plot(delta_out.time,delta_out.data)%时间，数捿
