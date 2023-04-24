if ~exist('n_start')
    n_start =1;
end
if ~exist('n_end')
    n_end =N;
end
if ~exist('line_color')
    line_color ='b';
end
if ~exist('delta_t ')
    delta_t = 1;
end
if ~exist('is_cross')
    is_cross = 0;
end

T_start =0;
T_end = T_max;


for n= n_start:n_end
    for k = 1:length(ts_all{n})-1
        t1 = ts_all{n}(k);
        t2 = min(T_max,ts_all{n}(k+1));
        dt = t2-t1;
        num_points = max(2,floor( dt/delta_t));
        ts = linspace(t1, t2,num_points);
        dts = ts - t1;
        vs = vs_all{n}(k)+as_all{n}(k)*dts;
        ps = ps_all{n}(k)+ vs_all{n}(k)*dts+0.5*as_all{n}(k)*dts.^2;
        for i = 1:length(ts)-1
            plot(traj_Ax,[ts(i),ts(i+1)], [ps(i),ps(i+1)],'Color',line_color);
        end
        if is_cross
            plot(traj_Ax, [t1,t2],[ps_all{n}(k),ps_all{n}(k+1)],[line_color,'+'])
        end
    end
    pause(0.0001)
end
