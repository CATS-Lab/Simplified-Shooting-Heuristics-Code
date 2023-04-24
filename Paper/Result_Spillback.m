clear;close all;
path_strs = strsplit(mfilename('fullpath'),'\');
cur_path = []; 
for folder = path_strs(1:end-1)
    cur_path = [cur_path folder{1} '\'];
end
cd(cur_path);
cd('../');
INITIALIZATION = 1;
include;
err_tol=1e-7;

parameters_backspill;
generate_boundary_backspill;

gamma = tau +s/v_max;
beta_1 = [(N-2)*sqrt(2*v_max*Delta(N))-(N-1)*sqrt(2*v_max*Delta_prev(N))]; 
beta_1
phis = [0.06:0.01:1.8];
thetas = [];
lambda = 0.5;
for i = 1:length(phis)
    phi = phis(i);
    evaluate_given_parameters;
    
    thetas=[thetas,min(delta(:,1))];
end
hFig=figure(111); 
FontSize = 11;
w_fig =300;
h_fig = 200;
figure_initialization;
plot(phis,thetas,'b','linewidth',2);
[delta_max,max_i] = max(thetas);
[delta_min,min_i] = min(thetas(max_i+1:end));
min_i = max_i+min_i;
xlabh=xlabel('$\phi$ (m/s$^2$)');
ylabh = ylabel('$\delta^*_1(\phi)$ (sec)');
ylims=get(gca,'ylim');
plot([phis(max_i),phis(max_i)],[ylims(1),delta_max],'k:')
plot([phis(min_i),phis(min_i)],[ylims(1),delta_min],'k:')
plot([0,phis(max_i)],[delta_max,delta_max],'k:')
plot([0,phis(min_i)],[delta_min,delta_min],'k:')
title('(b)')
folder_fig = '../Paper/Figure/';
saveas(gcf,[folder_fig,['result_spillback_delta_phi.eps']],'eps2c');



extreme_is=[max_i, min_i]
extreme_phis=thetas([max_i, min_i])
extreme_locs=extreme_phis*v_max
%return
phis = [phis(max_i),phis(min_i)];
lambda = 0.5;
title_names={'(a) ','(b) '};
phi_names = {'\phi^0','\phi^\texttt{E}'};
for i_phi = 1:length(phis)   
    phi = phis(i_phi);

    evaluate_given_parameters;
    extension =0;
    convert_trajectory_format;

    figure_num =i_phi;
    FontSize = 11;
    Draw_Colorbar=1;
    w_fig =500;
    h_fig = 300;
    Is_Ticks =1;
    plot_frame
    if i_phi>1
       set(ylh,'Color','w'); 
    end
    %is_cross=1;
    delta_t=5;
    plot_trajectories_colored_speed;
    plot([0,T_max],[min(delta(:,1)),min(delta(:,1))]*v_max,'y--'...
        ,'linewidth',2);
    set(gca,'position',[0.18,0.2,0.65,0.65]);
    t_name =strcat(title_names(i_phi),'$\phi=',phi_names(i_phi),'=',num2str(phi),'\texttt{m/s}^{2}$'); 
    title(t_name);
    saveas(gcf,[folder_fig,['result_spill_back_traj_',num2str(i_phi),'.eps']],'eps2c');
   savefig(['Figure/result_spill_back_traj_',num2str(i_phi),'.fig',])
       
end

%saveas(gcf,[folder_fig,['Illur_phi_delta.eps']],'eps2c');



