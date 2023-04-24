function a_max = find_max_step( gk,theta_min_norm,theta_max_norm)
    a_max = inf;
    for i = 1:length(gk)
        if gk(i) == 0
            continue;
        end
        if -gk(i)>0;
            a_max_temp  =  theta_max_norm(i)/-gk(i);
        else
            a_max_temp =  theta_min_norm(i)/-gk(i);
        end
        a_max = min(a_max, a_max_temp );
    end