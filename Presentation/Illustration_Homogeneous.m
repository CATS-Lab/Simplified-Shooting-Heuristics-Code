clear;close all;
path_strs = strsplit(mfilename('fullpath'),'\');
cur_path = []; 
for folder = path_strs(1:end-1)
    cur_path = [cur_path folder{1} '\'];
end
cd(cur_path);
cd('../');
INITIALIZATION = 1;
IS_PLOT=1;

include;
PRESENTATION = 1;
parameters;
N=5;
entry_saturation_rate = .5;
exit_saturation_rate =.5;
L=100;
shift = 5;
alpha = 0;
beta =0;
generate_boundary;



phi = 2;
lambda = 0.5;
v_seg = v_max*ones(N,5);
x_seg = zeros(N,5);
delta = zeros (N,4);
a_platoon = zeros(plat_size,5);
evaluate_stream;

if IS_PLOT
    Is_Ticks =0;
    %plot_frame_with_hwy;
    w_fig =900;
    h_fig = 400;
    plot_frame
    is_shadow =1;
    extent_portion=0.05;
    plot_trajectories_stream;
end
