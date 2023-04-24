global err_tol 
err_tol=0.0000001;

% p_now = p_reverse_now;
% v_now =v_reverse_now;
% t_now = t_reverse_now;
% a_next = a_reverse_next;
% p_shadow = p_reverse_shadow;
% v_shadow=v_reverse_shadow;

is_reversex =1;
if is_reversex ==0
    [t_r,t_tangent,t_nr] = find_max_feasible_time(p_now,v_now,t_now,a_next,p_shadow,v_shadow,ts_window,a_shadow,a_comfort_dec);

    figure(14); clf;hold all;
    t_low =  min(ts_window(1),t_now)-2;
    if t_tangent<inf
        t_high = max(ts_window(2), t_tangent)+2;
    else
        t_high = ts_window(2)+2;
    end

    Plot_Segment(p_shadow, v_shadow,a_shadow,[t_low,t_high+5],5000,0,ts_window(1),0);
    if t_r <inf
        Plot_Segment(p_now , v_now,a_next,[min(t_r,t_now),max(t_r,t_now)],5000,0,t_now,0);
    else
        Plot_Segment(p_now , v_now,a_next,[t_low,t_high],5000,0,t_now,0);
    end

    plot(t_now,p_now,'bo')
    p_shadow2 = p_shadow + v_shadow*(ts_window(2)-ts_window(1)) + 0.5*a_shadow*(ts_window(2)-ts_window(1))^2;
    plot([ts_window(1),ts_window(1)],[-max(p_shadow2,p_shadow),max(p_shadow2,p_shadow)],'k:')
    plot([ts_window(2),ts_window(2)],[-max(p_shadow2,p_shadow),max(p_shadow2,p_shadow)],'k:')

    if t_r < inf 
        v_r = v_now + a_next *(t_r-t_now);
        p_r = p_now + v_now*(t_r-t_now)+0.5*a_next*(t_r-t_now)^2;
        plot_segment(p_r , v_r, a_dec,[min(t_tangent,t_r)-2,max(t_r,t_tangent)+2],5000,0,t_r,0,0,'--k');
        p_inter = p_r + v_r*(t_tangent-t_r)+0.5*a_comfort_dec*(t_tangent-t_r)^2;
        plot(t_tangent,p_inter,'r*')
        plot(t_r,p_r,'b*')
    end

    if t_nr < inf
        v_nr = v_now + a_next *(t_nr-t_now);
        p_nr = p_now + v_now*(t_nr-t_now)+0.5*a_next*(t_nr-t_now)^2;
        Plot_Segment(p_nr, v_nr, a_dec,[t_nr-2,ts_window(2)+2],5000,0,t_nr,0);

    end
else
    [t_reverse_max, t_reverse_tangent] = find_max_feasible_time(p_reverse_now,v_reverse_now,t_reverse_now,...
                            a_reverse_next,p_reverse_shadow,v_reverse_shadow,ts_reverse_window,a_reverse_shadow,a_reverse_comfort_dec,-1);
    figure(14); 
    clf;
    hold all;
    t_reverse_low =  min(ts_reverse_window(1),t_reverse_now);
    if t_reverse_tangent<inf
        t_high = max(ts_reverse_window(2), t_reverse_tangent);
    else
        t_high = ts_reverse_window(2);
    end

    plot_segment(p_reverse_shadow, v_reverse_shadow,a_reverse_shadow,[ts_reverse_window(1),ts_reverse_window(2)],5000,0,ts_reverse_window(1),0);
    plot_segment(p_reverse_now , v_reverse_now,a_reverse_next,[t_reverse_next,t_reverse_now],5000,0,t_reverse_now,0);
    
     if t_reverse_max < inf 
        v_reverse_r = v_reverse_now + a_reverse_next *(t_reverse_max-t_reverse_now);
        p_reverse_r = p_reverse_now + v_reverse_now*(t_reverse_max-t_reverse_now)+0.5*a_reverse_next*(t_reverse_max-t_reverse_now)^2;
        plot_segment(p_reverse_r , v_reverse_r, a_reverse_comfort_dec,[t_reverse_tangent,t_reverse_max],5000,0,t_reverse_max,0);
        p_reverse_inter = p_reverse_r + v_reverse_r*(t_reverse_tangent-t_reverse_max)+0.5*a_reverse_comfort_dec*(t_reverse_tangent-t_reverse_max)^2;
        plot(t_reverse_tangent,p_reverse_inter,'r*')
        plot(t_reverse_max,p_reverse_r,'b*')
     end
     p_reverse_shadow2 = p_reverse_shadow + v_reverse_shadow*(ts_reverse_window(2)-ts_reverse_window(1)) + 0.5*a_reverse_shadow*(ts_reverse_window(2)-ts_reverse_window(1))^2;
     plot([ts_reverse_window(1),ts_reverse_window(1)],[-max(p_reverse_shadow2,p_reverse_shadow),max(p_reverse_shadow2,p_reverse_shadow)],'k:')
     plot([ts_reverse_window(2),ts_reverse_window(2)],[-max(p_reverse_shadow2,p_reverse_shadow),max(p_reverse_shadow2,p_reverse_shadow)],'k:')

end




