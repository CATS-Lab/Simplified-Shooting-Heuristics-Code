function phi = fun_inv_delta(c,Delta,v_max)
    phi = v_max./(2*(c-Delta));
    if 2*Delta*phi<v_max
        phi = 2*v_max*Delta/c^2;
    end