clf;
if ~exist('w_fig')
    w_fig = 400;
    h_fig =400;
end
if ~exist('x_corner')
    x_corner =100;
    y_corner =100;
end
if ~exist('FontSize')
    FontSize=12;
end
if ~exist('hFig')
    hFig = gcf;
end
set(hFig,'Position',[x_corner, x_corner,w_fig,h_fig]);
set(hFig, 'PaperUnits', 'centimeters');
saved_fig_size = [0 0 w_fig/35 h_fig/35];
set(hFig, 'PaperPosition', saved_fig_size);

if ~exist('Font_Name')
    Font_Name = 'times new roman';
end
set(0,'DefaultAxesFontName',Font_Name, 'DefaultTextFontName', Font_Name); %,'DefaultFigureFontName', Font_name
set(0,'DefaultAxesFontSize',FontSize,'DefaultTextFontSize',FontSize,'DefaultTextInterpreter','latex');
whitebg(hFig,'white');
set(hFig,'Color','w')
hold all;
