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
runfigs = [0 0 1 0]; % [DSW_tunn, RW_tunn, RW_trap, DSW_trap]

if runfigs(1)
    % DSW tunneling
    sourcename = 'soli_DSW_tunneling';
    sourcefile = [pwd,slant,sourcename,'.mat'];
    figname = 'num_dsw_tunneling';
        tmin = 0;   % Set to 0 to use first time
        tmax = 275; % Set to Inf to use last time 
        zmin = 0;   % Set to 0 to begin as close to nozzle as possible
        zmax = 1400; % Set to Inf to maximize upper conduit
        trajmin = 0; % Min of trajectory line
        trajmax = tmax; % Max of trajectory line
            % Variables for trajectory function
            wave_type = 'd'; trapping = 0;
            load(['parameters_',sourcename],'zminus','z0','uplus','asoli');
            [zs,zsps] = soliton_position_fun(wave_type,trapping,1,asoli,zminus,uplus,z0);
        cmin = 1;
        cred = 0;
        cmax = Inf; % Set to Inf to maximize conduit area
            fhname = [pwd,slant,figname,'_contour'];
            [fh]   = make_num_plots_for_pub(sourcefile,tmin,tmax,...
                            zmin,zmax,cmin,cred,cmax,...
                            zs,zsps,trajmin,trajmax,...
                            1,fhname,slant);
end

if runfigs(2)
    % RW tunneling
	sourcename = 'soli_RW_tunneling';
    sourcefile = [pwd,slant,sourcename,'.mat'];
    figname = 'num_rw_tunneling';
        tmin = 0;   % Set to 0 to use first time
        tmax = 175; % Set to Inf to use last time 
        zmin = 50;   % Set to 0 to begin as close to nozzle as possible
        zmax = 950; % Set to Inf to maximize upper conduit
        cmin = 0;
        cred = 3;
        cmax = Inf; % Set to Inf to maximize conduit area
        trajmin = 0; % Min of trajectory line
        trajmax = tmax-5; % Max of trajectory line
            % Variables for trajectory function
            wave_type = 'r'; trapping = 0;
            load(['parameters_',sourcename],'zminus','z0','uplus','asoli');
            [zs,zsps] = soliton_position_fun(wave_type,trapping,1,asoli,zminus,uplus,z0);

            fhname = [pwd,slant,figname,'_contour'];
            [fh]   = make_num_plots_for_pub(sourcefile,tmin,tmax,...
                            zmin,zmax,cmin,cred,cmax,...
                            zs,zsps,trajmin,trajmax,...
                            1,fhname,slant);
end

if runfigs(3)
    % RW trapping
	sourcename = 'soli_RW_trapping';
    sourcefile = [pwd,slant,sourcename,'.mat'];
    figname = 'num_rw_trapping';
        tmin = 0;   % Set to 0 to use first time
        tmax = 248; % Set to Inf to use last time 
        zmin = 200;   % Set to 0 to begin as close to nozzle as possible
        zmax = 975; % Set to Inf to maximize upper conduit
        cmin = 1;
        cred = 0;
        cmax = Inf; % Set to Inf to maximize conduit area
        trajmin = 0; % Min of trajectory line
        trajmax = tmax-10; % Max of trajectory line
            % Variables for trajectory function
            wave_type = 'r'; trapping = 1;
            load(['parameters_',sourcename],'zminus','z0','uplus','asoli');
            [zs,zsps] = soliton_position_fun(wave_type,trapping,1,asoli,zminus,uplus,z0);

            fhname = [pwd,slant,figname,'_contour'];
            [fh]   = make_num_plots_for_pub(sourcefile,tmin,tmax,...
                            zmin,zmax,cmin,cred,cmax,...
                            zs,zsps,trajmin,trajmax,...
                            1,fhname,slant);
end
  
if runfigs(4)
    % DSW trapping
    sourcename = 'soli_DSW_trapping';
    sourcefile = [pwd,slant,sourcename,'.mat'];
    figname = 'num_dsw_trapping';
        tmin = 0;   % Set to 0 to use first time
        tmax = 450; % Set to Inf to use last time 
        zmin = 0;   % Set to 0 to begin as close to nozzle as possible
        zmax = 1400; % Set to Inf to maximize upper conduit
        cmin = 1;
        cred = 0;
        cmax = 4; % Set to Inf to maximize conduit area
        trajmin = 0; % Min of trajectory line
        trajmax = tmax; % Max of trajectory line
%             % Variables for trajectory function
%             wave_type = 'd'; trapping = 1;
%             load(['parameters_',sourcename],'zminus','z0','uplus','asoli');
%             [zs,zsps] = soliton_position_fun(wave_type,trapping,1,asoli,zminus,uplus,z0);
            zs = []; zsps = [];
            fhname = [pwd,slant,figname,'_contour'];
            [fh]   = make_num_plots_for_pub(sourcefile,tmin,tmax,...
                            zmin,zmax,cmin,cred,cmax,...
                            zs,zsps,trajmin,trajmax,...
                            1,fhname,slant);
end
