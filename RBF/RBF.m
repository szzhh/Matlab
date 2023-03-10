%% I. 清空环境变量
% clear all
clc
%% II. 训练集/测试集产生
% %%
% % 1. 导入数据
% load spectra_data.mat
% %%
% % 2. 随机产生训练集和测试集
% temp = randperm(size(NIR,1));
% % 训练集――50个样本
% P_train = NIR(temp(1:50),:)';
% T_train = octane(temp(1:50),:)';
% % 测试集――10个样本
% P_test = NIR(temp(51:end),:)';
% T_test = octane(temp(51:end),:)';
% N = size(P_test,2);
%% II. 训练集/测试集产生
%%
% 1. 导入数据
load kinematics_model_data2.mat
%%
% 2. 随机产生训练集和测试集
temp = randperm(size(Input_temp,1));
% 训练集――1700个样本
P_train = Input_temp(temp(1:1700),:)';
T_train = Output_temp(temp(1:1700),:)';
% 测试集――130个样本
P_test = Input_temp(temp(1701:end),:)';
T_test = Output_temp(temp(1701:end),:)';
N = size(P_test,2);
%% III. RBF神经网络创建及仿真测试
%%
% 1. 创建网络
net = newrbe(P_train,T_train,10);
%%
% 2. 仿真测试
T_sim = sim(net,P_test);
%% IV. 性能评价
%%
% 1. 相对误差error
error = abs(T_sim - T_test)./T_test;
%%
% 2. 决定系数R^2
R2 = (N * sum(T_sim .* T_test) - sum(T_sim) * sum(T_test))^2 / ((N * sum((T_sim).^2) - (sum(T_sim))^2) * (N * sum((T_test).^2) - (sum(T_test))^2)); 
%%
% 3. 结果对比
result = [T_test' T_sim' error']
%% V. 绘图%% V. 绘图
figure(1)
plot(1:N,T_test,'b:*',1:N,T_sim,'r-o','linewidth',1)
legend('RBF真实值','RBF估计值')
xlabel('预测样本')
ylabel('补偿系数')
figure(2)
plot(1:N,error,'b-o','linewidth',1)
xlabel('预测样本')
ylabel('RBF估计误差')
% string = {'测试集补偿系数预测结果对比';['R^2=' num2str(R2)]};
% title(string)
figure(1)
plot(1:N,T_test,'b:*',1:N,T_sim,'r-o','linewidth',1)
legend('RBF真实值','RBF估计值')
xlabel('预测样本')
ylabel('补偿系数')
figure(2)
plot(1:N,error,'b-o','linewidth',1)
xlabel('预测样本')
ylabel('RBF估计误差')
% string = {'测试集补偿系数预测结果对比';['R^2=' num2str(R2)]};
% title(string)
 