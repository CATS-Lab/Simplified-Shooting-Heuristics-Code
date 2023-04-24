 for seg = 1:5
    if seg == 1
        t_start = t_minus(n);
        t_end = t_minus(n)+delta(n,1);
    elseif seg == 5
        t_start = t_minus(n) +sum(delta(n,:));
        t_end = t_plus(n)+extent_portion*(t_plus(n)-t_minus(n));


    else
        t_start = t_minus(n) +sum(delta(n,1:seg-1));
        t_end = t_minus(n)+sum(delta(n,1:seg));
    end
    ts = linspace(t_start,t_end,max(floor((t_end-t_start)/interval),2));
    dts = ts-t_start;
    xs = x_seg(n,seg)+v_seg(n,seg)*dts + 0.5*a_platoon(plat_i,seg)*dts.^2;
    plot(ts,xs,traj_colors{mod(plat_i,color_size)+1});
    if is_shadow 
        plot(ts+tau,xs-s,':k');
    end
    if is_cross
        plot(ts(1),xs(1),'k+');
    end
    if seg ==5
        %text(t_end,xs(end)+5,num2str(n));
    end
end