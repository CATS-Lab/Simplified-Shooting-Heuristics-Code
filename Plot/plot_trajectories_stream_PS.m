interval = 0.1;


for plat_i = 1:length(platoons)
    for n = platoons{plat_i}
        for seg = 1:5
            if seg == 1
                t_start = t_minus(n);
                t_end = t_minus(n)+delta(n,1);
            elseif seg == 5
                t_start = t_minus(n) +sum(delta(n,:));
                t_end = t_plus(n);
            else
                t_start = t_minus(n) +sum(delta(n,1:seg-1));
                t_end = t_minus(n)+sum(delta(n,1:seg));
            end
            ts = linspace(t_start,t_end,max(floor((t_end-t_start)/interval),2));
            dts = ts-t_start;
            xs = x_seg(n,seg)+v_seg(n,seg)*dts + 0.5*a_platoon(plat_i,seg)*dts.^2;
            if n == 7
                plot(ts,xs,'Color','b');
            else
                plot(ts,xs,'Color',[0.8,0.8,0.8]);
            end
            
           
           
        end
    end
end

