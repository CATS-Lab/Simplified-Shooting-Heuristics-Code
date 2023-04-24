for plat_i = 1:plat_size
    platoon = platoons{plat_i};
    evaluate_platoon;
    a_platoon(plat_i,:)=[0,-phi/(1-lambda),0,phi/lambda,0];
end

for plat_i = 1:plat_size
    for n = platoons{plat_i}
        a_minus = -a_platoon(plat_i,2);
        v_seg(n,3) = v_max - a_minus*delta(n,2);
        v_seg(n,4)= v_seg(n,3);
        for seg = 1:4
            x_seg(n,seg+1) =  x_seg(n,seg)+ v_seg(n,seg)*delta(n,seg)+0.5*a_platoon(plat_i,seg)*delta(n,seg)^2;
        end
    end
end