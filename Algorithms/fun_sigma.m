function sigma = fun_sigma(phi,v_max,Delta)
    if phi==0
        sigma=0;
    else
        if 2*Delta*phi <= v_max
            sigma = sqrt(2*v_max*Delta/phi);
        else
            sigma = Delta+v_max/(2*phi);    
        end 
    end
end