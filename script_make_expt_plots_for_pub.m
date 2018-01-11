%% Wrapper script for making experimental publication plots
% close all;
% Find directory dynamically
dirparts = strsplit(pwd, '/');
updir = [];
for pi = 1:length(dirparts)-1
    updir = [updir, dirparts{pi}, filesep];
end
disp(['Processing from directory: ',updir]);

slant = filesep;

loadmat = 1; % Set to 1 to load in edge data, 0 to reformat data
runfigs = [1 0 0 1]; % [Trial01, Trial02, Trial03, Trial04]
extra_dir = 'full_cam';

if runfigs(1)
    % DSW tunneling
    tscript = 'Trial01';
    quants = load([updir,slant,'quantities.mat']); % NEEDS CHANGED
    sourcedir1 = [updir,tscript,slant,extra_dir,slant];
    figname = tscript;
        tmin = 90;   % Set to 0 to use first time
        tmax = Inf; % Set to Inf to use last time 
        if tmax == Inf
            load([sourcedir1,'img_timestamps.mat'],'T');
            tmax = max(T)-min(T);
        end
        snaptimes = [90 170 250 288];
            snaplim = 210;
            snapw   = 150;
%         spa = [ {'(e)'}, {'(f)'} ];
        zmin = 0;   % Set to 0 to begin as close to nozzle as possible
        zmax = 105; % Set to Inf to maximize upper conduit
        cmin = 1;
        cred = 0;
        cmax = 7; % Set to Inf to maximize conduit area
            fh1name = [pwd,slant,figname,'_snaps'];
            fh2name = [pwd,slant,figname,'_contour'];
            [fh1, fh2] = make_expt_plots_for_pub(sourcedir1,loadmat,quants,...
                                tmin,tmax,zmin,zmax,cmin,cred,cmax,...
                                snaptimes,[snaplim snaplim+snapw 5],...
                                1,fh1name,fh2name,slant);%,spa);
end

if runfigs(2)
    % RW tunneling
    tscript = 'Trial02';
    quants = load([updir,slant,'quantities.mat']); % NEEDS CHANGED
    sourcedir2 = [updir,tscript,slant,extra_dir,slant];
    figname = tscript;
        tmin = 0;   % Set to 0 to use first time
        tmax = Inf; % Set to Inf to use last time 
        if tmax == Inf
            load([sourcedir2,'img_timestamps.mat'],'T');
            tmax = max(T)-min(T);
        end
        snaptimes = linspace(tmin,tmax,6);
            snaplim = 210;
            snapw   = 150;
%         spa = [ {'(e)'}, {'(f)'} ];
        zmin = 0;   % Set to 0 to begin as close to nozzle as possible
        zmax = Inf; % Set to Inf to maximize upper conduit
        cmin = 0.9;
        cred = 2.5;
        cmax = 5; % Set to Inf to maximize conduit area
            fh1name = [pwd,slant,figname,'_snaps'];
            fh2name = [pwd,slant,figname,'_contour'];
            [fh1, fh2] = make_expt_plots_for_pub(sourcedir2,loadmat,quants,...
                                tmin,tmax,zmin,zmax,cmin,cred,cmax,...
                                snaptimes,[snaplim snaplim+snapw 5],...
                                1,fh1name,fh2name,slant);%,spa);
end

if runfigs(3)
    % DSW tunneling
	tscript = 'Trial03';
    quants = load([updir,slant,'quantities.mat']); % NEEDS CHANGED
    sourcedir3 = [updir,tscript,slant,extra_dir,slant];
    figname = tscript;
        tmin = 30;   % Set to 0 to use first time
        tmax = Inf; % Set to Inf to use last time 
        if tmax == Inf
            load([sourcedir3,'img_timestamps.mat'],'T');
            tmax = max(T)-min(T);
        end
        snaptimes = linspace(tmin,tmax,6);
            snaplim = 210;
            snapw   = 150;
%         spa = [ {'(e)'}, {'(f)'} ];
        zmin = 0;   % Set to 0 to begin as close to nozzle as possible
        zmax = 100; % Set to Inf to maximize upper conduit
        cmin = 1;
        cred = 0;
        cmax = Inf; % Set to Inf to maximize conduit area
            fh1name = [pwd,slant,figname,'_snaps'];
            fh2name = [pwd,slant,figname,'_contour'];
            [fh1, fh2] = make_expt_plots_for_pub(sourcedir3,loadmat,quants,...
                                tmin,tmax,zmin,zmax,cmin,cred,cmax,...
                                snaptimes,[snaplim snaplim+snapw 5],...
                                1,fh1name,fh2name,slant);%,spa);
end
  
if runfigs(4)
    % RW Tunneling
    tscript = 'Trial04';
    quants = load([updir,slant,'quantities.mat']); % NEEDS CHANGED
    sourcedir4 = [updir,tscript,slant,extra_dir,slant];
    figname = tscript;
        tmin = 0;   % Set to 0 to use first time
        tmax = Inf; % Set to Inf to use last time 
        if tmax == Inf
            load([sourcedir4,'img_timestamps.mat'],'T');
            tmax = max(T)-min(T);
        end
        snaptimes = [0 35 80 210];
            snaplim = 210;
            snapw   = 150;
%         spa = [ {'(e)'}, {'(f)'} ];
        zmin = 0;   % Set to 0 to begin as close to nozzle as possible
        zmax = 130; % Set to Inf to maximize upper conduit
        cmin = 0.9;
        cred = 0;
        cmax = 8; % Set to Inf to maximize conduit area
            fh1name = [pwd,slant,figname,'_snaps'];
            fh2name = [pwd,slant,figname,'_contour'];
            [fh1, fh2] = make_expt_plots_for_pub(sourcedir4,loadmat,quants,...
                                tmin,tmax,zmin,zmax,cmin,cred,cmax,...
                                snaptimes,[snaplim snaplim+snapw 5],...
                                3,fh1name,fh2name,slant);%,spa);
end

