L =150;
plat_length = 5;
N = 3*plat_length;

v_max = 16; % maximum velocity  m/s
a_max = 2;
a_min = -3.5;
    
s = 7; %buffer length of a vehicle - meters
tau = 1.5; % reaction time - sec


entry_saturation_rate = .8;
exit_saturation_rate = entry_saturation_rate;
shift = 10; %second;
alpha = 1;
beta = 1;

%signalized intersection;
IS_SIGNAL=0;
phase_shift = 5;



