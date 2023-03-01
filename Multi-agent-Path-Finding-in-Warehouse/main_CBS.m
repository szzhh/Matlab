clear;
clc;
close all;
%% 初始化
%%设置场景大小
xlength=61;
ylength=29;

xy2rc=@(x,y)[ylength+1-y;x];
rc2xy=@(r,c)[c;ylength+1-r];

%%设置机器人数目
robotNum=5;%机器人数量
podNum=800;
depotNum = 8;
taskNum = robotNum;%%目的地数目



sz=get(0,'screensize');
sz(1,2) = 80;
sz(1,4) = 950;
h=figure('outerposition',sz);
assignin('base','h',h); %in case of any callback errors.
hold on;
grid on;
set(gca,'xtick',0:1:xlength);
set(gca,'ytick',0:1:ylength);
axis equal;
axis([0 xlength+1 0 ylength+1]);
axis manual;

%%初始化存储矩阵
[RobotStates,PodStates,DepotStates,StorageOccupancy]=initialize(xlength,ylength,robotNum,podNum,depotNum);

%存储当前状态
globalTime = 1;
AllRobotState = zeros(robotNum,3);
AllPodState = zeros(podNum,3);

MapOccupancy = zeros(ylength,xlength);
RobotOccupancy = zeros(ylength,xlength);

PodOccupancy = StorageOccupancy;
MapOccupancy = MapOccupancy+PodOccupancy;

%生成随机任务
TaskCell=cell(taskNum,1);
for i=1:taskNum
    task=Task;
    task.PodID=randi([1 podNum]);
    task.StationID=randi([1 depotNum]);
    task.ProcessTime=randi([5 20]);
    task.ReturnState = zeros(1,3);
    TaskCell{i,1}=task;
end

save('taskSet.mat','TaskCell');
load('taskSet.mat');


%%生成目的地
StartXYA = RobotStates;
GoalXYA = zeros(robotNum,3);
StartRCA = zeros(robotNum,3);
GoalRCA = zeros(robotNum,3);

temp= randperm(podNum);
for i=1:robotNum
    StartRCA(i,1:2) = xy2rc(StartXYA(i,1),StartXYA(i,2));%将xy坐标系 
    StartRCA(i,3) = StartXYA(i,3);
    GoalXYA(i,1:2) = PodStates(temp(i),1:2);
    GoalRCA(i,1:2) = xy2rc(GoalXYA(i,1),GoalXYA(i,2));
    GoalRCA(i,3) = randi([1 4]);    
end

%%绘制仓储场景
%env_plot(xlength,ylength,RobotStates,PodStates,DepotStates)

tic;

%%
%第一行为1号机器人的行进的X 、 Y坐标 方向、时间
AllPathCell=MRPP_CBS(MapOccupancy,StartRCA,GoalRCA,0);%% CBS算法 
toc;
%save('allPath.mat','AllPathCell','StartRCA','GoalRCA');
%load('allPath.mat');

futureSize=3;
HeatMap=cell(futureSize,1);
for i=1:futureSize
    HeatMap{i,1}=zeros(robotNum,3);
end
%% 绘制结果
%图片
video = VideoWriter('simulation');%生成视频
video.FrameRate=2;
open(video);
for loop=1:100
    frame = getframe;
    writeVideo(video,frame);
    pause(0.5);
    cla;
    
    for i=1:robotNum
        if  ~isempty(AllPathCell{i,1})
            path = AllPathCell{i,1};
            if globalTime<=size(path,1)
                state = path(globalTime,:);
                AllRobotState(i,1:2)=rc2xy(state(1,1),state(1,2));
                AllRobotState(i,3)=state(1,3);
            end
            
            for j=1:futureSize
                if globalTime+j<=size(path,1)
                    state = path(globalTime+j,:);
                    temp = HeatMap{j,1};
                    temp(i,1:2)=rc2xy(state(1,1),state(1,2));
                    temp(i,3)=state(1,3);
                    HeatMap{j,1} = temp;
                else
                    state = path(end,:);
                    temp = HeatMap{j,1};
                    temp(i,1:2)=rc2xy(state(1,1),state(1,2));
                    temp(i,3)=state(1,3);
                    HeatMap{j,1} = temp;
                end
            end                       
        end
    end
    AllPodState=PodStates;
    plotAll(xlength,ylength,AllRobotState,AllPodState,DepotStates);
    globalTime = globalTime + 1;
    loop=loop+1;
end

close(video);