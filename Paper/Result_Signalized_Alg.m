% clear;close all;
% path_strs = strsplit(mfilename('fullpath'),'\');
% cur_path = []; 
% for folder = path_strs(1:end-1)
%     cur_path = [cur_path folder{1} '\'];
% end
% cd(cur_path);
% cd('../');
% INITIALIZATION = 1;
% include;
% err_tol=1e-7;
% 
% parameters_signalized;
%             %N, L, G, satuation
% Para_vec = [50:50:2000]';
% 
% 
% result_vec = [];
% 
% 
% for i_para = 1:size(Para_vec,1)
%     N
%     N = Para_vec(i_para,1);
%     L = 500;
%     G = 30;
%     R = 30;
%     entry_saturation_rate = .4;
%     alpha=0.5;
%     signal_phase =0;
%     generate_boundary_signalized;
% 
%     
%     
% %     IS_DYN_PLOT = 0;
% %     benchmark_run_gipps;
% %     obj_BM=fun_obj(ts_all,vs_all,as_all,t_plus)/N;
%     
% 
%     %non_smoothed results
%     cpu_t_start = cputime;
%     phi = -a_max*a_min/(a_max-a_min);
%     lambda = -a_min/(a_max-a_min);
%    
% 
% 
% 
%     %optimization results;
%     Optimization;
%      
%     cpu_t_end = cputime;
%     
%     result_vec = [result_vec; N, cpu_t_end-cpu_t_start];
% 
% end
% result_vec

hFig=figure(1);
FontSize = 11;
w_fig =400;
h_fig = 300;
figure_initialization;

plot(result_vec(:,1),result_vec(:,2),'*')
xlabel('$N$');
ylabel('Solution time (sec)')

folder_fig = '../Paper/Figure/';
saveas(gcf,[folder_fig,['result_singalized_alg.eps']],'eps2c');
    