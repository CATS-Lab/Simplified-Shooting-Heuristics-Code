scenario_num = 0;
title_names={'(a) ','(b) ','(c) ','(d) ','(e) ','(f) ','(g) ','(h) ','(i) '};
markers = {'-+b','-*r','-ok','-vm','-^c'};

folder_fig = '../Paper/Figure/';
w_fig = 400;
h_fig = 300;



cases={'VSP','SA'};

%solution time
scenario_num =0; 
is = [1,3,2,4];
for i_c = 1:length(cases)
    scenario_num = scenario_num + 1;    
    leg_text = cell(length(sats),1);
    hFig=figure(scenario_num);
    FontSize = 11;
    figure_initialization;
    title ([title_names{scenario_num},'PSA/NSG-SH solution time ratio for ', cases{i_c}],'Interpreter','latex')
    for i_sat = 1:length(sats)
        i= is(i_sat);
        plot(results_cell{i}(:,1),results_cell{i}(:,2)./results_cell{i}(:,2+i_c),markers{i})
        leg_text{i_sat}=['$r=',num2str(sats(i)),'$'];
    end
    xlabel('$N$')
    ylabel('Solution time ratio')
    
    
    %change the axis to percentage
    yt = get(gca, 'ytick'); % current ytick [0, 0.2, 0.4, 0.6, 0.8, 1]
    % conver to [0 100]
    yt100 = yt*100;
    % convert to string
    % note the transpose so each number is on its own line
    ytstr = num2str(yt100');
    % make a cell string
    % {'  0', ' 20', ' 40', ' 60', ' 80', ' 100'}
    ytcell = cellstr(ytstr); 
    % get rid of leading/trailing spaces
    ytcell_trim = strtrim(ytcell);
    % append % on there
    ytpercent = strcat(ytcell_trim, '%');
    set(gca, 'yticklabel', ytpercent); % make the change
    
    if i_c ==1
        h=legend(leg_text,'location','northwest','box','off'); 
    else
        h=legend(leg_text,'location','northwest','box','off'); 
    end
    set(h,'Interpreter','latex')
    saveas(gcf,[folder_fig,'result_compare_time_',cases{i_c},'.eps'],'eps2c');
    savefig(['Figure/result_compare_time_',cases{i_c},'.fig',])
    
end


%solution timeobjectives

for i_c = 1:length(cases)
    scenario_num = scenario_num + 1;    
    leg_text = cell(length(sats),1);
    hFig=figure(scenario_num);
    FontSize = 11;
    figure_initialization;
    title ([title_names{scenario_num},'PSA/NSG-SH objective ratio for ', cases{i_c}],'Interpreter','latex')
    for i_sat = 1:length(sats)
        i= is(i_sat);
        plot(results_cell{i}(:,1),results_cell{i}(:,3+2*i_c)./results_cell{i}(:,3+2*i_c+1),markers{i})
        leg_text{i_sat}=['$r=',num2str(sats(i)),'$'];
    end
    xlabel('$N$')
    ylabel('Objective ratio')
   
     
    if i_c == 1
        ylim([0.996,1.001])
        h=legend(leg_text,'location','southwest','box','off');
    else
        h=legend(leg_text,'location','north','box','off');
    end
    set(h,'Interpreter','latex')
    
     %change the axis to percentage
    yt = get(gca, 'ytick'); % current ytick [0, 0.2, 0.4, 0.6, 0.8, 1]
    % conver to [0 100]
    yt100 = yt*100;
    % convert to string
    % note the transpose so each number is on its own line
    ytstr = num2str(yt100');
    % make a cell string
    % {'  0', ' 20', ' 40', ' 60', ' 80', ' 100'}
    ytcell = cellstr(ytstr); 
    % get rid of leading/trailing spaces
    ytcell_trim = strtrim(ytcell);
    % append % on there
    ytpercent = strcat(ytcell_trim, '%');
    set(gca, 'yticklabel', ytpercent); % make the change
    saveas(gcf,[folder_fig,'result_compare_objective_',cases{i_c},'.eps'],'eps2c');
    savefig(['Figure/result_compare_objective_',cases{i_c},'.fig',])
end

% for i_sat = 1:2
%     result_vec = results_cell{i_sat};
% 
%     
% 
%     %solution time
%     leg_text = cell(3,1);
%     scenario_num = i_sat;
%     hFig=figure(scenario_num);
%     FontSize = 11;
%    
%     
%     figure_initialization;
%     title ([title_names{scenario_num},'Solution time: ($r=',num2str(sats(i_sat)),'$)'],'Interpreter','latex')
%     plot(result_vec(:,1),result_vec(:,2),markers{1})
%     leg_text{1}=['PSA'];
%     plot(result_vec(:,1),result_vec(:,3),markers{2})
%     leg_text{2}=['NSG for VSP'];
%     plot(result_vec(:,1),result_vec(:,4),markers{3})
%     leg_text{3}=['NSG for SA'];
%     xlabel('$N$');
%     ylabel('Solution time (sec)')
%    set(gca,'YScale','log');
%     if i_sat ==1
%         h=legend(leg_text,'location','west','box','off');        
%     else
%         h=legend(leg_text,'location','southeast','box','off');
%     end
%     set(h,'Interpreter','latex')
%     
%     saveas(gcf,[folder_fig,['result_compare_time_',num2str(sats(i_sat)),'.eps']],'eps2c');
%     savefig(['Figure/result_compare_time_',num2str(sats(i_sat)),'.fig',]) 
%     
%     
%     scenario_num = i_sat+3;
%     leg_text = cell(2,1);
%     hFig=figure(scenario_num);
%     FontSize = 11;
%     figure_initialization;
%     plot(result_vec(:,1),result_vec(:,5)./result_vec(:,6),markers{1})
%     leg_text{1}=['VSP'];
%     plot(result_vec(:,1),result_vec(:,7)./result_vec(:,8),markers{2})
%     leg_text{2}=['SA'];
%     xlabel('$N$');
%     ylabel('Ratio')
%     h=legend(leg_text,'location','west','box','off');
%     set(h,'Interpreter','latex')
%     title ([title_names{scenario_num},'PSA/NSG objective ratio ($r=',num2str(sats(i_sat)),'$)'])
%     saveas(gcf,[folder_fig,['result_compare_VSP_',num2str(sats(i_sat)),'.eps']],'eps2c');
%     savefig(['Figure/result_compare_VSP_',num2str(sats(i_sat)),'.fig',]);
%     set(gca,'YScale','log');
%     %objective for VSP
%     scenario_num = i_sat+3;
%     leg_text = cell(2,1);
%     hFig=figure(scenario_num);
%     FontSize = 11;
%     figure_initialization;
%     plot(result_vec(:,1),result_vec(:,5),markers{1})
%     leg_text{1}=['PSA'];
%     plot(result_vec(:,1),result_vec(:,6),markers{2})
%     leg_text{2}=['NSG'];
%     xlabel('$N$');
%     ylabel('VSP objective (kJ/ton)')
%     h=legend(leg_text,'location','northwest','box','off');
%     set(h,'Interpreter','latex')
%     title ([title_names{scenario_num},'VSP objective comparison ($r=',num2str(sats(i_sat)),'$)'])
%     saveas(gcf,[folder_fig,['result_compare_VSP_',num2str(sats(i_sat)),'.eps']],'eps2c');
%     savefig(['Figure/result_compare_VSP_',num2str(sats(i_sat)),'.fig',]);
    
%     %objective for VSP
%     scenario_num = i_sat+6;
%     leg_text = cell(2,1);
%     hFig=figure(scenario_num);
%     FontSize = 11;
%     figure_initialization;
%     plot(result_vec(:,1),result_vec(:,7),markers{1})
%     leg_text{1}=['PSA'];
%     plot(result_vec(:,1),result_vec(:,8),markers{2})
%     leg_text{2}=['NSG'];
%     xlabel('$N$');
%     ylabel('SA objective (m$^{2}$/s$^{4}$)')
%     if i_sat ==1
%         h=legend(leg_text,'location','west','box','off');
%     else
%         h=legend(leg_text,'location','northwest','box','off');
%     end
%     set(h,'Interpreter','latex')
%     title ([title_names{scenario_num},'SA objective comparison ($r=',num2str(sats(i_sat)),'$)'])
%     saveas(gcf,[folder_fig,['result_compare_SA_',num2str(sats(i_sat)),'.eps']],'eps2c');
%     savefig(['Figure/result_compare_SA_',num2str(sats(i_sat)),'.fig',]);
%end
