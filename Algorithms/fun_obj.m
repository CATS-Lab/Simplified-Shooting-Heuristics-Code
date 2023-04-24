function obj = fun_obj(ts_all,vs_all,as_all,t_plus,type)
if nargin<5
    type =1;% fuel consumption
end

obj = 0;
time_step = 0.1;
N = length(ts_all); 

if type ==1
    psi = 0.132*2.23694;
    zeta = 0.000302*2.23694^3;
    xi = 1.1*2.23694^2;
end

for n = 1:N
    for k = 1: length(ts_all{n})-1
        t_start = ts_all{n}(k);       
        t_end = min(t_plus(n),ts_all{n}(k+1));
        dt = t_end - t_start;
        num_points = max(2,floor(dt/time_step)); 
        this_time_step =  dt/(num_points-1);
        ts = linspace(t_start,t_end,num_points);
        vs = vs_all{n}(k)+ (ts-t_start)*as_all{n}(k);
        as = as_all{n}(k)*ones(size(vs));
        vs_avg = (vs(1:end-1)+vs(2:end))/2;
        as_avg = (as(1:end-1)+as(2:end))/2;
        if type ==1
            %obj = obj + sum(0.29528*vs+0.0033804*vs.^3+5.5043*vs.*as)*this_time_step ;   
            obj = obj + sum(psi*vs+zeta*vs.^3)*this_time_step;
        else
            obj = obj +sum(as.^2*this_time_step);
        end
    end
end
