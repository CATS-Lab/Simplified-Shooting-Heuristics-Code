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
% 
parameters_one_run;
generate_boundary_one_run;

phi = -a_max*a_min/(a_max-a_min);
lambda = -a_min/(a_max-a_min);
evaluate_given_parameters; % generatl delta_ni, corresponding accelerations
convert_trajectory_format; % covert the output to ts_all,vs_all,as_all,t_plus
obj_EA=fun_obj(ts_all,vs_all,as_all,t_plus)/N; % VSP objective
obj_EA_comf=fun_obj(ts_all,vs_all,as_all,t_plus,2)/N; % SA objective

%Plot trajectories
figure_num =1;
FontSize = 14;
Draw_Colorbar=1;
w_fig =500;
h_fig = 300;
plot_frame
%Is_Cross = 1;
plot_trajectories_colored_speed;
set(gca,'position',[0.15,0.2,0.65,0.65]);
title('Extreme acceleration case (EA)')


Optimization;
convert_trajectory_format;
obj_OT=fun_obj(ts_all,vs_all,as_all,t_plus)/N;
obj_OT_comf=fun_obj(ts_all,vs_all,as_all,t_plus,2)/N;

figure_num =2;
FontSize = 14;
Draw_Colorbar=1;
w_fig =500;
h_fig = 300;
Is_Cross=1;
plot_frame
plot_trajectories_colored_speed;
set(gca,'position',[0.15,0.2,0.65,0.65]);
title('Optimial trajectory case (OT)')


    