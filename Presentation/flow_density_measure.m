if ~exist('plot_check')
    plot_check =1;
end

if ~exist('xl_ref')
    xl_ref = 100;
    yl_ref = 900;
end

if ~exist('min_measure_num')
    min_measure_num =1;
end
if ~exist('is_LVP')
    is_LVP =0;
end
if ~exist('w_measure_box')
    w_measure_box = 2; % seconds
    h_measure_box = 200; % meters
end

xu_ref = xl_ref-h_measure_box*tau/s;
yu_ref = yl_ref+h_measure_box;

if plot_check 
    plot([xl_ref,xu_ref],[yl_ref,yu_ref],'--r','linewidth',2);
     %   plot([xl_ref-50,xl_ref+50],[yl_ref+50*s/tau,yl_ref-50*s/tau],'-r','linewidth',1);
    plot([xl_ref,xl_ref+w_measure_box],[yl_ref,yl_ref],'--b');
end

p_ref = polyfit([xl_ref,xu_ref],[yl_ref,yu_ref],1);

delta_t = 1;
space_vec = [];
headway_vec = []; 
for n=2:N
    for k = 1:length(ts_all{n})-1
        A = 0.5*as_all{n}(k);
        B = vs_all{n}(k) -p_ref(1);
        C =  ps_all{n}(k)-p_ref(2)-p_ref(1)*ts_all{n}(k);
        if abs(B^2<4*A*C)
            continue;            
        end
        if abs(A)<err_tol
            t_inter1 = ts_all{n}(k)-C/B;
            t_inter2 = ts_all{n}(k)-C/B;
        else
            t_inter1 = ts_all{n}(k)+ (-B+sqrt(B^2-4*A*C))/(2*A);
            t_inter2 = ts_all{n}(k)+(-B-sqrt(B^2-4*A*C))/(2*A);
        end
        t_inter =-inf;

        if t_inter1 >=ts_all{n}(k) && t_inter1 <=ts_all{n}(k+1)
            t_inter = t_inter1;
        elseif t_inter2 >=ts_all{n}(k)  && t_inter2 <=ts_all{n}(k+1)
            t_inter = t_inter2;
        end
        if t_inter>0

            if t_inter <xu_ref || t_inter >xl_ref
                t_inter = -inf;
            end
        end


        if t_inter<0
            continue;
        else
            break;
        end        
    end
    if t_inter<0
        continue;
    end
    if plot_check 
        plot([ts_all{n}(k), ts_all{n}(k+1)],[ps_all{n}(k), ps_all{n}(k+1)],'k+')
    end
    t_cur= t_inter;
    ss_temp = [];
    hs_temp =[];
    j = k;
    while 1;
        if(t_cur> ts_all{n}(j+1))
            j=j+1;
            if j >length(ts_all{n})-1
                break;
            else
                continue;
            end
        end
        if (t_cur>t_inter+w_measure_box) 
            break;
        end
        dt = t_cur - ts_all{n}(j);
        p_cur = ps_all{n}(j)+vs_all{n}(j)*dt + 0.5* as_all{n}(j)*dt^2;
        if plot_check && t_cur>t_inter
            plot([t_cur,t_cur-delta_t],[p_cur,p_old],'-g','LineWidth',2)
        end
        % find the space ref
        if (t_cur>ts_all{n-1}(end))
            break;
        end
        for m =1: length(ts_all{n-1})-1
            if ts_all{n-1}(m+1)>=t_cur
                break;
            end
        end
        dt = t_cur - ts_all{n-1}(m);
        p_prev = ps_all{n-1}(m)+vs_all{n-1}(m)*dt + 0.5* as_all{n-1}(m)*dt^2;
        if ~is_LVP
            if p_prev > L
               break; 
            end
        end

        ss_temp =[ss_temp,p_prev-p_cur];
        if plot_check 
            plot([t_cur,t_cur],[p_cur,p_prev],'-y');
        end


        %find the time_ref
        if (ps_all{n}(end)<p_cur)
            break;
        end
        for m =length(ps_all{n-1})-1:-1:1
            if ps_all{n-1}(m)<=p_cur
                break;
            end
        end
        if plot_check 
            %plot([ts_all{n-1}(m), ts_all{n-1}(m+1)],[ps_all{n-1}(m), ps_all{n-1}(m+1)],'r+')
        end

        l_res = p_cur-ps_all{n-1}(m) ;
        if abs(as_all{n-1}(m))<err_tol
            if abs(vs_all{n-1}(m))<err_tol
                t_prev = ts_all{n-1}(m+1);
            else
                t_prev = ts_all{n-1}(m)+l_res/vs_all{n-1}(m);
            end
        else
            dt = (-vs_all{n-1}(m)+sqrt(vs_all{n-1}(m)^2+2*as_all{n-1}(m)*l_res))...
                /as_all{n-1}(m);
            t_prev = ts_all{n-1}(m)+dt;
        end
        hs_temp = [hs_temp, t_cur-t_prev];
        if plot_check 
            plot([t_prev,t_cur],[p_cur,p_cur],'-g');
        end
        t_cur = t_cur+delta_t;
        p_old = p_cur;
    end 
    if min(length(ss_temp),length(hs_temp))>0
        space_vec = [space_vec,mean(ss_temp)];
        headway_vec = [headway_vec,mean(hs_temp)];
    end
end
if length(space_vec)>= min_measure_num;
    K = 1/mean(space_vec);
    O = 1/mean(headway_vec);
else
    K=-inf;
    O=-inf;
end

