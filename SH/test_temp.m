global err_tol 
err_tol=0.0000001;
a_comfort = theta(1);%0.0779;%0.0799
a_comfort_dec = theta(2);%-3.4025
a_reverse_comfort = theta(3);%1.
a_reverse_comfort_dec = theta(4);
% p_now = p_reverse_now;
% v_now =v_reverse_now;
% t_now = t_reverse_now;
% a_next = a_reverse_next;
% p_shadow = p_reverse_shadow;
% v_shadow=v_reverse_shadow;
shooting_heuristic;
figure_num =2;
FontSize = 11;
Draw_Colorbar=1;
w_fig =500;
h_fig = 300;
Is_Ticks = 1;
Draw_Colorbar =0;
IS_SIGNAL =0;
plot_frame
is_cross = 0;
is_cross
extent_portion =0.00;
%traj_colors = {'b'};
traj_colors ={'k','b','r','g','c'};
for plat_i =1:plat_size
    n_start = platoons{plat_i}(1);
    n_end = platoons{plat_i}(end);
    is_shadow =0;
    is_cross =1;
    line_color = traj_colors{mod(plat_i,length(traj_colors))+1};
    plot_trajectories;
end



