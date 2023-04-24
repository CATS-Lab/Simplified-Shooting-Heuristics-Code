clear;close all;
path_strs = strsplit(mfilename('fullpath'),'\');
cur_path = []; 
for folder = path_strs(1:end-1)
    cur_path = [cur_path folder{1} '\'];
end
cd(cur_path);
cd('../');
INITIALIZATION = 1;
IS_PLOT=1;
include;

ts_mat = [
          0,2,7,9,14,16;
          0,1,3,3,5,6;
    ];

for i_fig = 1:2

    hFig=figure(i_fig);clf; 
    whitebg(hFig,'white');
    edge =0.15;
    hAx=axes('position',[0.5*edge  edge  1-1*edge  1-1.6*edge]);
    %set(gca,'Visible','off')
    set(gca,'XTick',[])
    set(gca,'YTick',[])
    hold all
    FontSize=11;
    set(0,'DefaultAxesFontName', 'Times New Roman', 'DefaultAxesFontSize',FontSize,'DefaultTextFontSize',FontSize,'DefaultTextInterpreter','Latex');
    w = 300;
    h =w;
    set(hFig,'Position',[100,100,w,h])
    set(gcf, 'PaperUnits', 'centimeters');
    saved_fig_size=[0 0 w/35 h/35];
    set(gcf, 'PaperPosition', saved_fig_size);

    L = 5;
    v_max = 5;
    a_plus = 1;
    a_mins = 1;
    ts = ts_mat(i_fig,:);
    
    as = [0,-a_mins,0,a_plus,0];
    vs = [v_max];
    xs = [0];
    for i = 2:6
        vs(i) = vs(i-1)+as(i-1)*(ts(i)-ts(i-1));
        xs(i) = xs(i-1) + (vs(i)+vs(i-1))/2*(ts(i)-ts(i-1));
    end
    xlim([ts(1),ts(end)]);
    ylim([xs(1),xs(end)]*1.1);
    
    
    t_step = 0.1;
    plot(0, 0,'b+','markersize',10);

    for i = 2:6
        point_num = max(2, round((ts(i)-ts(i-1))/t_step)+1);
        ts_sec = linspace (ts(i-1),ts(i),point_num);
        dts = ts_sec -min(ts_sec);
        xs_sec = xs(i-1)+vs(i-1)*dts + 0.5*as(i-1)*dts.^2;
        plot(ts_sec, xs_sec,'b','linewidth',2);
        plot(ts_sec(end), xs_sec(end),'b+','markersize',10);

        if i == 2 || i == 6
            len = length(ts_sec);
            i_temp1 = round(len/4)+6-i;
            i_temp2 = round(len/2)+6-i;
            tm1 = ts_sec(i_temp1);
            xm1 = xs_sec(i_temp1);
            tm2 = ts_sec(i_temp2);
            xm2 = xs_sec(i_temp2);
            plot([tm1,tm2],[xm2,xm2],':k');
            plot([tm1,tm1],[xm1,xm2],':k');
            text(tm1-.2, xm2+.2,'$\bar{v}$','Rotation',45);
        elseif i ==3||i ==5
            len = length(ts_sec);
            i_temp = round(len/2);
            if i == 3
                str = '$-a^-$';
            else
                str = '$a^+$';
            end
            text(ts_sec(i_temp)-.2, xs_sec(i_temp)-5+i_fig,str,'Rotation',45);
        end    
    end
    text(0, -xs(end)*.1,'$t^-_n$');

    plot([ts(end),ts(end)],[0,xs(end)],':k');
    text(ts(end), -xs(end)*.1,'$t^+_n$');

    for i = 1:4

        if i == 2
            if ts(3) == ts(4)
               plot([ts(i+1),ts(i+1)],[0,xs(i+1)],':k');
               text(ts(i+1)-.8, -xs(end)*.1, ['$t_{n2}=t_{n3}$']);
                plot([ts(i+1),ts(i+1)],[0,xs(i+1)],':k');
               continue;
            end
        elseif i ==3
            if ts(3) == ts(4)
                continue;        
            end
        end
        plot([ts(i+1),ts(i+1)],[0,xs(i+1)],':k');
        text(ts(i+1), -xs(end)*.1, ['$t_{n',num2str(i),'}$']);
        text((ts(i+1)+ts(i))/2-.5/i_fig, 1.5/i_fig, ['$\delta_{n',num2str(i),'}$']);
    
    end
     plot([0,xs(end)/v_max],[0,xs(end)],'b--')
    
    Delta = ts(end)-xs(end)/v_max;
    if i_fig == 1
        title('(a)')
        t_shift =0.2;
         plot([xs(end)/v_max,ts(end)]-t_shift,[xs(end),xs(end)]-t_shift*v_max,'b--')
        text((xs(end)/v_max+ts(end))/2-1, xs(end)-3, ['$\Delta_{n}$']);

    else
        title('(b)')
        t_shift =0.2;
         plot([xs(end)/v_max,ts(end)]-t_shift,[xs(end),xs(end)]-t_shift*v_max,'b--')
        text((xs(end)/v_max+ts(end))/2-Delta/3, xs(end)+.2, ['$\Delta_{n}$']);

    end
    h_temp =1.07;
    h_edge =.07;
    plot([0,ts(end)],[xs(end),xs(end)]*h_temp,'b--')
    plot([0,0],[xs(end)*(h_temp-h_edge),xs(end)*(h_temp+h_edge)],'b--')
    plot([ts(end),ts(end)],[xs(end)*(h_temp-h_edge),xs(end)*(h_temp+h_edge)],'b--')
    text(ts(end)*0.47, xs(end)*1.01, ['$t_{n}^\Delta$']);

   
   
    folder_fig = '../Paper/Figure/';
    saveas(gcf,[folder_fig,['illur_sections_',num2str(i_fig),'_.eps']],'eps2c');
end

