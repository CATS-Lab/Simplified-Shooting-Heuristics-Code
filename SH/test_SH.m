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

parameters_SH;
generate_boundary_SH;
plat_size
cpu_t_start = cputime;

a_temp = min(a_max,-a_min)/4;
 

% a_platoon = zeros(plat_size,4);
% 
% for plat_i = 1:plat_size
%     a_platoon(plat_i,:)=[a_max,a_min,a_max/1.2,a_min/1.2]/plat_i^1.5;
% end

a_comfort = a_temp;
a_comfort_dec = -a_temp;
a_reverse_comfort = a_temp;
a_reverse_comfort_dec = -a_temp;
REPORT_ERROR_AT_INFEASIBILITY=1;
IS_DYN_PLOT = 1;
shooting_heuristic;
Feasibility

cpu_t_end = cputime;

result_vec = [N, cpu_t_end-cpu_t_start];

% figure_num =2;
% FontSize = 11;
% Draw_Colorbar=1;
% w_fig =500;
% h_fig = 300;
% Is_Ticks = 1;
% Draw_Colorbar =0;
% IS_SIGNAL =0;
% plot_frame
% is_cross = 0;
% is_cross
% extent_portion =0.00;
% %traj_colors = {'b'};
% traj_colors ={'k','b','r','g','c'};
% for plat_i =1:plat_size
%     n_start = platoons{plat_i}(1);
%     n_end = platoons{plat_i}(end);
%     is_shadow =0;
%     is_cross =1;
%     line_color = traj_colors{mod(plat_i,length(traj_colors))+1};
%     plot_trajectories;
% end

       

    

