
n_start =1;
delta_t = 1;
ime_scale = 10;

T_start =0;
T_end = T_max;

for t_now = T_start+delta_t: delta_t:T_end
    for n= n_start:N
        if t_minus(n)>=t_now+delta_t 
            break;
        end
        for k = 1: length(ts_all{n})-1
            if ts_all{n}(k+1)<=t_now-delta_t
                continue;
            end
            dt = t_now-ts_all{n}(k);
            location = ps_all{n}(k)+ vs_all{n}(k)*dt+0.5*as_all{n}(k)*dt^2;
            old_location = ps_all{n}(k)+ vs_all{n}(k)*(dt-delta_t)+0.5*as_all{n}(k)*(dt-delta_t)^2;
                
            v_temp = vs_all{n}(k)+as_all{n}(k)*dt;
            [temp, j_v] = min(abs(vs_color-v_temp));
            color_temp = cm(j_v,:);
            plot(traj_Ax,[t_now-delta_t,t_now], [old_location,location],'Color',color_temp);

            break;
        end
    end
    pause(0.001);
  
end