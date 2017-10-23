% Testing subplot config
sb_size = 8;
sb_num  = 6;
XLabel_size = 1;
YLabel_size = 1;
XSpacer_size = 0;
YSpacer_size = 0;

Xsize = sb_num + XLabel_size + XSpacer_size;
Ysize = sb_size + YLabel_size + YSpacer_size;

sp_vecs = struct;
sp_vecs.XLabel = [];
sp_vecs.YLabel = [];
    for xi = 0:XLabel_size-1
        sp_vecs.XLabel = [sp_vecs.XLabel, ((Xsize-xi)*Ysize-sb_size):((Xsize-xi)*Ysize)];
    end
	for yi = 1:YLabel_size
        sp_vecs.YLabel = [sp_vecs.YLabel, yi:Ysize:((Xsize-1)*Ysize-yi-1)'];
    end
    for si = 0:sb_num-1
        vecstart = (si*Ysize+YLabel_size+YSpacer_size+1);
        sp_vecs.(['sp',num2str(si+1)]) = [vecstart:vecstart+sb_size-1];
    end
    
    figure(2); clf;
        ax(1) = subplot(Xsize,Ysize,sp_vecs.XLabel);
            plot(0,0); set(gca,'XTick',[],'YTick',[]);
            text(0,0,'XLabel');
        subplot(Xsize,Ysize,sp_vecs.YLabel);
            plot(0,0); set(gca,'XTick',[],'YTick',[]);
            text(0,0,'YLabel','Rotation',90);
        for si = 1:6
            subplot(Xsize,Ysize,sp_vecs.(['sp',num2str(si)]));
                plot(0,0); set(gca,'XTick',[],'YTick',[]);
                text(0,0,['sp',num2str(si)]);
        end
            
            
    
    
    
        