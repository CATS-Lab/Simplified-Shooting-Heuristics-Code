clear;
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

parameters;
entry_saturation_rate = .7;
exit_saturation_rate = entry_saturation_rate;%.00173
shift = 30; %second;
alpha = 0;
beta = 0;
L =1000;
lambda = 0.5;


Ns = [10:10:200];
phis = [0.1:.01:1];

q_length = zeros (length(Ns), length(phis));

for i= 1:length(Ns)
    N=Ns(i)
    generate_boundary;
    for j = 1:length(phis)
        phi = phis(j);
        evaluate_given_parameters;
        q_length(i,j) = L - v_max*min(delta(:,1));
    end
end


figure(50); clf; hold all;
surf(phis,Ns, q_length);
grid on;
view(3) 
xlabel('$\phi$');
ylabel('N')
zlabel('Queue length (m)')
title(['Delay: ',num2str(shift),'(sec); saturation: ', num2str(entry_saturation_rate)])

figure(51); clf; hold all;
FontSize = 10;
set(gcf,'DefaultAxesFontSize',FontSize,'DefaultTextFontSize',FontSize,'DefaultTextInterpreter','latex');
plot(phis,q_length(20,:))
xlabel('$\phi$');
ylabel('Queue (m)')
q_diff = max(q_length(20,:))-min(q_length(20,:));
%title(['Delay: ',num2str(shift),' (queue_diff =', num2str(q_diff,'%g'),'m)'])
title(['Saturation: ',num2str(entry_saturation_rate),' (queue_diff =', num2str(q_diff,'%g'),'m)'] )
set(gcf,'position',[200,200,400,300])

%title(['N=200; Delay: ',num2str(shift),'(sec); saturation: ', num2str(entry_saturation_rate)])









