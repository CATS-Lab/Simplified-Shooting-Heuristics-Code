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
%entry_saturation_rate = .6;
generate_boundary_signalized;

a_max = 2;
a_min = -3.5;

%non_smoothed results

phi = -a_max*a_min/(a_max-a_min);
lambda = -a_min/(a_max-a_min);
evaluate_given_parameters;
convert_trajectory_format;

w_fig =400;
h_fig = 250;
FontSize = 11;


figure_num =2;
Draw_Colorbar=1;

plot_frame
%Is_Cross = 1;
plot_trajectories_colored_speed;
set(gca,'position',[0.15,0.2,0.65,0.65]);
title('Extreme acceleration case (EA)')
folder_fig = '../Paper/Figure/';
saveas(gcf,[folder_fig,['result_singalized_traj_extreme_.eps']],'eps2c');

%optimization results;
Optimization;
convert_trajectory_format;

figure_num =3;
Draw_Colorbar=1;
Is_Cross=0;
plot_frame
plot_trajectories_colored_speed;
set(gca,'position',[0.15,0.2,0.65,0.65]);
title('Optimial trajectory case (OT)')

folder_fig = '../Paper/Figure/';
saveas(gcf,[folder_fig,['result_singalized_traj_opt_.eps']],'eps2c');