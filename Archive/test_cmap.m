% Playing with colorbars

Z = peaks(20);

cmap = load('CoolWarmFloat257.csv');
% cmap = cmap;
cred = 4;
cmin = -6;
cmax = 6;
                ctop = cmap(end,:);
                cmid = cmap(256/2+1,:);
                cbot = cmap(1,:);
                cper = round((cred-cmin)/(cmax-cmin)*100)/100; % Cred as a fraction of clims
                csplit = 300*cper;
                cmap1 = [[linspace(cbot(1),cmid(1),csplit)',...
                         linspace(cbot(2),cmid(2),csplit)',...
                         linspace(cbot(3),cmid(3),csplit)'];...
                        [linspace(cmid(1),ctop(1),300-csplit)',... 
                         linspace(cmid(2),ctop(2),300-csplit)',...
                         linspace(cmid(3),ctop(3),300-csplit)']];%, linspace(), linspace() ]% mid to bot
cmap2 = zeros(300,3);

cmap2(1:csplit,1) = interp1(linspace(1,csplit,129),cmap(1:129,1),1:csplit);
cmap2(1:csplit,2) = interp1(linspace(1,csplit,129),cmap(1:129,2),1:csplit);
cmap2(1:csplit,3) = interp1(linspace(1,csplit,129),cmap(1:129,3),1:csplit);

cmap2(csplit+1:end,1) = interp1(linspace(1,300-csplit,129),cmap(129:end,1),1:(300-csplit));
cmap2(csplit+1:end,2) = interp1(linspace(1,300-csplit,129),cmap(129:end,2),1:(300-csplit));
cmap2(csplit+1:end,3) = interp1(linspace(1,300-csplit,129),cmap(129:end,3),1:(300-csplit));



figure(1);
        contourf(Z,'edgecolor','none');
        colormap(cmap); ch = colorbar;
figure(2);
        contourf(Z,'edgecolor','none');
        colormap(cmap2); ch1 = colorbar;