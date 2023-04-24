function d_min = get_dist_min(cs_shadow,t_windows, c_ref, tcur_win)
     d_min = inf;
     for j = 1: size(cs_shadow,1)
        c1 = cs_shadow(j,1) - c_ref(1);
        c2 = cs_shadow(j,2)- c_ref(2);
        c3 = cs_shadow(j,3) - c_ref(3);    
        
        tbs = t_windows(j,:);
        tbs(1) = max(tcur_win(1),tbs(1));
        tbs(2) = min(tcur_win(2),tbs(2));
        if tbs(2)<tbs(1)
            continue
        end
        
        
        if c1>0 && c1*tbs(1)< -c2/2 && -c2/2 < c1*tbs(2)
            t_m = -c2/(2*c1); 
            d_can = c1*t_m^2+c2*t_m+c3;
        else
            d_can = min(c1*tbs.^2+c2*tbs+c3);
        end
        
        d_min = min(d_min,d_can);
     end
        
end