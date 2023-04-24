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

parameters_signalized;
            %N, L, G, satuation
Para_vec = [50  500 60  0.4;
            25  500 60	0.4;            
            75  500 60  0.4;
            50  250 60 0.4;
            50  750 60 0.4;
            50  500 30  0.4;
            50  500 90  0.4;
            50  500 60  0.2;
            50  500 60  0.6;];
        
result_vec = [];

for i_para = 1:size(Para_vec,1)
    N = Para_vec(i_para,1);
    L = Para_vec(i_para,2);
    G = Para_vec(i_para,3)/2;
    R = Para_vec(i_para,3)/2;
    entry_saturation_rate = Para_vec(i_para,4);
    alpha=0.5;
    signal_phase =0;
    generate_boundary_signalized;

    
    
%     IS_DYN_PLOT = 0;
%     benchmark_run_gipps;
%     obj_BM=fun_obj(ts_all,vs_all,as_all,t_plus)/N;
    

    %non_smoothed results

    phi = -a_max*a_min/(a_max-a_min);
    lambda = -a_min/(a_max-a_min);
    evaluate_given_parameters;
    convert_trajectory_format;
    obj_EA=fun_obj(ts_all,vs_all,as_all,t_plus)/N;
    obj_EA_comf=fun_obj(ts_all,vs_all,as_all,t_plus,2)/N;



    %optimization results;
    Optimization;
    convert_trajectory_format;
    obj_OT=fun_obj(ts_all,vs_all,as_all,t_plus)/N;
    obj_OT_comf=fun_obj(ts_all,vs_all,as_all,t_plus,2)/N;
    
    perc_reduction = (obj_EA-obj_OT)/obj_EA;
    perc_reduction_comf = (obj_EA_comf-obj_OT_comf)/obj_EA_comf;
    result_vec =[result_vec;
        N,L,G+R,entry_saturation_rate, obj_EA obj_OT perc_reduction,obj_EA_comf obj_OT_comf perc_reduction_comf];

end
result_vec
    