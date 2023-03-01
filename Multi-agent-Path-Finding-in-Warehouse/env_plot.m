function  env_plot(xlength,ylength,RobotStates,PodStates,DepotStates)
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


rectangle('Position', [0,0,xlength+1,ylength+1],'lineWidth',5);
plot(DepotStates(:,1),DepotStates(:,2),'square','MarkerEdgeColor',[0.5 0.5 0.5],'MarkerFaceColor',[0.7 0.7 0.7],'MarkerSize',30);
plot(PodStates(:,1),PodStates(:,2),'square','MarkerEdgeColor','k','MarkerFaceColor',[1 1 1],'MarkerSize',20);
plot(RobotStates(:,1),RobotStates(:,2),'o','MarkerEdgeColor','k','MarkerFaceColor',[1 0 0],'MarkerSize',15);

end