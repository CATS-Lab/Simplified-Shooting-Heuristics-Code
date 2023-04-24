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

parameters_homo;
generate_boundary_homo;

phis = [0.06:0.01:1.8];
thetas = [];


lambda = 0.5;
for i = 1:length(phis)
    phi = phis(i);
    evaluate_given_parameters;
    
    thetas=[thetas,min(delta(:,1))];
end



figure(1); 
FontSize = 11;
w_fig =300;
h_fig = 200;
figure_initialization;
plot(phis,thetas,'b','linewidth',2);
set(gca,'XTick',[]);
set(gca,'yTick',[]);
% plot([0,max(phis)],[0,0],'k:');
% text(-0.1,0,'0');
xlabh=xlabel('$\phi$');
old_pos = get(xlabh,'Position');
set(xlabh,'Position', [max(phis), old_pos(2), old_pos(3)]);
ylabh = ylabel('$\delta^*_1(\phi)$');
% old_pos = get(ylabh,'Position');
% set(ylabh,'Position', [old_pos(1), max(thetas), old_pos(3)]);

[delta_max,max_i] = max(thetas);
[delta_min,min_i] = min(thetas(max_i+1:end));
min_i=min_i+max_i;

ylims=get(gca,'ylim');
plot([phis(max_i),phis(max_i)],[ylims(1),delta_max],'k:')
text(phis(max_i),ylims(1)-4,'$\phi^{0}$')
plot([phis(min_i),phis(min_i)],[ylims(1),delta_min],'k:')
text(phis(min_i),ylims(1)-4,'$\phi^{\texttt{E}}$')
title('(a)')
folder_fig = '../Paper/Figure/';
saveas(gcf,[folder_fig,['Illur_phi_delta.eps']],'eps2c');



