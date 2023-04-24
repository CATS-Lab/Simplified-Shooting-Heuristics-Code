function [ts_reverse,as_reverse,vs_reverse,ps_reverse,i_merge,Feasibility]= backward_shooting(ts_reverse,as_reverse,vs_reverse,ps_reverse,...
            ts_cur,as_cur,vs_cur,ps_cur,a_reverse_comfort,a_reverse_comfort_dec)
            Feasibility = 1;
            i_merge = -1; 
            is_reverse_merging =0;
            while 1 %free backward shooting
                h=length(ps_reverse);
                p_reverse_now = ps_reverse(h);
                v_reverse_now = vs_reverse(h);
                t_reverse_now = ts_reverse(h);
                %free backward acceleration
                if vs_reverse(h) > 0 % if not stopped
                    a_reverse_next = a_reverse_comfort;
                    p_reverse_next = ps_reverse(h)  - vs_reverse(h)^2/(2*a_reverse_comfort);
                    v_reverse_next = 0;
                    t_reverse_next = ts_reverse(h) - vs_reverse(h)/a_reverse_next;                      
                else % if stopped
                    a_reverse_next = 0;
                    p_reverse_next = ps_reverse(h) ;
                    v_reverse_next = 0;
                    t_reverse_next = -inf;
                end

                for i = length(ts_cur):-1:2
                    ts_reverse_window = ts_cur(i-1:i);
                    p_reverse_shadow = ps_cur(i-1);
                    if p_reverse_shadow >= p_reverse_now
                        continue
                    end
                    v_reverse_shadow = vs_cur(i-1);
                    a_reverse_shadow = as_cur(i-1);
                    [t_reverse_max, t_reverse_tangent] = find_max_feasible_time(p_reverse_now,v_reverse_now,t_reverse_now,...
                        a_reverse_next,p_reverse_shadow,v_reverse_shadow,ts_reverse_window,a_reverse_shadow,a_reverse_comfort_dec,-1);
                    if t_reverse_max ==inf 
                         Feasibility = 0;
                         return;
                    end
                    if t_reverse_tangent > min(ts_reverse_window(2),t_reverse_now)  || t_reverse_tangent < ts_reverse_window(1)
                       t_reverse_max=-inf;
                       t_reverse_tangent=-inf;  
                    end
                    if t_reverse_tangent <= min(ts_reverse_window(2),t_reverse_now)  && t_reverse_tangent >= ts_reverse_window(1)
                        break;
                    end
                end

                if t_reverse_max ==-inf || t_reverse_max > t_reverse_now
                     Feasibility = 0;
                     return;
                end

                if t_reverse_max >= t_reverse_next 
                   is_reverse_merging = 1;
                   t_reverse_next  = t_reverse_max;
                   dt = t_reverse_next -  t_reverse_now ;
                   v_reverse_next = v_reverse_now + a_reverse_next*dt;
                   p_reverse_next = p_reverse_now + v_reverse_now*dt + 0.5 *a_reverse_next*dt^2;
                end

                if t_reverse_max < t_reverse_now
                    ts_reverse = [ts_reverse,t_reverse_next];
                    as_reverse = [as_reverse,a_reverse_next];
                    vs_reverse = [vs_reverse,v_reverse_next];
                    ps_reverse = [ps_reverse,p_reverse_next];
                    h=length(ps_reverse);
                end

                if  is_reverse_merging == 1;
                    dt = t_reverse_tangent-ts_cur(i-1);
                    v_reverse_next = vs_cur(i-1)+ as_cur(i-1)*dt;
                    p_reverse_next = ps_cur(i-1) + vs_cur(i-1)*dt + 0.5*as_cur(i-1)*dt^2;
                    t_reverse_next = t_reverse_tangent;
                    a_reverse_next = a_reverse_comfort_dec;
                    ts_reverse = [ts_reverse,t_reverse_next];
                    as_reverse = [as_reverse,a_reverse_next];
                    vs_reverse = [vs_reverse,v_reverse_next];
                    ps_reverse = [ps_reverse,p_reverse_next];
                    h=length(ps_reverse);
                    i_merge = i;
                    break;
                end
            end %free backward shooting
            