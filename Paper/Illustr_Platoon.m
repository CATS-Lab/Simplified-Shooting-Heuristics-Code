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

parameters_illustr_platoon;
generate_boundary_illustr_platoon;

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
is_shadow =0;
plot_trajectories_stream;
%set(gca,'position',[0.15,0.2,0.65,0.65]);

for plat_i = 1:2
    n=plat_i*plat_length;
    is_shadow =1;
    plot_trajectory_n;
    plot([t_plus(n)+tau+s/v_max,t_plus(n)+tau+s/v_max-L/v_max], [L,0],'--k');
    
    plot([t_minus(n+1)+L/v_max,t_minus(n+1)], [L,0],'-.k');
  
    
end
%t1 = t_minus(n)+
%plot()
plot(t_plus(n)+tau+s/v_max,L,'ok')
text(t_plus(n)-13,L*1.05,'$t_n^++\tau+s/\bar{v}$')
plot(t_minus(n+1)+L/v_max,L,'ok')
text(t_minus(n+1)+L/v_max,L*1.05,'$t_{n+1}^-+L/\bar{v}$')

for plat_i = 1:3
    n=plat_i*plat_length;
    text(t_plus(n)-18,L*0.5,['Platoon ',num2str(plat_i)],'FontWeight','bold');
    
end

folder_fig = '../Paper/Figure/';
saveas(gcf,[folder_fig,['illustr_platoon.eps']],'eps2c');
 

%plot inital states

