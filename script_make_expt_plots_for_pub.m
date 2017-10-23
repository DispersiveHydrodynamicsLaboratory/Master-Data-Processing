%% Wrapper script for making experimental publication plots
% close all;
if strcmp(computer,'MACI64')
    updir = '/Volumes/APPM-DHL/';
    slant = '/';
else
    updir = 'D:\';
    slant = '\';
end

loadmat = 1; % Set to 1 to load in edge data, 0 to reformat data
runfigs = [1 1 1 1]; % [DSW_tunn, RW_tunn, RW_trap, DSW_trap]

if runfigs(1)
    % DSW tunneling
    quants = load([updir,'ST4',slant,'quantities.mat']); % NEEDS CHANGED
    sourcedir1 = [updir,'ST4',slant,'Trial05',slant];
    figname = 'dsw_tunneling';
        tmin = 100;   % Set to 0 to use first time
        tmax = 300; % Set to Inf to use last time 
        if tmax == Inf
            load([sourcedir1,'img_timestamps.mat'],'T');
            tmax = max(T)-min(T);
        end
        snaps = [100 150 230 280];
            snaplim = 210;
            snapw   = 150;
%         spa = [ {'(e)'}, {'(f)'} ];
        zmin = 3;   % Set to 0 to begin as close to nozzle as possible
        zmax = 126; % Set to Inf to maximize upper conduit
        cmin = 1;
        cred = 0;
        cmax = Inf; % Set to Inf to maximize conduit area
            fh1name = [pwd,slant,figname,'_snaps'];
            fh2name = [pwd,slant,figname,'_contour'];
            [fh1, fh2] = make_expt_plots_for_pub(sourcedir1,loadmat,quants,...
                                tmin,tmax,zmin,zmax,cmin,cred,cmax,...
                                snaps,[snaplim snaplim+snapw 5],...
                                1,fh1name,fh2name,slant);%,spa);
end

if runfigs(2)
    % RW tunneling
    sourcedir2 = [updir,'ST4',slant,'Trial02',slant];
    quants = load([updir,'ST4',slant,'quantities.mat']); % NEEDS CHANGED
    figname = 'rw_tunneling';
        tmin = 0;   % Set to 0 to use first time
        tmax = Inf; % Set to Inf to use last time 
        if tmax == Inf
            load([sourcedir2,'img_timestamps.mat'],'T');
            tmax = max(T)-min(T);
        end
        snaps = [10 40 80 120];

        zmin = 3;   % Set to 0 to begin as close to nozzle as possible
        zmax = Inf; % Set to Inf to maximize upper conduit
        cmin = 0;
        cred = 2.5;
        cmax = 6; % Set to Inf to maximize conduit area
            fh1name = [pwd,slant,figname,'_snaps'];
            fh2name = [pwd,slant,figname,'_contour'];
            snaplim = 115;
            snapw   = 150;
            [fh1, fh2] = make_expt_plots_for_pub(sourcedir2,loadmat,quants,...
                                tmin,tmax,zmin,zmax,cmin,cred,cmax,...
                                snaps,[snaplim snaplim+snapw 2],...
                                1,fh1name,fh2name,slant);
end

if runfigs(3)
    % RW trapping
    sourcedir3 = [updir,'ST3',slant,'Trial13',slant];
    quants = load([updir,'ST3',slant,'quantities.mat']); 
    figname = 'rw_trapping';
        tmin = 0;   % Set to 0 to use first time
        tmax = 200; % Set to Inf to use last time 
        if tmax == Inf
            load([sourcedir3,'img_timestamps.mat'],'T');
            tmax = max(T)-min(T);
        end
        snaps = [15 30 100 170];linspace(tmin,tmax,4);
        zmin = 2;   % Set to 0 to begin as close to nozzle as possible
        zmax = 120; % Set to Inf to maximize upper conduit
        cmin = 1;
        cred = 3;
        cmax = 7; % Set to Inf to maximize conduit area
            snaplim = 250;
            snapw   = 150;

            fh1name = [pwd,slant,figname,'_snaps'];
            fh2name = [pwd,slant,figname,'_contour'];
            [fh1, fh2] = make_expt_plots_for_pub(sourcedir3,loadmat,quants,...
                                tmin,tmax,zmin,zmax,cmin,cred,cmax,snaps,...
                                [snaplim snaplim+snapw 2],1,fh1name,fh2name,slant);
end
  
if runfigs(4)
    % DSW trapping
    sourcedir4 = [updir,'ST3',slant,'Trial12',slant];
    quants = load([updir,'ST3',slant,'quantities.mat']); 
    figname = 'dsw_trapping';
        tmin = 80;   % Set to 0 to use first time
        tmax = 300; % Set to Inf to use last time 
        zmin = 5;   % Set to 0 to begin as close to nozzle as possible
        zmax = 120; % Set to Inf to maximize upper conduit
        cmin = 1;
        cred = 0;
        cmax = Inf; % Set to Inf to maximize conduit area

        if tmax == Inf
            load([sourcedir4,'img_timestamps.mat'],'T');
            tmax = max(T)-min(T);
        end
        snaps = [100 150 200 250];
            fh1name = [pwd,slant,figname,'_snaps'];
            fh2name = [pwd,slant,figname,'_contour'];
            [fh1, fh2] = make_expt_plots_for_pub(sourcedir4,loadmat,quants,...
                                tmin,tmax,zmin,zmax,cmin,cred,cmax,snaps,[250 360 2],1,fh1name,fh2name,slant);
end

