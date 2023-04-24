% Return t if t is in a green phase or return the starting time of the next
% green time otherwise
function t_g=get_G_next(t,G,R,phase)
if nargin<4
    phase = 0;
end
Cycle = G+R;
c_num=floor((t-phase)/Cycle);
dt = (t-phase)-c_num*Cycle;
if dt >= G
    dt=Cycle;
end
t_g =  c_num*Cycle+phase + dt;




