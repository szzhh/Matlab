%%
close all;
figure(1)
load('Path.mat');

plot(xr,yr)
hold on
%
plot(simout_5.data(:,1),simout_5.data(:,2),'--')%�ٶ�5m/s����·��

plot(simout_10.data(:,1),simout_10.data(:,2),':')%�ٶ�10m/s
 
plot(simout_15.data(:,1),simout_15.data(:,2),'-.')%�ٶ�15m

xlabel('X/m');
ylabel('Y/m');
legend("����·��","����·��-5m/s","����·��-10m/s","����·��-15m/s") %���ͼ��


%figure(2)
%plot(delta_out.time,delta_out.data)%ʱ�䣬����
