
clear;
clc;
close all;
%% ��ʼ��
%%���ó�����С
xlength=61;%
ylength=29;

xy2rc=@(x,y)[ylength+1-y;x];
rc2xy=@(r,c)[c;ylength+1-r];


%%���û�������Ŀ
robotNum=5;%��������Ŀ
podNum=800;
depotNum = 8;
taskNum = robotNum;%%Ŀ�ĵ���Ŀ


%%��ʼ���洢����
[RobotStates,PodStates,DepotStates,StorageOccupancy]=initialize(xlength,ylength,robotNum,podNum,depotNum);

globalTime = 1;
AllRobotState = zeros(robotNum,3);
AllPodState = zeros(podNum,3);

MapOccupancy = zeros(ylength,xlength);
RobotOccupancy = zeros(ylength,xlength);

PodOccupancy = StorageOccupancy;
MapOccupancy = MapOccupancy+PodOccupancy;


%%����Ŀ�ĵ�
StartXYA = RobotStates;
GoalXYA = zeros(robotNum,3);
StartRCA = zeros(robotNum,3);
GoalRCA = zeros(robotNum,3);

temp= randperm(podNum);
for i=1:robotNum
    StartRCA(i,1:2) = xy2rc(StartXYA(i,1),StartXYA(i,2)); %��xy����ϵ 
    StartRCA(i,3) = StartXYA(i,3);
    GoalXYA(i,1:2) = PodStates(temp(i),1:2);  
    GoalRCA(i,1:2) = xy2rc(GoalXYA(i,1),GoalXYA(i,2));
    GoalRCA(i,3) = randi([1 4]);    
end
%%���Ʋִ�����


%env_plot(xlength,ylength,RobotStates,PodStates,DepotStates)

tic;
%%
%��һ��Ϊ1�Ż����˵��н���X �� Y���� ����ʱ��
AllPathCell=MRPP_CBS(MapOccupancy,StartRCA,GoalRCA,0); %% CBS�㷨 
toc;
% save('allPath3.mat','AllPathCell','StartRCA','GoalRCA');

% load('allPath.mat');%2��������

futureSize=3;
HeatMap=cell(futureSize,1);
for i=1:futureSize
    HeatMap{i,1}=zeros(robotNum,3);
end

%% ���ƽ��

%¼����Ƶ
video = VideoWriter('test');%������Ƶ
video.FrameRate=2;
open(video);
for loop=1:100
       if loop<=5
        env_plot(xlength,ylength,RobotStates,PodStates,DepotStates)
        hold on
        for i = 1:robotNum
        path = AllPathCell{i,1};
        robot_path=[];
        for i = 1:length(path)
        robot_path(i,1:2)=rc2xy(path(i,1),path(i,2));
        end
        plot(robot_path(:,1),robot_path(:,2),'LineWidth',2)
        end
        pause(0.1)
       end

    
    frame = getframe;
    writeVideo(video,frame);
    pause(0.1);
    cla;
    
    if loop>5
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
end

close all;
close(video);