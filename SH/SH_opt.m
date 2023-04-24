
IS_DYN_PLOT = 0;
REPORT_ERROR_AT_INFEASIBILITY=0;
epsilon = 1e-5;

% theta=[1;-5;1;-5;30];
% theta=[2;-10;2;-10;80*0.44704];
theta=[a_max;a_min;a_max;a_min];
thetamax=[a_max;0;a_max;0];
thetamin=[0;a_min;0;a_min];
e=eye(4);

%% upload parameters


%%
%IS_DYN_PLOT = 1;
%shooting_heuristic;

record=[];
a_comfort = theta(1);
a_comfort_dec = theta(2);
a_reverse_comfort = theta(3);
a_reverse_comfort_dec = theta(4);
shooting_heuristic;
if Feasibility ==1
    obj_cur = fun_obj(ts_all,vs_all,as_all,t_plus,obj_type)/N;
else
    obj_cur = inf;
end
%loss_function_eval;
%obj_cur = z;
theta_opt = theta;
obj_opt = obj_cur;
obj_init = obj_cur;

record_inner=[obj_cur];

n_fac=1;
vec_the=[];
per1=[];
feas_ones=[];

jj=1;

%% opt_parameters
Var_Num = 4;
%Max_Iterations = 30;
Max_Solution_Time=6000;
border_distance_factor = 0.2;
Max_No_Improve_Iters = 5;
No_Improve_Iters = 0;
%Max_Jump_Num = 3;
%Max_Search_Num = 5;
solution_time = 0;
jj = 1;

figure(1);clf; hold on;
old_obj_opt = obj_opt;
t1 = cputime; 


while (solution_time < Max_Solution_Time)
    %numerical grade
    
    gk = inf*ones(Var_Num,1);
    for ii_temp = 1:Var_Num
        temp_scaler = 5;
        while (1)
            %search towards the upperbound
            probe_step_max = thetamax(ii_temp) - theta(ii_temp);
            probe_step_min = theta(ii_temp) - thetamin(ii_temp);
            
            if abs(probe_step_max)>=abs(probe_step_min)
                ck_temp1 = probe_step_max/temp_scaler ;
                ck_temp2 = -probe_step_min/temp_scaler ;
            else
                ck_temp1 = -probe_step_min/temp_scaler ; 
                ck_temp2 = probe_step_max/temp_scaler ;
            end
            x = theta + ck_temp1 *e(:,ii_temp);
            a_comfort = x(1);
            a_comfort_dec = x(2);
            a_reverse_comfort = x(3);
            a_reverse_comfort_dec = x(4);
            IS_DYN_PLOT =0;
            shooting_heuristic;
            if Feasibility ==1
                z = fun_obj(ts_all,vs_all,as_all,t_plus,obj_type)/N;
                gk(ii_temp) = (z - obj_cur)/ck_temp1;
                if z < obj_opt % update the best solution
                    theta_opt = x;
                    obj_opt = z;
                end
                break;
            end
            
            if ck_temp2>0
                x = theta + ck_temp2 *e(:,ii_temp);
                a_comfort = x(1);
                a_comfort_dec = x(2);
                a_reverse_comfort = x(3);
                a_reverse_comfort_dec = x(4);
                shooting_heuristic;
                if Feasibility ==1
                    z = fun_obj(ts_all,vs_all,as_all,t_plus,obj_type)/N;
                    gk(ii_temp) = (z - obj_cur)/ck_temp2;
                    if z < obj_opt % update the best solution
                        theta_opt = x;
                        obj_opt = z;
                    end
                    break;
                end
            end
            
            temp_scaler  = temp_scaler *2;
            
        end
    end

    % gradient search 
    step_max = find_max_step(gk,thetamin-theta,thetamax-theta);
    %step_max = step_max * Max_Step_Sizes(jj);
    step_next = step_max/(2*jj);
    upper_rate = 1+0.001;
    lower_rate = 1-0.001;
    while 1
        x = theta- step_next *gk;
        a_comfort = x(1);
        a_comfort_dec = x(2);
        a_reverse_comfort = x(3);
        a_reverse_comfort_dec = x(4);
        shooting_heuristic;
        if Feasibility ==1
            z = fun_obj(ts_all,vs_all,as_all,t_plus,obj_type)/N;
        else
            z = inf;
        end
        obj_next = z; 
        if z < obj_opt % update the best solution
            theta_opt = x;
            obj_opt = z;
        end
        if obj_next  < upper_rate * obj_cur 
            break;
        else
            step_next = step_next/2;
        end
    end
    

    if obj_next <lower_rate*obj_cur 
        while 1
            step_next_probe = 1.1*step_next;
            x = theta - step_next_probe *gk;
            a_comfort = x(1);
            a_comfort_dec = x(2);
            a_reverse_comfort = x(3);
            a_reverse_comfort_dec = x(4);
            shooting_heuristic;
            if Feasibility ==1
                z = fun_obj(ts_all,vs_all,as_all,t_plus,obj_type)/N;
            else
                z = inf;
            end
            obj_next_probe = z;

            if obj_next_probe>obj_next
                break;
            else
                if z < obj_opt % update the best solution
                    theta_opt = x;
                    obj_opt = z;
                end
                step_next = step_next_probe;
                obj_next = obj_next_probe;
            end
        end
    end
    
    if obj_opt <old_obj_opt*(1-epsilon);
        No_Improve_Iters = 0;
    else
        No_Improve_Iters = No_Improve_Iters+1;
    end
    
    
    
    if No_Improve_Iters>=Max_No_Improve_Iters
        break;
    else
         
    end
    
    theta = theta-step_next*gk;
    obj_cur = obj_next;    
    record_inner=[record_inner obj_next];
    plot(record_inner)
    plot([jj,jj+1],[old_obj_opt,obj_opt],':')
    pause(0.0000001)
    
    jj  = jj+1;
    old_obj_opt = obj_opt;
    solution_time=cputime-t1;
    if solution_time>Max_Solution_Time
        break;
    end
    
    
end


 theta_opt
%efg=min(record_inner)


%(obj_init-efg)/obj_init
obj_opt
solution_time








