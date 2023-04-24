  
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


PRESENTATION = 1;
parameters;
N=50;
entry_saturation_rate = .8;
exit_saturation_rate =1;
L=800;
shift =20;
generate_boundary;


Illustration_Newell;
convert_trajectory_format;

figure_num =1;
w_fig =500;
h_fig = 300;
FontSize = 14;
Draw_Colorbar=1;
plot_frame
plot_trajectories_colored_speed;

figure_num =3;
draw_FD;

Optimization;
convert_trajectory_format;
figure_num =2;
w_fig =500;
h_fig = 300;
plot_frame
plot_trajectories_colored_speed;



figure_num =4;
draw_FD;

