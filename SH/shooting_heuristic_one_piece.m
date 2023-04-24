
%Control Parameters
if ~exist('REPORT_ERROR_AT_INFEASIBILITY')
    REPORT_ERROR_AT_INFEASIBILITY = 1;
end

if ~exist('IS_DYN_PLOT')
    IS_DYN_PLOT = 0;
end
if ~exist('IS_PLOT_HWY')
    IS_PLOT_HWY = 0;
end

if ~exist('plot_cross')
    plot_cross = 1;
end

if ~exist('plot_shadow')
    plot_shadow = 1;
end
if ~exist('save_animation')
    save_animation =0;
end

if save_animation
    ani_file_name = 'SH.gif';
end
%initialize control location

ps_all = cell(N,1);
ts_all = cell(N,1);
vs_all = cell(N,1);
as_all = cell(N,1);
ts_exit = [];
vs_exit = [];
as_exit = [];

%% construct all trajectories
if IS_DYN_PLOT 
    fig_x_range = [0,T_max];
    figure_number= 510;
    if save_animation
        w_fig = 900;
        h_fig =450;
    else
        w_fig = 500;
        h_fig =300;
    end
    x_corner = 50;
    y_corner = 50; 
    if IS_PLOT_HWY
        L0 = 0;
        L1 = L;
        plot_frame_with_hwy;
    else
        L0 = 0;
        L1 = L;
        plot_frame;
    end
    
    if save_animation
        set(gca,'XTick',[]);
        set(gca,'YTick',[]);
        xlabel('Time');
        ylabel('Space');
        drawnow;
        frame = getframe(figure_number);
        im = frame2im(frame);
        [imind,cm]=rgb2ind(im,256);
        imwrite(imind,cm,ani_file_name,'gif','Loopcount',1,'DelayTime',0);
    end
    
end

%Dividing the highway into sections for shift the end of that trajectory
% D1 = ACC_RELAX_FACTOR*v_max^2/(2*a_max);% min distance needed to accelerate from 0 to v_max
% D2 = DEC_RELAX_FACTOR*v_max^2/(-2*a_min); % min distance needed to decelerate from v_max to 0
% D3 = D1 + D2;

L_max = inf;
%feability to be returned
Feasibility = 1;
for plat_i = 1:plat_size
    a_comfort = a_platoon(plat_i,1);
    a_comfort_dec = a_platoon(plat_i,2);
	a_reverse_comfort = a_platoon(plat_i,3);
	a_reverse_comfort_dec = a_platoon(plat_i,4);
    for ni =1:length(platoons{plat_i})
        n = platoons{plat_i}(ni);
        ts_all{n}(1) = t_minus(n);
        vs_all{n}(1) = v_minus(n);
        ps_all{n}(1) = 0;
        if IS_DYN_PLOT
            hs_cell =cell(round(300),1);
        end
    %% forward shooting    
        k = 1;

        is_merging =0;
        while 1 %free forward shooting
            if vs_all{n}(k) < v_max 
                a_next = a_comfort;
                p_next = ps_all{n}(k) + (v_max^2 - vs_all{n}(k)^2)/(2*a_next);
                v_next = v_max;
                t_next = ts_all{n}(k) + (v_next - vs_all{n}(k))/a_next;
            else
                a_next = 0;
                v_next = v_max;
                p_next = L_max;
                t_next = ts_all{n}(k)+(L_max-ps_all{n}(k))/v_max;
            end

            %check whether the free shooting is blocked

            if ni>1
                p_now = ps_all{n}(k);
                v_now = vs_all{n}(k);
                t_now = ts_all{n}(k);
                is_shadow = 0;
                for h = 2: length(ts_all{n-1})
                    if ts_all{n-1}(h)+tau > t_now
                        is_shadow =1; 
                        break;
                    end
                end
                if is_shadow % if vehicle n-1 shadows vehicle n's current segment, then  check possibility for getting tagent to the shadow segment
                   is_tangent = 0; %not tagent
                   for i = h: length(ts_all{n-1})
                        ts_window = ts_all{n-1}(i-1:i)+tau;
                        p_shadow = ps_all{n-1}(i-1) -s;
                        v_shadow = vs_all{n-1}(i-1);
                        a_shadow = as_all{n-1}(i-1);
                        [t_next_max, t_tangent] = find_max_feasible_time(p_now,v_now,t_now,a_next,p_shadow,v_shadow,ts_window,a_shadow,a_comfort_dec);
                        if t_next_max == -inf
                             msg = ['Waning: the current vehicle violates the safety spacing at n = ',num2str(n), ', k= ',num2str(k),', i=',num2str(i)];
                             Feasibility = 0;
                             if REPORT_ERROR_AT_INFEASIBILITY==2
                                 error(msg);
                             elseif REPORT_ERROR_AT_INFEASIBILITY==1
                                 display(msg);
                             end
                             return;
                        end
                        if t_tangent > ts_window(2)  || t_tangent < max(ts_window(1),t_now)
                           t_next_max=inf;
                           t_tangent=inf;  
                        end
                        if t_tangent <= ts_window(2)  && t_tangent >= max(ts_window(1),t_now)
                            break;
                        end
                   end
                   if t_next_max <= t_next && t_next_max < inf
                       is_merging = 1;
                       t_next = t_next_max;
                       p_next = p_now + v_now*(t_next-t_now) + 0.5 * a_next*(t_next-t_now)^2;
                       v_next = v_now +  a_next*(t_next-t_now);
                   end
                end
            end % if ni>1

            if t_next > ts_all{n}(k) 
                ps_all{n}(k+1) = p_next;
                vs_all{n}(k+1) = v_next;
                ts_all{n}(k+1) = t_next;
                as_all{n}(k) = a_next;
                if IS_DYN_PLOT
                    if length(hs_cell{k})>0
                        delete(hs_cell{k});                                      
                        hs_cell{k} = [];
                    end
                    hs_cell{k}=plot_segment(ps_all{n}(k) ,vs_all{n}(k),as_all{n}(k),min(ts_all{n}(k:k+1),T_max),200,plot_cross,ts_all{n}(k),0,plot_shadow);
                    drawnow;
                    if save_animation                    
                        frame = getframe(figure_number);
                        im = frame2im(frame);
                        [imind,cm]=rgb2ind(im,256);
                        imwrite(imind,cm,ani_file_name,'gif','WriteMode','append');
                    end
                end 
                k = k+1;
            end

            if isinf(t_next) || is_merging
                break;
            end
        end % free  forward shooting  

        if is_merging % if it is the time to merge to the previous shadow trajectory.
            if t_tangent > ts_all{n}(k) 
                as_all{n}(k) = a_comfort_dec;
                td_prev = t_tangent - (ts_all{n-1}(i-1)+tau);
                ps_all{n}(k+1) = ps_all{n-1}(i-1)-s + vs_all{n-1}(i-1) *td_prev + 0.5*as_all{n-1}(i-1)* td_prev^2;
                vs_all{n}(k+1) = vs_all{n-1}(i-1) + as_all{n-1}(i-1)* td_prev;
                ts_all{n}(k+1) = t_tangent;
                if IS_DYN_PLOT
                    if length(hs_cell{k})>0
                        delete(hs_cell{k});                                      
                        hs_cell{k} = [];
                    end
                    hs_cell{k}=plot_segment(ps_all{n}(k) ,vs_all{n}(k),as_all{n}(k),min(ts_all{n}(k:k+1),T_max),200,plot_cross,ts_all{n}(k),0,plot_shadow);
                    drawnow;
                    if save_animation                    
                        frame = getframe(figure_number);
                        im = frame2im(frame);
                        [imind,cm]=rgb2ind(im,256);
                        imwrite(imind,cm,ani_file_name,'gif','WriteMode','append');
                    end
                end 
                k=k+1;
            end
            for h = i : length(ts_all{n-1});
                as_all{n}(k) = as_all{n-1}(h-1);
                ps_all{n}(k+1) = ps_all{n-1}(h)-s ;
                vs_all{n}(k+1) = vs_all{n-1}(h);
                ts_all{n}(k+1) = ts_all{n-1}(h)+tau;
                if IS_DYN_PLOT
                   if length(hs_cell{k})>0
                        delete(hs_cell{k});                                      
                        hs_cell{k} = [];
                    end
                    hs_cell{k}=plot_segment(ps_all{n}(k) ,vs_all{n}(k),as_all{n}(k),min(ts_all{n}(k:k+1),T_max),200,plot_cross,ts_all{n}(k),0,plot_shadow);
                    drawnow;
                    if save_animation
                        frame = getframe(figure_number);
                        im = frame2im(frame);
                        [imind,cm]=rgb2ind(im,256);
                        imwrite(imind,cm,ani_file_name,'gif','WriteMode','append');
                    end
                end 
                k=k+1;
            end
        end        
        as_all{n}(k)=0;

        for k = 1: length(ps_all{n})
            if ps_all{n}(k+1)>L           
                k_exit = k;
                dp = L-ps_all{n}(k);
                v_cur = vs_all{n}(k);
                a_exit = as_all{n}(k);
                if abs(a_exit) >= err_tol
                    dt = (-v_cur+sqrt(v_cur^2 + 2*a_exit*dp))/a_exit;
                else
                    dt = dp/v_cur;                
                end
                t_exit = ts_all{n}(k) + dt;
                v_exit = v_cur +a_exit*dt;
                break;
            end
        end


    %% backward shooting   
        dt_exit = t_plus(n)- t_exit;
        if  dt_exit > err_tol % if back shooting is needed
            t_exit = t_exit+dt_exit;
            if IS_DYN_PLOT
                hs_revers_cell =cell(round(300),1);
            end 
            k = k_exit;

            % shift the segments above L to the right;
            ps_reverse = [ps_all{n}(end:-1:k_exit+1),L];
            vs_reverse = [vs_all{n}(end:-1:k_exit+1),v_plus(n)];            
            ts_reverse = [ts_all{n}(end:-1:k_exit+1)+dt_exit,t_exit];
            as_reverse = [as_all{n}(end:-1:k_exit)]; 
            if IS_DYN_PLOT
                for h = length(ps_reverse)-1:-1:1
                    p_reverse_next = ps_reverse(h+1);
                    v_reverse_next = vs_reverse(h+1);
                    a_reverse_next = as_reverse(h+1);
                    hs_revers_cell{h} = plot_segment(p_reverse_next,v_reverse_next,a_reverse_next,min(ts_reverse(h+1:-1:h),T_max),200,plot_cross,ts_reverse(h+1),0,plot_shadow);
                    drawnow;
                    if save_animation                    
                        frame = getframe(figure_number);
                        im = frame2im(frame);
                        [imind,cm]=rgb2ind(im,256);
                        imwrite(imind,cm,ani_file_name,'gif','WriteMode','append');
                    end
                end
            end

            is_reverse_merging =0;
            while 1 %free backward shooting
                h=length(ps_reverse);
                p_reverse_now = ps_reverse(h);
                v_reverse_now = vs_reverse(h);
                t_reverse_now = ts_reverse(h);
                %free backward acceleration
                if vs_reverse(h) > 0 % if not stopped
                    a_reverse_next = a_reverse_comfort;
                    p_reverse_next = ps_reverse(h)  - vs_reverse(h)^2/(2*a_reverse_comfort);
                    v_reverse_next = 0;
                    t_reverse_next = ts_reverse(h) - vs_reverse(h)/a_reverse_next;                      
                else % if stopped
                    a_reverse_next = 0;
                    p_reverse_next = ps_reverse(h) ;
                    v_reverse_next = 0;
                    t_reverse_next = -inf;
                end

                for i = length(ts_all{n}):-1:2
                    ts_reverse_window = ts_all{n}(i-1:i);
                    p_reverse_shadow = ps_all{n}(i-1);
                    if p_reverse_shadow >= p_reverse_now
                        continue
                    end
                    v_reverse_shadow = vs_all{n}(i-1);
                    a_reverse_shadow = as_all{n}(i-1);
                    [t_reverse_max, t_reverse_tangent] = find_max_feasible_time(p_reverse_now,v_reverse_now,t_reverse_now,...
                        a_reverse_next,p_reverse_shadow,v_reverse_shadow,ts_reverse_window,a_reverse_shadow,a_reverse_comfort_dec,-1);
                    if t_reverse_max == inf
                         msg = ['the current reverse serch violates the safety spacing at n = ',num2str(n), ', h= ',num2str(h),', i=',num2str(i)];
                         Feasibility = 0;
                         if REPORT_ERROR_AT_INFEASIBILITY==2
                             error(msg);
                         elseif REPORT_ERROR_AT_INFEASIBILITY==1
                             display(msg);
                         end
                         return
                    end
                    if t_reverse_tangent > min(ts_reverse_window(2),t_reverse_now)  || t_reverse_tangent < ts_reverse_window(1)
                       t_reverse_max=-inf;
                       t_reverse_tangent=-inf;  
                    end
                    if t_reverse_tangent <= min(ts_reverse_window(2),t_reverse_now)  && t_reverse_tangent >= ts_reverse_window(1)
                        break;
                    end
                end

                if t_reverse_max ==-inf
                     msg = ['the current reverse serch can not meet the original trajectory at n = ',num2str(n), ', h= ',num2str(h),', i=',num2str(i)];
                     Feasibility = 0;
                     if REPORT_ERROR_AT_INFEASIBILITY==2
                         error(msg);
                     elseif REPORT_ERROR_AT_INFEASIBILITY==1
                         display(msg);
                     end
                     return;
                end

                if t_reverse_max >= t_reverse_next 
                   is_reverse_merging = 1;
                   t_reverse_next  = t_reverse_max;
                   dt = t_reverse_next -  t_reverse_now ;
                   v_reverse_next = v_reverse_now + a_reverse_next*dt;
                   p_reverse_next = p_reverse_now + v_reverse_now*dt + 0.5 *a_reverse_next*dt^2;
                end

                if t_reverse_max < t_reverse_now
                    ps_reverse = [ps_reverse,p_reverse_next];
                    vs_reverse = [vs_reverse,v_reverse_next];
                    ts_reverse = [ts_reverse,t_reverse_next];
                    as_reverse = [as_reverse,a_reverse_next];
                    if IS_DYN_PLOT
                        hs_revers_cell{h} = plot_segment(p_reverse_next,v_reverse_next,a_reverse_next,min(ts_reverse(end:-1:end-1),T_max),200,plot_cross,ts_reverse(end),0,plot_shadow);

                        drawnow;
                        if save_animation
                            frame = getframe(figure_number);
                            im = frame2im(frame);
                            [imind,cm]=rgb2ind(im,256);
                            imwrite(imind,cm,ani_file_name,'gif','WriteMode','append');
                        end
                    end    
                    h=length(ps_reverse);
                end

                if  is_reverse_merging == 1;

                    dt = t_reverse_tangent-ts_all{n}(i-1);
                    v_reverse_next = vs_all{n}(i-1)+ as_all{n}(i-1)*dt;
                    p_reverse_next = ps_all{n}(i-1) + vs_all{n}(i-1)*dt + 0.5*as_all{n}(i-1)*dt^2;
                    t_reverse_next = t_reverse_tangent;
                    a_reverse_next = a_reverse_comfort_dec;
                    ps_reverse = [ps_reverse,p_reverse_next];
                    vs_reverse = [vs_reverse,v_reverse_next];
                    ts_reverse = [ts_reverse,t_reverse_next];
                    as_reverse = [as_reverse,a_reverse_next];
                    if IS_DYN_PLOT
                        hs_revers_cell{h} = plot_segment(p_reverse_next,v_reverse_next,a_reverse_next,min(ts_reverse(end:-1:end-1),T_max),200,plot_cross,ts_reverse(end),0,plot_shadow);
                        drawnow;
                        if save_animation
                            frame = getframe(figure_number);
                            im = frame2im(frame);
                            [imind,cm]=rgb2ind(im,256);
                            imwrite(imind,cm,ani_file_name,'gif','WriteMode','append');
                        end
                    end 
                    h=length(ps_reverse);
                    break;
                end
            end %free backward shooting

            % truncate the original trajectory;
            ts_all{n}(i) = t_reverse_next;
            td = ts_all{n}(i)- ts_all{n}(i-1);
            vs_all{n}(i) = vs_all{n}(i-1) + as_all{n}(i-1)*td;
            ps_all{n}(i) = ps_all{n}(i-1) + vs_all{n}(i-1)*td+0.5*as_all{n}(i-1)*td^2;
            as_all{n}(i) = a_reverse_next;
            if IS_DYN_PLOT
                if length(hs_cell{i-1})>0
                    delete(hs_cell{i-1});                                      
                    hs_cell{i-1} = [];
                end
                hs_cell{i-1}=plot_segment(ps_all{n}(i-1) ,vs_all{n}(i-1),as_all{n}(i-1),ts_all{n}(i-1:i),200,plot_cross,ts_all{n}(i-1),0,plot_shadow);
                for h = i:length(ps_all{n}) 
                    if length(hs_cell{h})>0
                        delete(hs_cell{h});                                      
                        hs_cell{h} = [];
                    end
                end
                drawnow;
                if save_animation
                    frame = getframe(figure_number);
                    im = frame2im(frame);
                    [imind,cm]=rgb2ind(im,256);
                    imwrite(imind,cm,ani_file_name,'gif','WriteMode','append');
                end
            end 
            ps_all{n} = ps_all{n}(1:i);
            vs_all{n} = vs_all{n}(1:i);
            ts_all{n} = ts_all{n}(1:i);
            as_all{n} = as_all{n}(1:i);

            % add the reverse trajectory;
            i=i+1;
            for h = length(ps_reverse)-1:-1:1
                ps_all{n}(i)  = ps_reverse(h);
                vs_all{n}(i)  = vs_reverse(h);
                ts_all{n}(i) = ts_reverse(h);
                as_all{n}(i) = as_reverse(h);
    %             if IS_DYN_PLOT
    %                 if length(hs_revers_cell{h})>0
    %                     delete(hs_revers_cell{h});                                      
    %                     hs_revers_cell{h} = [];
    %                 end
    %                 hs_cell{i-1}=plot_segment(ps_all{n}(i-1) ,vs_all{n}(i-1),as_all{n}(i-1),min(ts_all{n}(i-1:i),T_max),200,plot_cross,ts_all{n}(i-1),0,plot_shadow);
    %                 drawnow;
    %                 if save_animation
    %                     frame = getframe(figure_number);
    %                     im = frame2im(frame);
    %                     [imind,cm]=rgb2ind(im,256);
    %                     imwrite(imind,cm,ani_file_name,'gif','WriteMode','append');
    %                 end
    %             end
                i=i+1;
            end
        end
        ts_exit = [ts_exit,t_exit];
        vs_exit = [vs_exit,v_exit];
        as_exit = [as_exit,a_exit];
    end  % loop over n
end% plat_i
