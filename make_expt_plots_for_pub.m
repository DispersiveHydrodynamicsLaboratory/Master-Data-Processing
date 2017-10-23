function[fh1, fh2] = make_expt_plots_for_pub(sourcedir,load_mat,quants,tmin,tmax,...
                            zmin,zmax,cmin,cred,cmax,snaps,snaps_vec,...
                            fignum1,fh1name,fh2name,slant);%,...spa)
% This function formats cropped files into two plots:
% First  plot: shots of the conduit at selected points in time
% Second plot: contour plot over the time of the experiment
% Uses pieces of Dalton Anderson's savePlot.m
% snaps_vec: [ytop ybot interpfac]

% TODO: many of these could be inputs
snaps_on = 1;       % Plot snapshots
contour_on = 1;
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

imgrows = 250;
imgcols = imgrows*20;

load([sourcedir,'img_timestamps.mat'],'T');

tinds = zeros(size(snaps));
for ii=1:length(snaps)
    [foo, s]  =  min(abs((T-T(1))-snaps(ii)));
    tinds(ii) = s(1);
end

    crop_dir = [sourcedir,'cropped',slant];
    vlengthscale = quants.fullPixToCm; % Vertical (axial) length scale in cm/pixel, ; % Vertical (axial) length scale in cm/pixel, 
% load first timestep for allocation purposes
    if ~ load_mat
        load([crop_dir,sprintf('%05d.mat',1)],'diam');
        disp('formatting files...');
        Dfull = zeros(length(T),length(diam));
        Dfull(1,:) = -diam;

    %   Add other timesteps to matrix
        for ii=2:length(T)
            load([crop_dir,sprintf('%05d.mat',ii)],'diam');
            Dfull(ii,:) = -diam;
            if ii==846
                disp('');
            end
        end
        disp('Saving...');
        save([crop_dir,'D_mat.mat'],'Dfull');
    else
        load([crop_dir,'D_mat.mat'],'Dfull');
    end
        [~,zL] = size(Dfull);
    
    % Compile images for subplot
	snaps_imgs = struct;
    sctr = 1;

	for ii=tinds
        load([crop_dir,sprintf('%05d.mat',ii)],'img');
        if snaps_vec
            img2 = imcrop(img,...
                [1,snaps_vec(1),length(img),snaps_vec(2)-snaps_vec(1)]);
            [mimg2,nimg2] = size(img2); 
            img3 = imresize(img2,[snaps_vec(3)*mimg2,nimg2]);
            snaps_imgs.(['ind',num2str(sctr)]) = img3;
        else
            snaps_imgs.(['ind',num2str(sctr)]) = img;
        end
        sctr = sctr + 1;
    end

    
% Change to area, normalize to smaller background, set starting time to 0
    Afull = Dfull.^2;
    T = T-T(1);
    A0 = sort(Afull);
    A0 = mean(A0(1:25));
    Afull = Afull/A0;
% z-vector in cm
    zold = (1:zL)*vlengthscale;

% Correct for irregularities in conduit by setting initial background
% conduit to 1 (additive correction)
    Abackground = Afull(1:2,:);
    Abackground = mean(Abackground);
    Acorr = mean(Abackground) - Abackground;
    Acorr = (smooth(Acorr,175))';
    Acorrmat = repmat(Acorr,length(T),1);
    Afull = Afull + Acorrmat;

% Figure for debugging background correction
    if debug_on
        figure(3); clf; plot(zold,Acorr);
        drawnow;
    end

% Set up grid to interpolate TO
    zmin = max(0,zmin);
    zmax = min(max(zold),zmax);
    tmin = max(min(T),tmin);
    tmax = min(max(T),tmax);
    znew = linspace(zmin, zmax, Ninterp);
    tnew = linspace(tmin, tmax, Ninterp);
        zminpx = round(zmin/vlengthscale);
        if zminpx == 0
            zminpx = 1;
        end
        zmaxpx = round(zmax/vlengthscale);
    
%   Interpolate to new vectors
    Anew = interp2(zold,T,Afull,znew,tnew','spline');
        % Try to cutoff anything too large
        if cmax~=Inf
            Anew(Anew>1.1*cmax) = 1.1*cmax;
        end

disp('plotting...');
    if snaps_on
        % Snapshots
        sp_vecs = sp_layout(length(snaps));
        fh1=figure(fignum1); clf;
            set(fh1,'Units',units,'PaperUnits',units,'Color','White')
            pos = get(fh1,'position');
            set(fh1,'Position',[pos(1),pos(2),w1,h1],...
                   'outerposition',[pos(1)-outerpos,pos(2)-outerpos,w1+2*outerpos,h1+2*outerpos],...
                   'PaperPosition',[0,0,w1,h1],...
                   'PaperSize',[w1,h1])
%         clf(); 
        for ii = 1:length(snaps)
            disp(['Plotting subplot ',num2str(ii)]);
                spimg = snaps_imgs.(['ind',num2str(ii)])(:,zminpx:zmaxpx);
                spimg = imresize(spimg,[imgrows,imgcols]);
            sp(ii)=subplot(sp_vecs.Xsize,sp_vecs.Ysize,sp_vecs.(['sp',num2str(ii)]),'align');
                pi(ii) = imshow(spimg,...
                    'InitialMagnification',100);
                
            % ylabel
            set(fh1.Children(1).YLabel,'String',sprintf('%-3d',round(T(tinds(ii)))),...
                    'FontSize',fontsize,'Fontname',fontname,'Rotation',0)
            ypos = get(fh1.Children(1).YLabel,'Position');
            if round(T(tinds(ii))) == 0
                posfac = 1;
            else
                posfac = floor(log10(T(ii)));
            end
            set(fh1.Children(1).YLabel,'Position',[-400 ypos(2:3)],...
                'VerticalAlignment','middle');
        end
        xs1 = subplot(sp_vecs.Xsize,sp_vecs.Ysize,sp_vecs.XSpacer);
            plot([-1 1], [0 0],'k'); hold on;
            % XTicks
            XTick = (floor(linspace(zmin,zmax,xlabelsize)/5)*5);
            XTick_snaps = (XTick-zmin)/((zmax-zmin)/2)-1;
            if XTick(1)<zmin
                XTick_snaps(1) = -1;
            end
            for xi = 1:length(XTick_snaps)
                plot(XTick_snaps(xi)*ones(2,1),[-0.1,0.1],'k')
                text(XTick_snaps(xi),-0.5,[num2str(XTick(xi))],...
                    'HorizontalAlignment','center',...
                    'Fontsize',fontsize,'Fontname',fontname,...
                    'Color',[0.15 0.15 0.15]);
            end
            axis([-1 1 -1 0.25]); axis off
            
            x1 = subplot(sp_vecs.Xsize,sp_vecs.Ysize,sp_vecs.XLabel);
                plot(0,0)
                xl = text(0,-1,'Vertical Length (cm)','HorizontalAlignment','center',...
                            'Interpreter','latex','Fontsize',fontsize);
                axis off; hold off;
            y1 = subplot(sp_vecs.Xsize,sp_vecs.Ysize,sp_vecs.YLabel);
                plot(0,0); set(gca,'XTick',[],'YTick',[]);
                yl = text(-2,0,'Time (s)',...
                        'VerticalAlignment','bottom',...
                        'HorizontalAlignment','center','Rotation',90,...
                        'Interpreter','latex','Fontsize',fontsize);
                axis off;
        drawnow;
    end
    
	if contour_on
        % DALTON
        disp('Plotting contour plot...');
        fh2 = figure(fignum1+1);clf
        if cred
           cv = [linspace(min(Anew(:)),cred,25) linspace(cred*1.01,max(Anew(:)),25)];
        else
           cv = 50;
        end
            contourf(znew,tnew,Anew,cv,'edgecolor','none'); 
                ah = gca;
                set(ah,'fontsize',fontsize,'fontname',fontname);
                set(ah,'XTick',floor(linspace(zmin,zmax,xlabelsize)/5)*5);
                set(ah,'YTick',floor(linspace(tmin,tmax,ylabelsize)/5)*5);
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
            
            xlabel('Vertical Length (cm)','HorizontalAlignment','center',...
                            'Interpreter','latex','Fontsize',fontsize);
            yname = ylabel('Time (s)',...
                            'Interpreter','latex','Fontsize',fontsize);

        % ---- change figure window ---- 
        set(fh2,'units',units,'color','white')
        pos_fh = get(fh2,'position'); % figure window
        set(fh2,'position',[pos_fh(1:2),w1,h1])
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
        set(fh2,'PaperUnits','centimeters',...
               'PaperPosition',[0,0,w1,h1],...
               'PaperSize',[w1,h1])
% 
    end
           
        % Print figures
        if save_on
            disp('Saving...');
            if snaps_on
%                 text(fh1.Children(1),-10,1,spa(1),'Fontsize',fontsize,...
%                     'FontName',fontname,'FontWeight','bold')
                print(fh1,fh1name,fspec,'-r300');
                disp(['Snapshot plot saved to ',fh1name,' as a ',fspec(3:end)]);
            end
            if contour_on
%                 text(fh2.Children(2),-5,1,spa(2))
                print(fh2,fh2name,fspec,'-r300');
                disp(['Contour plot saved to ',fh2name,' as a ',fspec(3:end)]);
            end
        end
        
        if ~snaps_on
            fh1 = [];
        end
        if ~contour_on
            fh2 = [];
        end


