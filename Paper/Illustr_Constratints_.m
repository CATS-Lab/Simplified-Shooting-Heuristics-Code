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

parameters_illustration;
generate_boundary_illustration;

a_max = 3;
a_min = -3;

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
%plot_frame
plot_frame_with_hwy;
is_cross = 0;
extent_portion =0.05;
traj_colors = {'b'};
is_shadow =1;
plot_trajectories_stream;
%set(gca,'position',[0.15,0.2,0.65,0.65]);

is_shadow =1;
n=3;
plot_trajectory_n;
%t1 = t_minus(n)+
%plot()


n=4;
    
t_inc = .5;
t_end = t_minus(n) + t_inc;
l_end = v_max*t_inc;
arrow([t_minus(n),0],[t_end,l_end],'FaceColor','k','EdgeColor','k','Length',5,'TipAngle',20);
text( t_end+.5, l_end+2,'$(t^-_n,\bar{v})$');

t_end = t_plus(n) + t_inc;
l_end = L+v_max*t_inc;
arrow([t_plus(n),L],[t_end,l_end],'FaceColor','k','EdgeColor','k','Length',5,'TipAngle',20);
text( t_end+.5, l_end+2,'$(t^+_n,\bar{v})$');
text(ts_all{n}(5)-.3, ps_all{n}(5)-10,'$x_n(t)$');
text(ts_all{n-1}(5)-0.2, ps_all{n-1}(5)-5,'$x_{n-1}(t)$');




t_temp = ts_all{n-1}(4);
x_temp = ps_all{n-1}(4);
plot([t_temp,t_temp+tau],[x_temp,x_temp],'k-');
plot([t_temp+tau,t_temp+tau],[x_temp,x_temp-s],'k-');
text(t_temp+.5, x_temp+3,'$\tau$');
text(t_temp+1.5, x_temp-4,'$s$');

folder_fig = '../Paper/Figure/';
%saveas(gcf,[folder_fig,['illur_constraints.eps']],'eps2c');
 

%plot inital states

