function [ts_cur,as_cur,vs_cur,ps_cur,Feasibility]= forward_shooting(t_cur,v_cur,p_cur,...
            ts_prev,as_prev,vs_prev,ps_prev,a_comfort,a_comfort_dec,v_max)
        Feasibility = 1;
        ts_cur = t_cur;
        vs_cur = v_cur;
        ps_cur = p_cur;
        as_cur = 0;
        k = 1;

        is_merging =0;
        while 1 %free forward shooting
            if vs_cur(k) < v_max 
                a_next = a_comfort;
                p_next = ps_cur(k) + (v_max^2 - vs_cur(k)^2)/(2*a_next);
                v_next = v_max;
                t_next = ts_cur(k) + (v_next - vs_cur(k))/a_next;
            else
                a_next = 0;
                v_next = v_max;
                p_next = inf;
                t_next = inf;
            end

            %check whether the free shooting is blocked
            if length(ts_prev)>=1
                p_now = ps_cur(k);
                v_now = vs_cur(k);
                t_now = ts_cur(k);
                is_shadow = 0;
                for h = 2: length(ts_prev)
                    if ts_prev(h) > t_now
                        is_shadow =1; 
                        break;
                    end
                end
                if is_shadow % if vehicle n-1 shadows vehicle n's current segment, then  check possibility for getting tagent to the shadow segment
                   is_tangent = 0; %not tagent
                   for i = h: length(ts_prev)
                        ts_window = ts_prev(i-1:i);
                        p_shadow = ps_prev(i-1) ;
                        v_shadow = vs_prev(i-1);
                        a_shadow = as_prev(i-1);
                        [t_next_max, t_tangent] = find_max_feasible_time(p_now,v_now,t_now,a_next,p_shadow,v_shadow,ts_window,a_shadow,a_comfort_dec);
                        if t_next_max == -inf
                             Feasibility = 0;
                             return;
                        end
                        if t_tangent > ts_window(2)  || t_tangent < max(ts_window(1),t_now)
                           t_next_max=inf;
                           t_tangent=inf;  
                        end
                        if t_tangent <= ts_window(2)  && t_tangent >= max(ts_window(1),t_now)
                            break;
                        end
                   end
                   if t_next_max <= t_next && t_next_max < inf
                       is_merging = 1;
                       t_next = t_next_max;
                       p_next = p_now + v_now*(t_next-t_now) + 0.5 * a_next*(t_next-t_now)^2;
                       v_next = v_now +  a_next*(t_next-t_now);
                   end
                end
            end % if ni>1

            if t_next > ts_cur(k) 
                ps_cur(k+1) = p_next;
                vs_cur(k+1) = v_next;
                ts_cur(k+1) = t_next;
                as_cur(k) = a_next;
                
                k = k+1;
            end

            if isinf(t_next) || is_merging
                break;
            end
        end % free  forward shooting  

        if is_merging % if it is the time to merge to the previous shadow trajectory.
            if t_tangent > ts_cur(k) 
                as_cur(k) = a_comfort_dec;
                td_prev = t_tangent - ts_prev(i-1);
                ps_cur(k+1) = ps_prev(i-1) + vs_prev(i-1) *td_prev + 0.5*as_prev(i-1)* td_prev^2;
                vs_cur(k+1) = vs_prev(i-1) + as_prev(i-1)* td_prev;
                ts_cur(k+1) = t_tangent;
                k=k+1;
            end
            for h = i : length(ts_prev);
                as_cur(k) = as_prev(h-1);
                ps_cur(k+1) = ps_prev(h);
                vs_cur(k+1) = vs_prev(h);
                ts_cur(k+1) = ts_prev(h);
                k=k+1;
            end
        end        
        as_cur(k)=0;        