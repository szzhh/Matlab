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
sizes.NumContStates  = 0;   %模块连续状态变量的个数
sizes.NumDiscStates  = 2;   %模块离散状态变量的个数
sizes.NumOutputs     = 1;   %模块输出变量的个数
sizes.NumInputs      = 2;   %模块输入变量的个数
sizes.DirFeedthrough = 1;   %模块是否存在直接贯通
sizes.NumSampleTimes = 1;   %模块的采样时间个数, 至少是一个
sys = simsizes(sizes);      %设置完后赋给sys输出
x0 = [0;0];             %状态变量初值设为0
str = [];                   %保留参数,置[]
ts  = [0.01 0];             %采样周期设为0表示是连续系统
% 地图导入（期望轨迹）
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