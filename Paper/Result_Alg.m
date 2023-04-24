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
err_tol=1e-7;

parameters_alg;
            %N, L, G, satuation
            
alphas = [0.5,1];
phase_shifts = [20,50];
scenario_num = 0;
title_names={'(a) ','(b) ','(c) ','(d) '};
for alpha_value = alphas
    for phase_shift_value = phase_shifts
        scenario_num = scenario_num+1;
%         if scenario_num == 2||scenario_num == 4
%             continue
%         end
        sats = [0.3,.5,.7,.9];
        results_cell= cell(3,1);

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
                plat_size 

                cpu_t_start = cputime;
                phi = -a_max*a_min/(a_max-a_min);
                lambda = -a_min/(a_max-a_min);

                %optimization results;
                Optimization;
                if ~FEASIBILITY
                    display 'Not feasible'
                    break;
                end

                cpu_t_end = cputime;

                result_vec = [result_vec; N, cpu_t_end-cpu_t_start];

            end
            results_cell{i_sat} = result_vec;
        end


        hFig=figure(scenario_num);
        FontSize = 11;
        w_fig =400;
        h_fig = 300;
        figure_initialization;

        markers = {'-*r','-+b','-ok','-vm','-^c'};
        leg_text = cell(length(sats),1);
        for i_sat = 1:length(sats)
           plot(results_cell{i_sat}(:,1),results_cell{i_sat}(:,2),markers{i_sat})
           leg_text{i_sat}=['$r=$',num2str(sats(i_sat))];
        end
        xlabel('$N$');
        ylabel('Solution time (sec)')
        h=legend(leg_text,'location','northwest','box','off');
        set(h,'Interpreter','latex')
        title ([title_names{scenario_num},'$\alpha=$',num2str(alpha),'; $\Delta^\texttt{S}=$',num2str(phase_shift)])
        %set(gca,'YScale','log');
        % X=[ones(size(result_vec,1),1),result_vec(:,1),result_vec(:,1).^2,result_vec(:,1).^3];
        % %X=[result_vec(:,1).^3];
        % b = regress(result_vec(:,2),X)
        % xx = [0:1:max(result_vec(:,1))]';
        % XX = [ones(size(xx)),xx,xx.^2,xx.^3];
        % %XX = [xx.^3];
        % yy = XX*b;
        % plot(xx,yy,'b');

        folder_fig = '../Paper/Figure/';
        saveas(gcf,[folder_fig,['result_alg_',num2str(scenario_num),'.eps']],'eps2c');
        savefig(['Figure/result_alg_',num2str(scenario_num),'.fig',])
         
        % convert_trajectory_format;
        % figure_num =2;
        % FontSize = 14;
        % Draw_Colorbar=1;
        % w_fig =500;
        % h_fig = 300;
        % plot_frame
        % %Is_Cross = 1;
        % plot_trajectories_stream;
    end
end