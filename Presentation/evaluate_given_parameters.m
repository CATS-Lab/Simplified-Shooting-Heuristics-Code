if ~exist('INITIALIZATION')
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
    N=50;
    entry_saturation_rate = .75;
    exit_saturation_rate =1;
    L=500;
    shift =35;
    generate_boundary;
else
    if ~exist ('IS_PLOT')
        IS_PLOT=0;
    end
end




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
    plot_frame;

    extent_portion=0.05;
    plot_trajectories_stream;
end
