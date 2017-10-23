close all;clc
 
w     = 6; % width
h     = 5; % height
units = 'centimeters'; % units
fs    = 7; % fontsize
fspec = '-dpdf'; % output figure type
res   = '-r0'; % output figure resolution 
fname = 'test';
 
% make figure (normal size)
Z = peaks(20);% data
fh = figure(1);clf
    contourf(Z,'LineColor','none'); ah = gca;
    ch = colorbar;
    xlabel('test x','fontsize',7,'interpreter','latex')
    ylabel('test y','fontsize',7,'interpreter','latex')
 
% ---- change figure window ---- 
set(fh,'units',units,'color','white')
pos_fh = get(fh,'position'); % figure window
set(fh,'position',[pos_fh(1:2),w,h])
% ---- change plot axes ----
set(ah,'units',units,'fontsize',fs)
pos_ah = get(ah,'position'); % plot axes
set(ah,'position',[pos_ah(1:2),pos_ah(4),pos_ah(4)])
% ---- change colorbar axes -----
set(ch,'units',units,'fontsize',fs)
pos_ch = get(ch,'position'); % colorbar
set(ch,'position',[pos_ch(1:2),0.5*pos_ch(3),pos_ch(4)])
 
% ---- adjust paper size for printing ----
set(fh,'PaperUnits','centimeters',...
       'PaperPosition',[0,0,w,h],...
       'PaperSize',[w,h])
   
% print pdf
print(fh,fname,fspec,res)