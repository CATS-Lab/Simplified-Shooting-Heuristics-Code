clear;close all;
path_strs = strsplit(mfilename('fullpath'),'\');
cur_path = []; 
for folder = path_strs(1:end-1)
    cur_path = [cur_path folder{1} '\'];
end
cd(cur_path);
cd('../');
INITIALIZATION = 1;
include;

global tau s err_tol;
err_tol=1e-7;

alpha_value = 1;
phase_shifts = [50];
sats = [0.3,0.5,0.7,0.9];


for phase_shift_value = phase_shifts
%         if scenario_num == 2||scenario_num == 4
%             continue
%         end

    for i_sat = 1:length(sats)
        result_vec = [];
        for N = 50:50:1000
            N
            parameters_alg;
            entry_saturation_rate = sats(i_sat);
            exit_saturation_rate =entry_saturation_rate;
            alpha = alpha_value;
            beta = alpha;
            phase_shift =phase_shift_value;
            generate_boundary_alg;
            v_minus = v_max*(ones(N,1));
            v_plus = v_max*(ones(N,1));  
            plat_size 

            cpu_t_start = cputime;
            phi = -a_max*a_min/(a_max-a_min);
            lambda = -a_min/(a_max-a_min);
            %optimization results;
            Optimization;
            convert_trajectory_format;
            obj_VSP=fun_obj(ts_all,vs_all,as_all,t_plus)/N
            obj_SA=fun_obj(ts_all,vs_all,as_all,t_plus,2)/N
            if ~FEASIBILITY
                display 'Not feasible'
                break;
            end
            cpu_t_end = cputime;
            sol_t =cpu_t_end-cpu_t_start;


            SH_t_start = cputime;
            obj_type = 1;
            SH_opt;
            obj_SH_VSP = obj_opt;
            SH_t_end = cputime;
            sol_t_SH_VSP = SH_t_end-SH_t_start;

            SH_t_start = cputime;
            obj_type = 2;
            SH_opt;
            obj_SH_SA = obj_opt;
            SH_t_end = cputime;
            sol_t_SH_SA = SH_t_end-SH_t_start;

            result_vec = [result_vec; N, sol_t,sol_t_SH_VSP,sol_t_SH_SA, obj_VSP,obj_SH_VSP,obj_SA,obj_SH_SA];

        end
        results_cell{i_sat} = result_vec;
    end
end

%% plot the results
scenario_num = 0;
title_names={'(a) ','(b) ','(c) ','(d) ','(e) ','(f) ','(g) ','(h) ','(i) '};
markers = {'-+b','-*r','-ok','-vm','-^c'};

folder_fig = '../Paper/Figure/';
w_fig = 400;
h_fig = 300;



cases={'PSA','SA'};

%solution time
scenario_num =0; 
for i_c = 1:length(cases)
    scenario_num = scenario_num + 1;    
    leg_text = cell(length(sats),1);
    hFig=figure(scenario_num);
    FontSize = 11;
    figure_initialization;
    title ([title_names{scenario_num},'PSA/NSG solution time ratio for ', cases{i_c}],'Interpreter','latex')
    for i = 1:length(sats)
        plot(results_cell{i}(:,1),results_cell{i}(:,2+i_c)./results_cell{i}(:,2),markers{i})
        leg_text{i}=['$r=',num2str(sats(i)),'$'];
    end
    h=legend(leg_text,'location','northwest','box','off');     
    set(h,'Interpreter','latex')
    saveas(gcf,[folder_fig,'result_compare_time_',cases{i_c},'.eps'],'eps2c');
    savefig(['Figure/result_compare_time_',cases{i_c},'.fig',])
end


%solution timeobjectives

for i_c = 1:length(cases)
    scenario_num = scenario_num + 1;    
    leg_text = cell(length(sats),1);
    hFig=figure(scenario_num);
    FontSize = 11;
    figure_initialization;
    title ([title_names{scenario_num},'PSA/NSG objective ratio for ', cases{i_c}],'Interpreter','latex')
    for i = 1:length(sats)
        plot(results_cell{i}(:,1),results_cell{i}(:,3+2*i_c)./results_cell{i}(:,3+2*i_c+1),markers{i})
        leg_text{i}=['$r=',num2str(sats(i)),'$'];
    end
    if i_c == 1
        h=legend(leg_text,'location','northwest','box','off');
    else
        h=legend(leg_text,'location','northwest','box','off');
    end
    set(h,'Interpreter','latex')
    saveas(gcf,[folder_fig,'result_compare_objective_',cases{i_c},'.eps'],'eps2c');
    savefig(['Figure/result_compare_objective_',cases{i_c},'.fig',])
end
save('Compare_SH')

