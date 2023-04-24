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

global tau s err_tol;
err_tol=1e-7;


parameters_compare;
generate_boundary_alg;
v_minus = v_max*(ones(N,1));
v_plus = v_max*(ones(N,1));  
plat_size 

phi = -a_max*a_min/(a_max-a_min);
lambda = -a_min/(a_max-a_min);
%optimization results;
Optimization;
convert_trajectory_format;

figure_num =2;
FontSize = 11;
Draw_Colorbar=1;
w_fig =400;
h_fig = 250;
plot_frame
Is_Cross = 1;
plot_trajectories_colored_speed;
set(gca,'position',[0.15,0.2,0.65,0.65]);
title('(a) PSA solution')
folder_fig = '../Paper/Figure/';
saveas(gcf,[folder_fig,['result_PSA_traj.eps']],'eps2c');

obj_type = 1;
SH_opt;
obj_SH_VSP = obj_opt;
figure_num =3;
Draw_Colorbar=1;
plot_frame
Is_Cross=1;
%Is_Cross = 1;
plot_trajectories_colored_speed;
set(gca,'position',[0.15,0.2,0.65,0.65]);
title('(b) NSG-SH solution')
saveas(gcf,[folder_fig,['result_NSG_traj.eps']],'eps2c');
           


