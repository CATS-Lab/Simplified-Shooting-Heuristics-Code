hFig=figure(5);clf;
whitebg(hFig,'white');
edge =0.0;
hAx=axes('position',[edge  edge  1-2*edge  1-2*edge]);
set(gca,'Visible','off')
set(gcf,'Color','w')
hold all;
FontSize=20;
set(0,'DefaultAxesFontName', 'Times New Roman', 'DefaultAxesFontSize',FontSize,'DefaultTextFontSize',FontSize,'DefaultTextInterpreter','Latex');
w = 400;
h =400;
set(hFig,'Position',[100,280,w,h]);
set(gcf, 'PaperUnits', 'centimeters');
saved_fig_size=[0 0 w/35 h/35];
set(gcf, 'PaperPosition', saved_fig_size);


a1 = 2;
a2= -1;
v1_0 =10;
v2_0 = 20;
v_bar = 20;
t_inc =0.1;
ts = [0:t_inc:7];
p1s = 0;
p2s =-55;
for i = 2: length(ts)
    v1 = min(v_bar,v1_0+a1*ts(i));
    p1s(i) = p1s(i-1)+v1*t_inc;
    
    v2 = max(0,v2_0+a2*ts(i));
    p2s(i) = p2s(i-1) + v2*t_inc;
end

tau = 1;
s = 20;
plot(ts,p1s,'b','LineWidth',2)
text(ts(40)-.7,p1s(40),'$x_{n-1}(t)$','Rotation',40)
plot(ts+tau,p1s-s,'--k')
text(ts(45)-.7,p2s(45),'$x^{\texttt{s}}_{n-1}(t)$','Rotation',40)
plot(ts,p2s,'b','LineWidth',2)
text(ts(35)+.6,p2s(35),'$x_n(t)$','Rotation',40)
xlim ([min(ts),max(ts)]);
ylim ([min(p2s),max(p1s)-20]);

plot([ts(1),ts(1)+tau],[p1s(1),p1s(1)],':k')
text(ts(1)+0.5*tau,p1s(1)-5,'$\tau$')

plot([ts(1)+tau,ts(1)+tau],[p1s(1),p1s(1)-s],':k')
text(ts(1)+tau+0.1,p1s(1)-0.5*s,'$s$')
