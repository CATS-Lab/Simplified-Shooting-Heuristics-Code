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

parameters_signalized;
entry_saturation_rate = .5;   
N=50;
alpha=0.5;
L=500;
signal_phase =0;
 
generate_boundary_signalized;

a_max = 2;
a_min = -1;

% %benchmark;
% t_plus_old = t_plus;
% figure_num =1;
% 
% IS_DYN_PLOT = 0;
% benchmark_run_gipps;
% 
% T_max_old = T_max;
% T_max =T_max*1.2;
% figure_num =1;
% FontSize = 14;
% Draw_Colorbar=1;
% w_fig =500;
% h_fig = 300;
% plot_frame
% plot_trajectories_colored_speed;
% set(gca,'position',[0.15,0.2,0.65,0.65]);
% title('Manual benchmark (MB)')
% t_plus = t_plus_old;

%non_smoothed results

phi = -a_max*a_min/(a_max-a_min);
lambda = -a_min/(a_max-a_min);
evaluate_given_parameters;
convert_trajectory_format;

figure_num =2;
FontSize = 14;
Draw_Colorbar=1;
w_fig =500;
h_fig = 300;
plot_frame
%Is_Cross = 1;
plot_trajectories_colored_speed;
set(gca,'position',[0.15,0.2,0.65,0.65]);
title('Extreme accelerations (EA)')

%optimization results;
Optimization;
convert_trajectory_format;
figure_num =3;
FontSize = 14;
Draw_Colorbar=1;
w_fig =500;
h_fig = 300;
plot_frame
plot_trajectories_colored_speed;
set(gca,'position',[0.15,0.2,0.65,0.65]);
title('Optimized trajectories (OT)')