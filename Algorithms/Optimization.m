if ~exist('INITIALIZATION')
    clear;close all;
    path_strs = strsplit(mfilename('fullpath'),'\');
    cur_path = []; 
    for folder = path_strs(1:end-1)
        cur_path = [cur_path folder{1} '\'];
    end
    cd(cur_path);
    cd('../');
    INITIALIZATION = 1;
    IS_PLOT=1;
    include;
    
    parameters;
    a_max = 2;
    a_min = -3.5;
    % entry_saturation_rate = .7;
    % exit_saturation_rate = entry_saturation_rate;%.00173
    % shift = 10; %second;
    % alpha = .2;
    % beta = .2;
    % L =400;
    % N = 50;
    N=50;
    entry_saturation_rate = .75;
    exit_saturation_rate =1;
    L=500;
    shift =35;

    generate_boundary;

else
    if ~exist ('IS_PLOT')
        IS_PLOT=0;
    end
end



v_seg = v_max*ones(N,5);
x_seg = zeros(N,5);
delta = zeros (N,4);
a_platoon = zeros(length(platoons),5);


ns_prev = [0:N-1];
ns_next = cell(N,1);
for n = 1:N-1
    ns_next{n}=n+1;
end
phis_crit = zeros(N,2);
opt_phi_vec = zeros(plat_size,1);

for plat_i = 1:length(platoons)
    m = platoons{plat_i}(1);
    M = platoons{plat_i}(end);
    ns_to_check = [m+1:M];
    ns_delete = [];
    
    phi_crit_last =0;
    phi_opt=inf;
    
    phi_min = 0;
    for n = m:M
       phi_min = max(phi_min, fun_inv_delta(t_plus(n)-t_minus(n),Delta(n),v_max));
    end
    for iter = m:M
        phis_temp = inf*ones(1,M);
        for n = ns_to_check
            n_prev = ns_prev(n);        
            phi_bds = [v_max./(2*Delta(n_prev+1:n));v_max./(2*Delta_prev(n_prev+1:n))];
            phi_bds = sort(phi_bds);

            for i = 1: length(phi_bds)
                if i == 1
                    phi_bd(1) = phi_crit_last;
                else
                   phi_bd(1) = phi_bds(i-1); 
                end
                phi_bd(2) =  phi_bds(i);

                C =0;
                B = 0;
                A = t_plus(n)-t_plus(n_prev)-(n-n_prev)*tau;
                for n_prime = n_prev+1:n
                    if phi_bd(2)<=v_max/(2*Delta(n_prime));
                        B = B-sqrt(2*v_max*Delta(n_prime));
                    else
                        C = C - v_max/2;
                        A = A - Delta(n_prime);
                    end
                    if phi_bd(2)<=v_max/(2*Delta_prev(n_prime));
                       B = B+sqrt(2*v_max*Delta_prev(n_prime));
                    else
                       C = C + v_max/2;
                       A = A + Delta_prev(n_prime); 
                    end

                end
                eta = [];
                if A==0
                    eta = -C/B;
                else
                   if C ==0
                     eta(1) = -B/A;
                   else
                    eta(1) = (-B+sqrt(B^2-4*A*C))/(2*A);
                    eta(2) = (-B-sqrt(B^2-4*A*C))/(2*A); 
                   end
                end
                %phi_bd
                
                phi_roots = [];
                for temp_i =1:length(eta)
                    if eta(temp_i)>=0
                        phi_roots =  [phi_roots, eta(temp_i)^2];
                    end
                end
                
                phi_temp = -inf;
                for k = 1:length( phi_roots);
                    if phi_roots(k)>=phi_bd(1) && phi_roots(k)<=phi_bd(2)
                        phi_temp = phi_roots(k);
                    end
                end
                if phi_temp>=0
                    phis_temp(n) = phi_temp;
                    break;
                end
            end
        end

        if length(ns_to_check)
            [phi_crit,n_crit] = min (phis_temp);
            phis_crit(iter,:)= [phi_crit,n_crit];
        else
            phi_crit=inf;
            n_crit=0;
            phis_crit(iter,:)= [phi_crit,n_crit];
        end

        if phi_crit>=phi_min
            phi_lb = max(phi_min,phi_crit_last);
            phi_feasible_range = [phi_lb, phi_crit]; 
            for n = m+1:M
                phi_tilda = fun_inv_delta(t_plus(n)-t_minus(n),Delta(n),v_max);
                phi_feasible_range = fun_intersect_range([phi_tilda,inf],phi_feasible_range);
                if ~length(phi_feasible_range)
                    break;
                end
                n_prev = ns_prev(n);
                phis_sub_crit=[phi_lb,phi_crit];
                for n_prime = n_prev+1:n-1
                    phi_temp = v_max/(2*Delta(n_prime));
                    if phi_temp>phi_lb && phi_temp<phi_crit
                        phis_sub_crit = [phis_sub_crit,phi_temp];
                    end
                end
                for n_prime = n_prev+1:n
                    phi_temp = v_max/(2*Delta_prev(n_prime));
                    if phi_temp>phi_lb && phi_temp<phi_crit
                        phis_sub_crit = [phis_sub_crit,phi_temp];
                    end
                end
                phis_sub_crit=sort(phis_sub_crit);

                new_feas_range_comb = [];
                for i = 2:length(phis_sub_crit)
                    C =0;
                    B = 0;
                    A = t_plus(n_prev)+(n-n_prev)*tau-t_minus(n);
                    for n_prime = n_prev+1:n-1
                        if phis_sub_crit(i)<=v_max/(2*Delta(n_prime))
                            B = B+sqrt(2*v_max*Delta(n_prime));
                        else
                            C = C + v_max/2;
                            A = A + Delta(n_prime);
                        end
                    end
                    for n_prime = n_prev+1:n
                        if phis_sub_crit(i)<=v_max/(2*Delta_prev(n_prime))
                           B = B-sqrt(2*v_max*Delta_prev(n_prime));
                        else
                           C = C - v_max/2;
                           A = A - Delta_prev(n_prime); 
                        end
                    end

                    new_feas_range=[];
                    eta = [];
                    phi_root = [];
                    if A==0
                        if B ==0
                            if C>=0
                                new_feas_range= [phis_sub_crit(i-1),phis_sub_crit(i)];
                            end
                        else
                            eta = -C/B;
                            
                            phi_root = eta^2;
                            if B>0
                                if phi_root<=phis_sub_crit(i)
                                    new_feas_range=[max(phis_sub_crit(i-1),phi_root),phis_sub_crit(i)];

                                end

                            else
                                if phi_root>=phis_sub_crit(i-1)
                                   new_feas_range =[phis_sub_crit(i-1),min(phis_sub_crit(i),phi_root)];
                                end
                            end
                        end
                        
                    else 
                        if B^2-4*A*C>=0
                            eta(1) = (-B+sqrt(B^2-4*A*C))/(2*A);
                            eta(2) = (-B-sqrt(B^2-4*A*C))/(2*A);
                            phi_roots = sort( max(eta,0).^2);

                            if A>0
                                if phi_roots(1) >= phis_sub_crit(i-1)
                                    new_feas_range= [phis_sub_crit(i-1),min(phi_roots(1),phis_sub_crit(i))];
                                end

                                if length(phi_roots)>=2&& phi_roots(2) <= phis_sub_crit(i)
                                    new_feas_range= fun_union_range(new_feas_range,[max(phis_sub_crit(i-1),phi_roots(2)),phis_sub_crit(i)]);
                                end
                            else
                                if phi_roots(1)<=phis_sub_crit(i) && phi_roots(2)>=phis_sub_crit(i-1)
                                    new_feas_range= [max(phis_sub_crit(i-1),phi_roots(1)),min(phi_roots(2),phis_sub_crit(i))];
                                end
                            end
                        else
                            if A>0
                                new_feas_range= [phis_sub_crit(i-1),phis_sub_crit(i)];
                            end
                        end
                    end
                    new_feas_range_comb = fun_union_range(new_feas_range_comb,new_feas_range);
                end

                phi_feasible_range = fun_intersect_range(new_feas_range_comb,phi_feasible_range);
                if ~length(phi_feasible_range)
                    break;
                end

            end
            if length(phi_feasible_range)
                phi_opt =phi_feasible_range(1);
                opt_phi_vec(plat_i)=phi_opt;
                break;
            end
        end


        if length(ns_to_check)
            for n_temp = ns_next{n_crit} 
                n_new_prev = ns_prev(n_crit);
                ns_prev(n_temp)= n_new_prev;
                ns_next{n_new_prev} =[ns_next{n_new_prev},n_temp];
            end  

            ns_next{n_crit} = [];
            in = find (ns_to_check==n_crit);
            ns_to_check=[ns_to_check(1:in-1),ns_to_check(in+1:end)];
            phi_crit_last = phi_crit;
            
%             
%             iter
%             ns_delete=sort([ns_delete,n_crit]);
%             test_temp
%             if ~isequal(ns_delete,ns_delete_plot) 
%                  setdiff(ns_delete_plot,ns_delete)
%             end
        end
    end
    
    phi=phi_opt;
    lambda =min(max(0.5,phi/a_max),1+phi/a_min);
    %lambda = 0.5;
    a_minus = phi/(1-lambda);
    a_plus = phi/lambda;
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

if phi_opt ==inf
    FEASIBILITY = 0;
else
    FEASIBILITY = 1;
end

if IS_PLOT
    opt_phi_vec
    [delta1_star,n_star]=min(delta( platoons{1},1))
    figure(2); clf; hold all;
    is_cross=1;
    plot_trajectories_stream;
end
%test


