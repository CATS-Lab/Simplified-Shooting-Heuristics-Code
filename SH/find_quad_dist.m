function [dis,t_zero] = find_quad_dist(p_n,v_n,t_n,a_c_d,p_s,v_s,ts_window,a_s)
    c_ref =[0.5*a_c_d,v_n,p_n];
    t_s = ts_window(1) - t_n;
    c1 = 0.5*a_s;
    c2 = v_s - a_s*t_s;
    c3 = 0.5*a_s*t_s^2-v_s*t_s+p_s;
    cs_shadow = [c1,c2,c3];
    t_f = ts_window(2)-t_n;
    t_z = -v_n/a_c_d;
    tcur_win =[0,min(t_f, t_z)];
    dis = get_dist_min(cs_shadow,ts_window-t_n, c_ref, tcur_win);
    
    
    if t_z<t_f
       
        p_zero = p_n - v_n^2/(2*a_c_d);
        
        c_ref1 =[0,0,p_zero];
        tcur_win1 =[t_z,t_f];
        dis1 = get_dist_min(cs_shadow,ts_window-t_n, c_ref1, tcur_win1);
        dis = min(dis,dis1);
    end
    
    t_zero = t_n + t_z;
    
end
