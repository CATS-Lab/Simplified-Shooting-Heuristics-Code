
if ~exist('w_fig') %good_for_video
    w_fig =900;
    h_fig = 600;
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

if ~exist('IS_SIGNAL')
    IS_SIGNAL = 0;
end


%% initialize the figure
if ~exist('figure_num')
    figure_num = 1;
end
hFig=figure(figure_num);

figure_initialization

%% draw the time space gram for trajectories

traj_Ax = gca; 
if ~exist('L0')
    L0 = 0;
end
if ~exist('L1')
    L1 = 1.1*L;
end
ylim([L0,L1]);
xlim([0,T_max]);

if ~Is_Ticks
    set(traj_Ax,'XTick',[]);
    set(traj_Ax,'YTick',[]);
    text(-0.04*T_max,L,'$L$')
    text(-0.03*T_max,L0,'$0$')
    xlh=xlabel('Time');
    ylh=ylabel('Location');
else
    xlh=xlabel('Time (s)');
    ylh=ylabel('Highway Segment (m)');
end
if IS_SIGNAL
    if signal_phase>0
        plot([0,signal_phase],[L,L],'r','linewidth',2)
    end
    t_temp = signal_phase
    while t_temp<T_max
        plot([t_temp,t_temp+G],[L,L],':g','linewidth',2)
        plot([t_temp+G,t_temp+G+R],[L,L],'r','linewidth',2);
        t_temp = t_temp+G+R;
    end
end

%% draw the color bar for speed
cm = colormap(flipud(jet));%flipud(copper)
v_min = 0;
v_grade = size(cm,1);
vs_color = linspace(v_min,v_max,v_grade);
if Draw_Colorbar
    cb = colorbar();
    set(gca, 'CLim', [v_min, v_max]);
    title(cb,'v (m/s)')
    axes(traj_Ax);
end

arrow([0,L0],[T_max,L0],'Length',10,'TipAngle',20); 
arrow([0,L0],[0,L1],'Length',10,'TipAngle',20); 
hold all;
plot([0,T_max],[L,L],':K');







