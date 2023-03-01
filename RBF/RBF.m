%% I. ��ջ�������
% clear all
clc
%% II. ѵ����/���Լ�����
% %%
% % 1. ��������
% load spectra_data.mat
% %%
% % 2. �������ѵ�����Ͳ��Լ�
% temp = randperm(size(NIR,1));
% % ѵ�����D�D50������
% P_train = NIR(temp(1:50),:)';
% T_train = octane(temp(1:50),:)';
% % ���Լ��D�D10������
% P_test = NIR(temp(51:end),:)';
% T_test = octane(temp(51:end),:)';
% N = size(P_test,2);
%% II. ѵ����/���Լ�����
%%
% 1. ��������
load kinematics_model_data2.mat
%%
% 2. �������ѵ�����Ͳ��Լ�
temp = randperm(size(Input_temp,1));
% ѵ�����D�D1700������
P_train = Input_temp(temp(1:1700),:)';
T_train = Output_temp(temp(1:1700),:)';
% ���Լ��D�D130������
P_test = Input_temp(temp(1701:end),:)';
T_test = Output_temp(temp(1701:end),:)';
N = size(P_test,2);
%% III. RBF�����紴�����������
%%
% 1. ��������
net = newrbe(P_train,T_train,10);
%%
% 2. �������
T_sim = sim(net,P_test);
%% IV. ��������
%%
% 1. ������error
error = abs(T_sim - T_test)./T_test;
%%
% 2. ����ϵ��R^2
R2 = (N * sum(T_sim .* T_test) - sum(T_sim) * sum(T_test))^2 / ((N * sum((T_sim).^2) - (sum(T_sim))^2) * (N * sum((T_test).^2) - (sum(T_test))^2)); 
%%
% 3. ����Ա�
result = [T_test' T_sim' error']
%% V. ��ͼ%% V. ��ͼ
figure(1)
plot(1:N,T_test,'b:*',1:N,T_sim,'r-o','linewidth',1)
legend('RBF��ʵֵ','RBF����ֵ')
xlabel('Ԥ������')
ylabel('����ϵ��')
figure(2)
plot(1:N,error,'b-o','linewidth',1)
xlabel('Ԥ������')
ylabel('RBF�������')
% string = {'���Լ�����ϵ��Ԥ�����Ա�';['R^2=' num2str(R2)]};
% title(string)
figure(1)
plot(1:N,T_test,'b:*',1:N,T_sim,'r-o','linewidth',1)
legend('RBF��ʵֵ','RBF����ֵ')
xlabel('Ԥ������')
ylabel('����ϵ��')
figure(2)
plot(1:N,error,'b-o','linewidth',1)
xlabel('Ԥ������')
ylabel('RBF�������')
% string = {'���Լ�����ϵ��Ԥ�����Ա�';['R^2=' num2str(R2)]};
% title(string)
 