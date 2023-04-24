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
L =500;
generate_boundary_nonstop;
    
phi = -a_max*a_min/(a_max-a_min);
lambda = -a_min/(a_max-a_min);
evaluate_given_parameters;
extension =0;
convert_trajectory_format;

FontSize = 11;
figure_num =1;
w_fig =400;
h_fig = 250;


Draw_Colorbar=1;
Is_Ticks =1;
plot_frame
plot_trajectories_colored_speed;
for n = 1:N
    %plot(t_plus(n),L,'b*')
    plot(t_opp_plus(n),L,'rv')
    plot([t_opp_minus(n),t_opp_plus(n)],[2*L,L],'-r')
end
set(gca,'position',[0.15,0.2,0.65,0.65]);
title('Extreme acceleration case (EA)')
folder_fig = '../Paper/Figure/';
saveas(gcf,[folder_fig,['result_nonstop_traj_EA.eps']],'eps2c');
%optimization results;
Optimization;
extension =0;
convert_trajectory_format;

figure_num =3;

plot_frame
plot_trajectories_colored_speed;
for n = 1:N
    %plot(t_plus(n),L,'b*')
    plot(t_opp_plus(n),L,'rv')
    plot([t_opp_minus(n),t_opp_plus(n)],[2*L,L],'-r')
end
set(gca,'position',[0.15,0.2,0.65,0.65]);
title('Optimial trajectory case (OT)')

folder_fig = '../Paper/Figure/';
saveas(gcf,[folder_fig,['result_nonstop_traj_OT.eps']],'eps2c');

    