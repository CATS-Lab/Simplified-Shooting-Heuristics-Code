
if ~exist('w_fig') %good_for_video
    if exist('PRESENTATION')
        w_fig =900;
        h_fig = 500;
    end

end
if ~ exist('FontSize')
    if exist('PRESENTATION')
        FontSize =20;
    else
        FontSize =12;
    end
end

if ~ exist('Is_Ticks')
    Is_Ticks =1;
end

if ~exist('Draw_Colorbar')
    Draw_Colorbar = 0;
end

%% initialize the figure
if ~exist('figure_num')
    figure_num = 1;
end
hFig=figure(figure_num);

figure_initialization
%% draw the highway
if ~exist('d_edge')
    d_edge = 0.12;
end
if ~exist('u_edge')
    u_edge = 0.11;
end
if ~exist('l_edge')
    l_edge = 0.02;
end
if ~exist('L0')
    L0 = 0;
end
if ~exist('L1')
    L1 = 1.1*L;
end
h_wid = 0.06;
lane_width = 3;
sig_h = 0.2*(L1-L0);
sig_w = 1.5*lane_width;

pavement_color = [0.5,0.5,0.5];
highway_Ax = gca;
set(highway_Ax,'position',[l_edge   d_edge  h_wid  (1-d_edge-u_edge)]);
set(highway_Ax,'Visible','off')
rectangle('Position',[-lane_width/2,L0,lane_width,L1-L0],'edgeColor',pavement_color,'FaceColor',pavement_color)
plot([-lane_width/2,-lane_width/2],[L0,L1],'y','LineWidth',2);
plot([lane_width/2,lane_width/2],[L0,L1],'y','LineWidth',2);
xlim([-sig_w-0.6*lane_width,0.6*lane_width]);
ylim([L0,L1]);
arrow([0,L0+2*(L1-L0)/5],[0,L0+3*(L1-L0)/5],'EdgeColor','w','FaceColor','w');

%% draw the time space gram for trajectories
traj_start = 0.14;
if Draw_Colorbar
    t_wid = 0.75;
else
    t_wid = 0.82;
end
traj_Ax = axes('position',[traj_start  d_edge t_wid 1-d_edge-u_edge]);

ylim([L0,L1]);
xlim([0,T_max])

%% Show ticks or not
if ~Is_Ticks
    set(traj_Ax,'XTick',[]);
    set(traj_Ax,'YTick',[]);
    xlabel('Time')
    ylabel('Location')
    text(-0.04*T_max,L,'$L$')
    text(-0.03*T_max,L0,'$0$')
else
    xlabel('Time (s)')
    ylabel('Highway Segment (m)')
end

    



arrow([0,L0],[T_max,L0],'Length',10,'TipAngle',20); 
arrow([0,L0],[0,L1],'Length',10,'TipAngle',20); 
%% draw the color bar for speed
if  Draw_Colorbar
    c_start = 0.92;
    r_edge = 0.06;
    
    cm = colormap(flipud(jet));%flipud(copper)
    v_min = 0;
    v_grade = size(cm,1);
    vs_color = linspace(v_min,v_max,v_grade);
    cb = colorbar('position',[c_start  d_edge 1-c_start-r_edge, 1-d_edge-u_edge]);
    set(gca, 'CLim', [v_min, v_max]);
    if Show_Ticks
        title(cb,'v (m/s)')
    else
        title(cb,'speed')
    end
    % if ~Show_Ticks
    %     set(cb,'YTick',[]);
    %     text(0,1,'0','Parent',cb)
    %     %set(cb,'YTickLabel',{'0';'$\bar{v}$'});
    % end
    axes(traj_Ax);
end

hold all;
plot([0,T_max],[L,L],':K');


