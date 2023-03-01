function [sys,x0,str,ts] = Kinematic_Compensation(t,x,u,flag)
switch flag
    case 0
        [sys,x0,str,ts] = mdlInitializeSizes; % Initialization
        
    case 2
        sys = mdlUpdates(t,x,u);              % Update discrete states
        
    case 3
        sys = mdlOutputs(t,x,u);              % Calculate outputs
        
    case {1,4,9}                              % Unused flags
        sys = [];
        
    otherwise
        error(['unhandled flag = ',num2str(flag)]); % Error handling
end
% End of dsfunc.

%% ==============================================================
% Initialization
%==============================================================
function [sys,x0,str,ts] = mdlInitializeSizes
close all;clc;
sizes = simsizes;
sizes.NumContStates  = 0;   %ģ������״̬�����ĸ���
sizes.NumDiscStates  = 2;   %ģ����ɢ״̬�����ĸ���
sizes.NumOutputs     = 1;   %ģ����������ĸ���
sizes.NumInputs      = 2;   %ģ����������ĸ���
sizes.DirFeedthrough = 1;   %ģ���Ƿ����ֱ�ӹ�ͨ
sizes.NumSampleTimes = 1;   %ģ��Ĳ���ʱ�����, ������һ��
sys = simsizes(sizes);      %������󸳸�sys���
x0 = [0;0];             %״̬������ֵ��Ϊ0
str = [];                   %��������,��[]
ts  = [0.01 0];             %����������Ϊ0��ʾ������ϵͳ
% ��ͼ���루�����켣��
global net_inner
net_inner = evalin('base','net');
%% ==============================================================
% Update the discrete states
%%==============================================================
function sys = mdlUpdates(t,x,u)

sys = x;
%End of mdlUpdate.

%% ==============================================================
% Calculate outputs
%==============================================================
function sys = mdlOutputs(t,x,u)
global net_inner
input = [u(1); u(2)];
Control_Input =  sim(net_inner,input);
sys= Control_Input;

%% End of mdlOutputs.