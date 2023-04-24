feasibility = 1;
for n = platoon
    delta1_tilde = t_plus(n)-t_minus(n)-fun_sigma(phi,v_max,Delta(n));
    delta1_hat = delta1_tilde;
    if n == platoon(1)
        delta(n,1) = delta1_tilde;
    else
        delta1_hat = sum(delta(n-1,:))+ t_minus(n-1)+ tau - t_minus(n)...
            - fun_sigma(phi,v_max,Delta_prev(n));
        delta(n,1) =  min(delta1_tilde,delta1_hat);
    end
    
    if delta(n,1) <0
        feasibility =0;
    end

    if 2*Delta(n)*phi <= v_max
        delta(n,3) = 0;
        if phi ==0
            delta(n,2) = 0;
            delta(n,4) = 0;
        else
            delta(n,2) = sqrt(2*v_max*Delta(n)/phi)*(1-lambda);
            delta(n,4) = sqrt(2*v_max*Delta(n)/phi)*lambda;
        end
    else
        delta(n,2) = v_max*(1-lambda)/phi;
        delta(n,3) = Delta(n)-v_max/(2*phi);
        delta(n,4) = v_max*lambda/phi;
    end
end