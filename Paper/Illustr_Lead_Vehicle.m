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

parameters_illustr_lead;
generate_boundary_illustr_lead;

a_max = 2;
a_min = -2;

phi = -a_max*a_min/(a_max-a_min);
lambda = -a_min/(a_max-a_min);
evaluate_given_parameters;
convert_trajectory_format;

figure_num =2;
FontSize = 11;
Draw_Colorbar=1;
w_fig =500;
h_fig = 300;
Is_Ticks = 0;
Draw_Colorbar =0;
IS_SIGNAL =0;
plot_frame
is_cross = 0;
extent_portion =0.00;
%traj_colors = {'b'};
is_shadow =1;
plot_trajectories_stream;
%set(gca,'position',[0.15,0.2,0.65,0.65]);
for n = 1:N
    plot(ts_all{n}(5),ps_all{n}(5),'b+')
end

n=1*plat_length+1;
text(t_plus(n)-2, L+7,'$\hat{n}_i(\phi)$');

n=2*plat_length+1;
text(t_plus(n)-2, L+7,'$\hat{n}_{i+1}(\phi)$');


folder_fig = '../Paper/Figure/';
saveas(gcf,[folder_fig,['illustr_lead_vehicle.eps']],'eps2c');
 

%plot inital states

