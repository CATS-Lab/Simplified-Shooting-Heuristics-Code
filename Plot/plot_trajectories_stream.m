interval = 0.01;
if ~exist('traj_colors')
    traj_colors ={'k','b','r','g','c'};
end
color_size = length(traj_colors);

if ~exist('is_cross')
    is_cross =0;
end

if ~exist('is_shadow')
    is_shadow = 0;
end

if ~exist('extent_portion')
    extent_portion = 0;
end

for plat_i = 1:length(platoons)    
    for n = platoons{plat_i}
       plot_trajectory_n;
    end
end