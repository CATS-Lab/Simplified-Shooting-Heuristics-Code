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

parameters_nonstop;
   %N, L, satuation
Para_vec = [50 1000  0.5;
            30 1000  0.5;
            100 1000  0.5
            50  500  0.5;
            50  1500  0.5;
            50  1000  0.3;
            50  1000  0.7;];
result_vec = [];
for i_para = 1:size(Para_vec,1)
    
    N = Para_vec(i_para,1);
    L = Para_vec(i_para,2);
    entry_saturation_rate = Para_vec(i_para,3);
    opp_entry_saturation_rate = Para_vec(i_para,3);
    alpha=0.5;
    beta=0.5;
    generate_boundary_nonstop;

    a_max = 2;
    a_min = -2;
    phi = -a_max*a_min/(a_max-a_min);
    lambda = -a_min/(a_max-a_min);
    evaluate_given_parameters;
    extension =0;
    convert_trajectory_format;
    obj_EA=fun_obj(ts_all,vs_all,as_all,t_plus)/N;


    %optimization results;
    Optimization;
    extension =0;
    convert_trajectory_format;
    obj_OT=fun_obj(ts_all,vs_all,as_all,t_plus)/N;
    
    perc_reduction = (obj_EA-obj_OT)/obj_EA;
    result_vec =[result_vec;
        N,L,(tau+s/v_max)/entry_saturation_rate, obj_EA obj_OT perc_reduction];

end
    