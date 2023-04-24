clear;close all;
path_strs = strsplit(mfilename('fullpath'),'\');
cur_path = []; 
for folder = path_strs(1:end-1)
    cur_path = [cur_path folder{1} '\'];
end
cd(cur_path);
cd('../');
include;
PRESENTATION = 1;
parameters;
N=50;
entry_saturation_rate = .6;
exit_saturation_rate =1;
L=300;
shift =30;
generate_boundary;


Is_Ticks =0;
%plot_frame_with_hwy;

plot_frame
phi = 1;
lambda = 0.5;
v_seg = v_max*ones(N,5);
x_seg = zeros(N,5);
delta = zeros (N,4);
a_platoon = zeros(plat_size,5);
evaluate_stream;
plot_trajectories_stream;
