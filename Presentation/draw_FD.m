plot_check =0;
Os=[];
Ks=[];
err_tol =1e-7;

if ~exist('figure_num')
    figure_num=27;
end

hFig=figure(figure_num);
w_fig = 450;
h_fig =300;
x_corner =100;
y_corner =100;
FontSize = 14;
figure_initialization;
plot([0,1/(s+v_max*tau),1/s]*1000,[0,v_max/(s+v_max*tau),0]*3600,'-b','linewidth',2)
%plot([1/(s+v_max*tau)]*1000,[v_max/(s+v_max*tau)]*3600,'-b','linewidth',2)

xlabel('Density (vehs/km)')
ylabel('Flow (vehs/hr)')
legend('stationary')
legend('boxoff')
if plot_check
   plot_trajectories_in_frame;
end

w_measure_box = 5; % seconds
h_measure_box = 100; % meters
min_measure_num =1;
for xl_ref = [0:10:T_max];
    temp_Os =[];
    temp_Ks =[];
    
    L_max = L-100;
    
    for yl_ref = [0:100:L_max];
        flow_density_measure;
        if O>=0
            temp_Os =[temp_Os ,O];
            temp_Ks=[temp_Ks,K]; 
        else
            if length(temp_Os) 
                break;
            else
                continue;
            end
        end
        if plot_check
            figure(fig_num_temp)
            plot(K,O,'ro');
            pause(0.001);
            figure(4)
        end
    end
    Os=[Os,temp_Os];
    Ks=[Ks,temp_Ks];
    
    xl_ref
end

plot(Ks*1000,Os*3600,'ro');
set(gca,'position',[0.21,  0.2  0.75  0.75]);
leg = legend('stationary','measurements');
set(leg,'box','off')



