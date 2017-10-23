function[sp_vecs] = sp_layout(sb_num);
% Subplot config
sp_vecs = struct;
sp_debug_on = 0;

sp_vecs.sb_width = 15;
sp_vecs.sb_length = 2;
sp_vecs.sb_num  = sb_num;
sp_vecs.XLabel_size = 1;
sp_vecs.YLabel_size = 1;
sp_vecs.XSpacer_size = 2;
sp_vecs.YSpacer_size = 1;

sp_vecs.Xsize = sp_vecs.sb_num*sp_vecs.sb_length + sp_vecs.XLabel_size + sp_vecs.XSpacer_size;
sp_vecs.Ysize = sp_vecs.sb_width + sp_vecs.YLabel_size + sp_vecs.YSpacer_size;

sp_vecs.XLabel = [];
sp_vecs.YLabel = [];
sp_vecs.XSpacer = [];
% Make space for XLabel
    for xi = 0:sp_vecs.XLabel_size-1
        xstart = ((sp_vecs.Xsize-xi)*sp_vecs.Ysize-sp_vecs.sb_width+1);
        sp_vecs.XLabel = [sp_vecs.XLabel, xstart:((sp_vecs.Xsize-xi)*sp_vecs.Ysize)];
    end
% Make spacer for xaxis (in between Xlabel and plots)
	for xsi = 0:sp_vecs.XSpacer_size-1
        xspacerstart = ((sp_vecs.Xsize-xsi-1)*sp_vecs.Ysize-sp_vecs.sb_width+1);
        sp_vecs.XSpacer = [sp_vecs.XSpacer, xspacerstart:xspacerstart+sp_vecs.sb_width-1];
    end
% Make space for Ylabel    
	for yi = 1:sp_vecs.YLabel_size
        sp_vecs.YLabel = [sp_vecs.YLabel, yi:sp_vecs.Ysize:(sp_vecs.sb_num*sp_vecs.sb_length*sp_vecs.Ysize)'];
    end
% Make space for subplots
vecstarts = ([0:2*(sp_vecs.sb_num)-1]*sp_vecs.Ysize+sp_vecs.YLabel_size+sp_vecs.YSpacer_size+1);
    for si = 0:sp_vecs.sb_num-1
            sp_vecs.(['sp',num2str(si+1)]) = [];
        for spi = 1:sp_vecs.sb_length
            vecstart = vecstarts(si*2+spi);
            sp_vecs.(['sp',num2str(si+1)]) = [sp_vecs.(['sp',num2str(si+1)]),...
                                vecstart:vecstart+sp_vecs.sb_width-1];
        end
    end
    
    if sp_debug_on
        % Plot for debugging
        figure(2); clf;
            ax(1) = subplot(sp_vecs.Xsize,sp_vecs.Ysize,sp_vecs.XLabel);
                plot(0,0); set(gca,'XTick',[],'YTick',[]);
                xl = text(0,0,'XLabel','Interpreter','latex');
            ax(3) = subplot(sp_vecs.Xsize,sp_vecs.Ysize,sp_vecs.XSpacer);
                plot(0,0); set(gca,'XTick',[],'YTick',[]);
                xsl = text(0,0,'XSpacer','Interpreter','latex');
    %             axis off;
            ax(2) = subplot(sp_vecs.Xsize,sp_vecs.Ysize,sp_vecs.YLabel);
                plot(0,0); set(gca,'XTick',[],'YTick',[]);
                yl = text(0,0,'YLabel','Rotation',90);
            for si = 1:sp_vecs.sb_num
                subplot(sp_vecs.Xsize,sp_vecs.Ysize,sp_vecs.(['sp',num2str(si)]));
                    plot(0,0); set(gca,'XTick',[],'YTick',[]);
                    text(0,0,['sp',num2str(si)]);
            end
    %         tightfig;
    end
            
            
    
    
    
        