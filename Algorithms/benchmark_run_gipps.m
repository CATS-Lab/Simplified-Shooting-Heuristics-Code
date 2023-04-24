if ~exist('IS_DYN_PLOT')
    IS_DYN_PLOT = 0;
end


if ~exist('pause_time')
    pause_time =0.001;
end

if ~exist('is_LVP')
    is_LVP =0;
end
% if is_LVP
%     saturation_rate = 0.5;
% end

time_step = tau;
ps_tick = cell(N,1);
ts_tick = cell(N,1);
vs_tick = cell(N,1);
as_tick = cell(N,1);

%ts_exit = zeros(N,1);
%vs_exit = zeros (N,1);
% intelligent driver model parameters
a = a_max;
b= -a_min/2;
delta_t = tau;
s_0 = 1;



%% simulate all trajectories

if IS_DYN_PLOT
    %T_max = max (ts_minus+10*L/v_max);
   
    fig_x_range = [0,T_max];
    figure_number= 500;
    w_fig = 500;
    h_fig =300;
    x_corner = 10;
    y_corner = 200;
    plot_frame;
end

if is_LVP
    start_n = 2;
    

   if ~exist('ps_lead')
        T_e =50;
        [ps_tick{1},vs_tick{1},as_tick{1},ts_tick{1}] =fun_create_piecewise_trajectory(v_max,0,a_comfort_dec,70,0,5);
        ts_tick{1}(end)=inf;
    else
        ps_tick{1} = ps_lead;
        vs_tick{1} = vs_lead;
        as_tick{1} = as_lead;
        ts_tick{1} = ts_lead;
    end    
    if IS_DYN_PLOT
        n = 1;
        for k = 1:length(ps_tick{n})-1 
            Plot_Segment(ps_tick{n}(k), vs_tick{n}(k),as_tick{n}(k),ts_tick{n}(k:k+1),10,1,ts_tick{n}(k),0,0,'r');            
        end
        pause(0.001)
    end
    
else
    start_n = 1;
end


t_plus = [];
vs_exit = [];
as_exit = [];

dt = time_step;
for n =start_n:N
    n
    ts_tick{n}(1) = t_minus(n);
    vs_tick{n}(1) = v_max;
    ps_tick{n}(1) = 0;
    if IS_DYN_PLOT
        hs_cell =cell(round(3000/time_step),1);
    end
    
    k = 1;
    is_exit_recorded =0;
    
    
    is_blocked = 0;
    %k_crit = -1;
    while 1
        ts_tick{n}(k+1) = ts_tick{n}(k) + time_step;
        t_now =  ts_tick{n}(k) ;
       
        p_prev = inf;
        v_prev = v_max;
        v = vs_tick{n}(k);
%         if L-ps_tick{n}(k)<=(v_max^2)/(2*b)+v_max*dt
%             if k_crit<0
%                  k_crit = k;
%             end
%         end
        
        if L-ps_tick{n}(k)<=(v_max^2)/(2*b)+v_max*dt && L-ps_tick{n}(k)>=-err_tol
            if get_G_next(t_now,G,R,signal_phase) == t_now 
                v_next = min(v+a*dt,v_max);
                l_next = L-ps_tick{n}(k)-(v_next+v)/2*dt;
                if l_next>0
                    dt_temp = get_travel_time(l_next,v_next,v_max,a);
                    t_temp = ts_tick{n}(k)+dt + dt_temp;
                    if t_temp>= get_G_next(t_now+G,G,R,signal_phase)...
                            - R-err_tol % runs into the red light
                       p_prev = L+s;
                       v_prev = 0;
                    end
                end
            else % red light     
                p_prev = L+s;
                v_prev = 0;
            end
        end
        s_diff= p_prev-s - ps_tick{n}(k);
        dis_safe = s_diff+v_prev^2/(2*b);
        A= dt^2/(2*b);
        B= dt^2/2+v*dt/b;
        C = v*dt+v^2/(2*b)-dis_safe;
        D = B^2-4*A*C;
        if D<0
            D = 0;
        end  
        a_safe = (-B+sqrt(D))/(2*A) ;
        if v+a_safe*dt<0
            a_safe = -v^2/(2*dis_safe);
        end



        
        if n>1
            for h = 2: length(ts_tick{n-1})
                if ts_tick{n-1}(h) >= t_now
                    td = t_now - ts_tick{n-1}(h-1);
                    
                    if as_tick{n-1}(h-1)<0
                        td = min (td, vs_tick{n-1}(h-1)/-as_tick{n-1}(h-1));
                    end
                    
                    dp_prev = vs_tick{n-1}(h-1)*td + 0.5*as_tick{n-1}(h-1)*td^2;
                    
                    
                    p_prev_veh = ps_tick{n-1}(h-1) + dp_prev;
                    v_prev_veh = vs_tick{n-1}(h-1) + as_tick{n-1}(h-1)*td;
                    s_diff= p_prev_veh-s - ps_tick{n}(k);
                    dis_safe = s_diff+v_prev_veh^2/(2*b);
                    A= dt^2/(2*b);
                    B= dt^2/2+v*dt/b;
                    C = v*dt+v^2/(2*b)-dis_safe;
                    D = B^2-4*A*C;
                    if D<0
                        D = 0;
                    end  
                    a_safe1 = (-B+sqrt(D))/(2*A) ;
                    if a_safe>a_safe1
                        a_safe = a_safe1;
                    end
                    
                    
                    break
                end
            end
        end
        a_lb = min (a,(v_max-v)/dt);
        as_tick{n}(k) = min(a_lb,a_safe);
        vs_tick{n}(k+1) = max(vs_tick{n}(k) + as_tick{n}(k)*dt,0);
        %v_safe = -b*dt+sqrt(max(b^2*dt^2+v_prev^2+2*b*s_diff,0));
        %vs_tick{n}(k+1) = min([vs_tick{n}(k)+a*time_step,v_max,v_safe]);
       % vs_tick{n}(k+1) = max(vs_tick{n}(k+1),0);
         
        %as_tick{n}(k) = (vs_tick{n}(k+1)-vs_tick{n}(k))/time_step;
       if vs_tick{n}(k+1)==0 && vs_tick{n}(k)>0
            ps_tick{n}(k+1) = ps_tick{n}(k) + vs_tick{n}(k)^2/(-2*as_tick{n}(k));
       else
            ps_tick{n}(k+1) = ps_tick{n}(k) +(vs_tick{n}(k)+vs_tick{n}(k+1))/2*time_step;  
        end
        if IS_DYN_PLOT
            is_delete = 0;
            if length(hs_cell{k})>0
                pause(0.0001);
                delete(hs_cell{k});                                      
                hs_cell{k} = [];   
                is_delete =1;
            end
            hs_cell{k}=plot_segment(ps_tick{n}(k), vs_tick{n}(k),as_tick{n}(k),ts_tick{n}(k:k+1),10,0);
            if is_delete
                pause(0.0001);
            end
        end
%         
        
        if ps_tick{n}(k+1)>L && ~ is_exit_recorded
            t_plus = [t_plus,ts_tick{n}(k+1)];
            vs_exit = [vs_exit,vs_tick{n}(k+1)];
            as_exit = [as_exit,as_tick{n}(k)];
            is_exit_recorded=1;
        end
        if is_LVP
            if ts_tick{n}(k+1)>T_max
                break;
            end
        else
            if ps_tick{n}(k+1)>1.3*L            
                break;
            end
        end
        
        k = k+1;
    end
 
    as_tick{n}(k+1) =0;
    
    if  IS_DYN_PLOT & pause_time
        pause(pause_time);
    end
end

as_all = as_tick;
vs_all = vs_tick;
ps_all = ps_tick;
ts_all = ts_tick;
% 
% Evaluate_MOEs;
% T_B = T;
% R_B = R;
% E_B = E;
% 
% if IS_DYN_PLOT
% folder_fig = '../../Homogeneous Vehicle Paper/Figure/';
% saveas(gcf,[folder_fig,'bechmark_trajectories.eps'],'eps2c');
% end

