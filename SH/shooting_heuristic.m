
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
        L1 = L*1.2;
        plot_frame_with_hwy;
    else
        L0 = 0;
        L1 = L*1.2;
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

Feasibility = 1;

for n=1:N
    if n ==1
        ts_prev = [];
        as_prev = [];
        vs_prev = [];
        ps_prev = [];
    else
        ts_prev = ts_all{n-1}+tau;
        as_prev = as_all{n-1};
        vs_prev = vs_all{n-1};
        ps_prev = ps_all{n-1}-s;
    end

    t_cur = t_minus(n);
    v_cur = v_minus(n);
    p_cur = 0;

    [ts_cur,as_cur,vs_cur,ps_cur,Feasibility]= forward_shooting(t_cur,v_cur,p_cur,...
        ts_prev,as_prev,vs_prev,ps_prev,a_comfort,a_comfort_dec,v_max);
    if Feasibility == 0
         msg = ['Forward shooting error: n = ',num2str(n), ', k= ',num2str(length(ts_cur))];
         Feasibility = 0;
         if REPORT_ERROR_AT_INFEASIBILITY==2
             error(msg);
         elseif REPORT_ERROR_AT_INFEASIBILITY==1
             display(msg);
         end
         return;
    end

    [t_exit,a_exit,v_exit,k_exit] = exit_state(ts_cur,as_cur,vs_cur,ps_cur,L,err_tol);

    ts_all{n} = ts_cur;
    as_all{n} = as_cur;
    vs_all{n} = vs_cur;
    ps_all{n} = ps_cur;

    if IS_DYN_PLOT
        hs_cell = cell(round(300),1);
        for k =1 :length(ts_all{n})-1
            hs_cell{k}=plot_segment(ps_all{n}(k) ,vs_all{n}(k),as_all{n}(k),min(ts_all{n}(k:k+1),T_max),200,plot_cross,ts_all{n}(k),0,plot_shadow);
            drawnow;
            if save_animation                    
                frame = getframe(figure_number);
                im = frame2im(frame);
                [imind,cm]=rgb2ind(im,256);
                imwrite(imind,cm,ani_file_name,'gif','WriteMode','append');
            end
        end
    end

%% backward shooting   
    dt_exit = t_plus(n)- t_exit;
    if dt_exit<0
        Feasibility = 0;
        if REPORT_ERROR_AT_INFEASIBILITY>0
            msg = ['Too slow forward shooting: n = ',num2str(n)];
            if REPORT_ERROR_AT_INFEASIBILITY == 2
             error(msg);
            elseif REPORT_ERROR_AT_INFEASIBILITY == 1
             display(msg);
            end
        end
        return;
    end
    if  dt_exit > err_tol % if back shooting is needed
        t_exit = t_plus(n);

        [ts_ext,as_ext,vs_ext,ps_ext,Feasibility]= forward_shooting(t_plus(n),v_plus(n),L,...
        ts_prev,as_prev,vs_prev,ps_prev,a_comfort,a_comfort_dec,v_max);
    
        if Feasibility == 0
            msg = ['Extended forward shooting error: n = ',num2str(n), ', k= ',num2str(length(ts_ext))];
            Feasibility = 0;
            if REPORT_ERROR_AT_INFEASIBILITY==2
             error(msg);
            elseif REPORT_ERROR_AT_INFEASIBILITY==1
             display(msg);
            end
            return;
        end       
        if IS_DYN_PLOT
            hs_ext_cell = cell(round(300),1);
            for k =1 :length(ts_ext)-1
                hs_ext_cell{k}=plot_segment(ps_ext(k),vs_ext(k),as_ext(k),min(ts_ext(k:k+1),T_max),200,plot_cross,ts_ext(k),0,plot_shadow);
                drawnow;
                if save_animation                    
                    frame = getframe(figure_number);
                    im = frame2im(frame);
                    [imind,cm]=rgb2ind(im,256);
                    imwrite(imind,cm,ani_file_name,'gif','WriteMode','append');
                end
            end
        end



        ts_reverse = ts_ext(end:-1:1);
        as_reverse = as_ext(end:-1:1);
        vs_reverse = vs_ext(end:-1:1);
        ps_reverse = ps_ext(end:-1:1);
        [ts_reverse,as_reverse,vs_reverse,ps_reverse, i_merge, Feasibility] = backward_shooting(ts_reverse,as_reverse,vs_reverse,ps_reverse,...
        ts_cur,as_cur,vs_cur,ps_cur,a_reverse_comfort,a_reverse_comfort_dec);        
        if Feasibility == 0
            msg = ['Backward shooting error: n = ',num2str(n), ', k= ',num2str(length(ts_reverse))];
            Feasibility = 0;
            if REPORT_ERROR_AT_INFEASIBILITY==2
             error(msg);
            elseif REPORT_ERROR_AT_INFEASIBILITY==1
             display(msg);
            end
            return;
        end
        if IS_DYN_PLOT
            hs_reverse_cell = cell(300,1);
            for h = length(ts_ext):length(ps_reverse)-1
                p_reverse_next = ps_reverse(h+1);
                v_reverse_next = vs_reverse(h+1);
                a_reverse_next = as_reverse(h+1);
                hs_reverse_cell{h} = plot_segment(p_reverse_next,v_reverse_next,a_reverse_next,min(ts_reverse(h+1:-1:h),T_max),200,plot_cross,ts_reverse(h+1),0,plot_shadow);
                drawnow;
                if save_animation                    
                    frame = getframe(figure_number);
                    im = frame2im(frame);
                    [imind,cm]=rgb2ind(im,256);
                    imwrite(imind,cm,ani_file_name,'gif','WriteMode','append');
                end
            end
        end


        % truncate the original trajectory;
        i = i_merge;
        ts_all{n}(i) = ts_reverse(end);
        td = ts_all{n}(i)- ts_all{n}(i-1);
        vs_all{n}(i) = vs_all{n}(i-1) + as_all{n}(i-1)*td;
        ps_all{n}(i) = ps_all{n}(i-1) + vs_all{n}(i-1)*td+0.5*as_all{n}(i-1)*td^2;
        as_all{n}(i) = as_reverse(end);
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
            i=i+1;
        end
    end
    ts_exit = [ts_exit,t_exit];
    vs_exit = [vs_exit,v_exit];
    as_exit = [as_exit,a_exit];
end  % loop over n
