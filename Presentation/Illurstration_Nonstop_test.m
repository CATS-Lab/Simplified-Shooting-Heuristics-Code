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

parameters_nonstop;
N=100;
L=600;
entry_saturation_rate = .5;
opp_entry_saturation_rate = .5;
   
generate_boundary_nonstop;
    
a_max = 4;
a_min = -4;
phi = -a_max*a_min/(a_max-a_min);
lambda = -a_min/(a_max-a_min);
evaluate_given_parameters;
extension =0;
convert_trajectory_format;
obj_OT=fun_obj(ts_all,vs_all,as_all,t_plus)/N

figure_num =1;
FontSize = 14;
Draw_Colorbar=1;
w_fig =500;
h_fig = 300;
Is_Ticks =0;
plot_frame
plot_trajectories_colored_speed;
for n = 1:N
    plot(t_plus(n),L,'b*')
    plot(t_opp_plus(n),L,'rv')
    plot([t_opp_minus(n),t_opp_plus(n)],[2*L,L],'-r')
end
set(gca,'position',[0.15,0.2,0.65,0.65]);
title('Extreme accelerations (EA)')

%optimization results;
Optimization;
extension =0;
convert_trajectory_format;
figure_num =3;

plot_frame
plot_trajectories_colored_speed;
for n = 1:N
    plot(t_plus(n),L,'b*')
    plot(t_opp_plus(n),L,'rv')
    plot([t_opp_minus(n),t_opp_plus(n)],[2*L,L],'-r')
end
set(gca,'position',[0.15,0.2,0.65,0.65]);
title('Optimized trajectories (OT)')

    