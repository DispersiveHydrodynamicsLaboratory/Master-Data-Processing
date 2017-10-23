function[fh] = make_num_plots_for_pub(sourcefile,tmin,tmax,...
                            zmin,zmax,cmin,cred,cmax,...
                            zs,zsps,trajmin,trajmax,...
                            fignum,fhname,slant)
% This function formats cropped files into two plots:
% First  plot: shots of the conduit at selected points in time
% Second plot: contour plot over the time of the experiment
% Uses pieces of Dalton Anderson's savePlot.m
% snaps_vec: [ytop ybot interpfac]

% TODO: many of these could be inputs
debug_on = 0;
save_on  = 1;
Ninterp  = 500;
outerpos = 0; 
fontsize = 7;
fontname = 'helvetica';
w1       = (8.25-0.6*2)/4*2.54;
h1       = 1.25*2.54;%w1/1.618;
units    = 'centimeters';
fspec    = '-dpdf';
res      = '-r0';
xlabelsize = 5;
ylabelsize = 5;
        load(sourcefile,'A_full','t','zplot');
        Afull = A_full; clear('A_full');
% Rename space and time vectors for consistency
    T    = t;
    zold = zplot;

% Set up grid to interpolate TO
    zmin = max(0,zmin);
    zmax = min(max(zold),zmax);
    tmin = max(min(T),tmin);
    tmax = min(max(T),tmax);
    znew = linspace(zmin, zmax, Ninterp);
    tnew = linspace(tmin, tmax, Ninterp);
    
%   Interpolate to new vectors
    Anew = interp2(zold,T,Afull,znew,tnew','spline');
        % Try to cutoff anything too large
%         if cmax~=Inf
%             Anew(Anew>1.1*cmax) = 1.1*cmax;
%         end

disp('plotting...');
        % DALTON
        disp('Plotting contour plot...');
        fh = figure(fignum);clf
        if cred
           cv = [linspace(min(Anew(:)),cred,25) linspace(cred*1.01,max(Anew(:)),25)];
        else
           cv = 50;
        end
            contourf(znew,tnew,Anew,cv,'edgecolor','none'); 
            % Add line showing trajectory
            lwidth = 0.5;
            hold on;
            if ~isempty(zs)
            plot(zs(trajmin:0.1:trajmax),trajmin:0.1:trajmax,'k--',...
                'LineWidth',lwidth);
            end
            if ~isempty(zsps)
                zspsmax = fzero(@(t)zsps(t)-zmax,zmax) - 1;
                plot(zsps(trajmin:0.1:zspsmax),(trajmin:0.1:zspsmax),'k--',...
                        'LineWidth',lwidth);
            end
                ah = gca;
                set(ah,'fontsize',fontsize,'fontname',fontname);
                set(ah,'XTick',floor(linspace(zmin,zmax,xlabelsize)/10)*10);
                set(ah,'YTick',floor(linspace(tmin,tmax,ylabelsize)/10)*10);
            cmin = max(min(Afull(:)),cmin);
            cmax = min(max(Afull(:)),cmax);
            cmap = load('CoolWarmFloat257.csv');
            % Edit colormap for better visibility
            if cred
                cmap = cmap_edit(cred,cmin,cmax,cmap);
            end
            
            colormap(cmap);
            caxis([cmin,cmax]);
            ch=colorbar('Fontsize',fontsize,'Fontname',fontname);
            
            xlabel('z','HorizontalAlignment','center',...
                            'Interpreter','latex','Fontsize',fontsize);
            yname = ylabel('t',...
                            'Interpreter','latex','Fontsize',fontsize);

        % ---- change figure window ---- 
        set(fh,'units',units,'color','white')
        pos_fh = get(fh,'position'); % figure window
        set(fh,'position',[pos_fh(1:2),w1,h1])
        drawnow;
        % ---- change plot axes ----
        axs = 0.6; %normalized to width
        set(ah,'units',units,'fontsize',fontsize)
        pos_ah = get(ah,'position'); % plot axes
        set(ah,'position',[pos_ah(1:2),axs*w1,pos_ah(4)])
        % ---- change colorbar axes -----
        set(ch,'units',units,'fontsize',fontsize)
        pos_ch = get(ch,'position'); % colorbar
        pos_ch(1) = pos_ah(1) + (axs*1.1)*w1;
        set(ch,'position',[pos_ch(1:2),0.5*pos_ch(3),pos_ch(4)])
        % ---- change ylabel position
        ynamepos = get(yname,'Position');
        set(yname,'Position',[(1-2/32)*ynamepos(1), ynamepos(2:3)]);
        % ---- adjust paper size for printing ----
        set(fh,'PaperUnits','centimeters',...
               'PaperPosition',[0,0,w1,h1],...
               'PaperSize',[w1,h1])
           
        % Print figures
        if save_on
            disp('Saving...');
                print(fh,fhname,fspec,'-r300');
                disp(['Contour plot saved to ',fhname,' as a ',fspec(3:end)]);
        end
        hold off;


