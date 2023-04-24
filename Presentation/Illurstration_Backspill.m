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

parameters;
entry_saturation_rate = .1;
exit_saturation_rate = entry_saturation_rate;%.00173
shift = 50; %second;
alpha = 0;
beta = 0;
L =2000;
N = 200;
generate_boundary;
lambda = 0.5;
phis = [0.24,1];
for i_phi = 1:length(phis)   
    phi = phis(i_phi);

    evaluate_given_parameters;
    extension =0;
    convert_trajectory_format;

    figure_num =i_phi;
    FontSize = 14;
    Draw_Colorbar=1;
    w_fig =500;
    h_fig = 300;
    Is_Ticks =1;
    plot_frame
    %is_cross=1;
    delta_t=5;
    plot_trajectories_colored_speed;
    plot([0,T_max],[min(delta(:,1)),min(delta(:,1))]*v_max,'y--'...
        ,'linewidth',2);
    set(gca,'position',[0.18,0.2,0.65,0.65]);
    title(['$\phi$=',num2str(phi),'; N: ', num2str(N),'; delay: ', num2str(shift)]);
end



    