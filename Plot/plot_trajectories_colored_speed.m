
n_start =1;
if ~exist('delta_t ')
    delta_t = 1;
end
if ~exist('Is_Cross')
    Is_Cross = 0;
end

T_start =0;
T_end = T_max;


for n= n_start:N
    for k = 1:length(ts_all{n})-1
        t_next = min(T_max,ts_all{n}(k+1));
        dt = t_next-ts_all{n}(k);
        num_points = max(2,floor( dt/delta_t));
        ts = linspace(ts_all{n}(k), t_next,num_points);
        dts = ts - ts_all{n}(k);
        vs = vs_all{n}(k)+as_all{n}(k)*dts;
        ps = ps_all{n}(k)+ vs_all{n}(k)*dts+0.5*as_all{n}(k)*dts.^2;
        for i = 1:length(ts)-1
            v_temp = vs(i)/2+vs(i+1)/2;
            [temp, j_v] = min(abs(vs_color-v_temp));
            color_temp = cm(j_v,:);
            plot(traj_Ax,[ts(i),ts(i+1)], [ps(i),ps(i+1)],'Color',color_temp);
            
        end
        if Is_Cross
            plot(traj_Ax, ts_all{n}(k),ps_all{n}(k),'b+')
        end
    end
    pause(0.0001)
end
