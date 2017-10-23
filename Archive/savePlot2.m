function [] = savePlot2(fh,filename,w,h,fspec,res,units)
%--------------------------------------------------------------------------
% Purpose: This function saves a figure given a figure handle 'fh'
%          
% Inputs:  fh  =  figure handle
%          w   =  figure width (cm)
%          h   =  figuer height (cm)
%
% Author:  Dalton Anderson
% Date:    October 2017
%--------------------------------------------------------------------------

% if file name and destination folder not specified
datadir = pwd; % current directory
if nargin < 5
%     fspec = '-dpng'; 
%     res = '-r1000';
    units = 'centimeters';
    fspec = '-dpdf';
    res = '-r0';
end
 
set(fh,'Units',units)
pos = get(fh,'outerposition');
set(fh,'outerposition',[pos(1),pos(2),w,h])
% 
% set(fh,'Units','centimeters',...
%        'Position',[pos(1)*1.1,pos(2),w,h],...
%        'outerposition',[pos(1)-0.5,pos(2)-0.5,w,h])
%    
% pos = get(fh,'Position');
% 
set(fh,'PaperUnits','centimeters',...
       'PaperPosition',[0,0,w,h],...
       'PaperSize',[w,h])
 
% Print figure
print(fh,[datadir,'/',filename],fspec,res)
end