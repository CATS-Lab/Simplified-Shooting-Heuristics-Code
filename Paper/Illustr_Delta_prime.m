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

parameters_illustr_Delta_prime;
generate_boundary_illustr_Delta_prime;

a_max = 6;
a_min = -6;

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
plot_frame;
is_cross = 0;
extent_portion =0;
traj_colors = {'b'};
is_shadow =0;
plot_trajectories_stream;
%set(gca,'position',[0.15,0.2,0.65,0.65]);

is_shadow =1;
n=1;
plot_trajectory_n;
delta_n5 = s/v_max;
plot(ts_all{n}(5)+tau+[0, delta_n5],[ps_all{n}(5)-s,L],':k');


n=2;
    

text(ts_all{n}(5), ps_all{n}(5)-5,'$x_n(t)$');
text(t_plus(n-1)+1, L-5,'$x^\texttt{s}_{n-1}(t)$');
text(t_plus(n-1)-1.7, L-5,'$x_{n-1}(t)$');
%text(ts_all{n-1}(5)-0.2, ps_all{n-1}(5)-5,'$x_{n-1}(t)$');
scalar = 1;
plot(t_minus(n)+[L/v_max,0]*scalar,[L,0]*scalar,'--b');
t1 = t_minus(n)+L/v_max;
t2 = t_plus(n-1)+s/v_max+tau;
plot(t1,L,'ob');
plot(t2,L,'ob');
plot([t1,t1],[L,L*1.1],'--b');
plot([t2,t2],[L,L*1.1],'--b');
plot([t1,t2],[L,L]*1.05,'--b');
text((t1+t2)/2-.5,L*1.1,'$\Delta_{n(n-1)}$');




folder_fig = '../Paper/Figure/';
saveas(gcf,[folder_fig,['illustr_Delta_prime.eps']],'eps2c');
 

%plot inital states

