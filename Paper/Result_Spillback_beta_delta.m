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


parameters_backspill;
generate_boundary_backspill;
alpha = -tau*(1/entry_saturation_rate-1)-s/(v_max*entry_saturation_rate);
temp_term = sqrt(2*v_max*Delta(N))-sqrt(2*v_max*Delta_prev(N));
phi0 = (temp_term/(-alpha))^2;
phis = [0.06:0.01:1.8];


[temp,i0] = min(abs(phis -phi0));

Ns = [2:1:100];
betas = [];
deltas_0 = [];
deltas_E = [];
for N_value =Ns
    N_value
    parameters_backspill;
    N=N_value;
    generate_boundary_backspill;

    gamma = tau +s/v_max;
    beta_1 = [(N-2)*sqrt(2*v_max*Delta(N))-(N-1)*sqrt(2*v_max*Delta_prev(N))]; 
    betas =[betas,beta_1];
    phis = [0.06:0.01:1.8];
    thetas = [];
    lambda = 0.5;
    for i = 1:length(phis)
        phi = phis(i);
        evaluate_given_parameters;

        thetas=[thetas,min(delta(:,1))];
    end

    
    [delta_E, iE] = min(thetas(i0:end));
     iE = iE+i0-1;

    extreme_is=[i0, iE];
    extreme_phis=thetas([i0, iE]);
    extreme_locs=extreme_phis*v_max;
    
    deltas_0 = [deltas_0,thetas(i0)];
    deltas_E = [deltas_E,thetas(iE)];
end
hFig=figure(1); 
FontSize = 11;
w_fig =300;
h_fig = 200;
figure_initialization;

plot(Ns,betas,'b','linewidth',2);
plot([min(Ns),max(Ns)],[0,0],'k:')
[temp,i0_beta] = min(abs(betas));
ylims=get(gca,'ylim');
plot([Ns(i0_beta),Ns(i0_beta)],ylims,'r-.')

xlabel('$N$ ')
ylabel('$\beta_1$ (m$^{0.5}$)')


folder_fig = '../Paper/Figure/';
saveas(gcf,[folder_fig,['result_N_beta.eps']],'eps2c');

hFig=figure(2); 
FontSize = 11;
w_fig =300;
h_fig = 200;
figure_initialization;
plot(betas,deltas_0,'b-','linewidth',2);
plot(betas,deltas_E,'m--','linewidth',2);
plot(betas,deltas_0,'b-','linewidth',2);

ylims=get(gca,'ylim');
plot([betas(i0_beta),betas(i0_beta)],ylims,'r-.')
%plot(betas,deltas_E,'b--');
xlabel('$\beta_1$ (m$^{0.5}$)')
ylabel('$\delta_1^*(\phi)$ (sec)')
xlim([min(betas),max(betas)])
hleg=legend({'$\phi=\phi^0$','$\phi=\phi^\texttt{E}$'});
set(hleg,'interpreter','latex','box','off','location','southwest')
saveas(gcf,[folder_fig,['result_beta_delta.eps']],'eps2c');


