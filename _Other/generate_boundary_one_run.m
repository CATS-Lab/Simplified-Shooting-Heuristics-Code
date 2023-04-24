t_minus = zeros(N,1); %t_n^-
t_plus = zeros(N,1); %t_n^+
Delta = zeros(N,1); %Delta_n
Delta_prev = zeros(N,1); %Delta_n(n-1)
rand_seed = 1;
rand('state',rand_seed);

for n = 2 : N   % Equation (44)
    t_minus(n)= t_minus(n - 1)+(tau + s/v_max)*(1+(1/entry_saturation_rate-1)...
        *(1-alpha+alpha*rand()*2));
        
end

t_plus(1) = t_minus(1) + L/v_max+phase_shift ; % the one below (44)
for n = 2 : N  
    t_plus(n)= t_plus(n - 1)+(tau + s/v_max)*(1+(1/exit_saturation_rate-1)...
        *(1-beta+beta*rand()*2)); 
    t_plus(n)= max(t_minus(n) + L/v_max, t_plus(n));    
end



for n = 1:N
    Delta(n) = max(t_plus(n)- t_minus(n)- L/v_max,0) ;
end
for n = 2:N
    Delta_prev(n) = max(t_plus(n-1)+tau+s/v_max - t_minus(n) - L/v_max,0);
end


%%divide platoons; Algorithm PA 
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


T_max = (max(t_plus)+tau+s/v_max)*1;
