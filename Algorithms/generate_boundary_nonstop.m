t_minus = zeros(N,1);
t_plus = zeros(N,1);

t_opp_minus = zeros(N,1);
t_opp_plus = zeros(N,1);

Delta = zeros(N,1);
Delta_prev = zeros(N,1);
rand_seed = 1;
rand('state',rand_seed);

%partition_points = sort([0, rand(1,N-2),1])*(N-1);
entry_table=[1,0;
             -1,0];


for n = 2 : N  
    t_minus(n)= t_minus(n - 1)+(tau + s/v_max)*(1+(1/entry_saturation_rate-1)...
        *(1-alpha+alpha*rand()*2));
        %*(1-alpha+alpha*(partition_points(n)-partition_points(n-1))));
    entry_table = [entry_table; n,t_minus(n)];
end

%partition_points = sort([0, rand(1,N-2),1])*(N-1);
for n = 2 : N  
    t_opp_minus(n)= t_opp_minus(n - 1)+(tau + s/v_max)*(1+(1/opp_entry_saturation_rate-1)...
        *(1-beta+beta*rand()*2));
        %*(1-beta+beta*(partition_points(n)-partition_points(n-1))));
    entry_table = [entry_table; -n,t_opp_minus(n)];
end
entry_table = sortrows(entry_table,2);
follow_headway = s/v_max+tau;

t_plus(1) = L/v_max;
t_opp_plus(1) = t_plus(1)+switch_headway;
prev_exit_time = t_opp_plus(1);
prev_n = -1;
for i = 3:size(entry_table,1)
    
    n = entry_table(i,1);
    if prev_n*n>0 % in the same direction
        next_exit_time = prev_exit_time+follow_headway;
    else
        next_exit_time = prev_exit_time+switch_headway;
    end
    
    cur_entry_time = entry_table(i,2);
    next_exit_time = max(next_exit_time, cur_entry_time+L/v_max);
    if n>0
        t_plus(n)=next_exit_time;
    else
        t_opp_plus(-n)=next_exit_time;
    end
    
    prev_exit_time = next_exit_time;
    prev_n = n;
end


for n = 1:N
    Delta(n) = max(t_plus(n)- t_minus(n)- L/v_max,0) ;
end
for n = 2:N
    Delta_prev(n) = max(t_plus(n-1)+tau+s/v_max - t_minus(n) - L/v_max,0);
end


%%divid Platoons
plat_size = 1;
platoons = {};
platoons{1} = [1];
for n =2:N
    if t_minus(n)<t_plus(n-1)+tau+s/v_max-L/v_max
        platoons{plat_size} =[platoons{plat_size}, n];
    else
        plat_size = plat_size+1;
        platoons{plat_size} = n;
    end
end

if 0
    figure(1); clf; hold on;
    plot(t_plus,L*ones(size(t_plus)),'r*')
    plot(t_opp_plus,L*ones(size(t_opp_plus)),'b*')
    for n =1:N
        plot([t_minus(n),t_plus(n)],[0,L],'r');
        plot([t_opp_minus(n),t_opp_plus(n)],[2*L,L],'r');
    end
end

T_max = max([t_plus;t_opp_plus])+tau+s/v_max;
