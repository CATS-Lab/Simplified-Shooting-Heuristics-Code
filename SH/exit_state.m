function [t_exit,a_exit,v_exit,k_exit] = exit_state(ts_cur,as_cur,vs_cur,ps_cur,L,err_tol)

for k = 1: length(ps_cur)
    if ps_cur(k+1)>L           
        k_exit = k;
        dp = L-ps_cur(k);
        v_cur = vs_cur(k);
        a_exit = as_cur(k);
        if abs(a_exit) >= err_tol
            dt = (-v_cur+sqrt(v_cur^2 + 2*a_exit*dp))/a_exit;
        else
            dt = dp/v_cur;                
        end
        t_exit = ts_cur(k) + dt;
        v_exit = v_cur +a_exit*dt;
        break;
    end
end