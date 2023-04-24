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

parameters_SH;
generate_boundary_SH;
plat_size             

cpu_t_start = cputime;


%optimization results;
obj_type = 1;
SH_opt



cpu_t_end = cputime;

result_vec = [result_vec; N, cpu_t_end-cpu_t_start];

       

    

