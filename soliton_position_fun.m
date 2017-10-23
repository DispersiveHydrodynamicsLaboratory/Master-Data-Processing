function[zs,zs_ps] = soliton_position_fun(wave_type,trapping,uminus,aminus,zminus,uplus,z0);
%% Code to solve for a soliton's position 
%% INPUTS
% uminus 	% Initial conduit mean
% aminus    % Initial soliton amplitude
% zminus    % RW starts at 0, soliton starts at -zminus
% uplus     % Final conduit mean
% z0        % Actual wave beginning

Am = uplus;
asoli = aminus;

%  as it travels up a rarefaction wave
debug_on = 0;
plot_on  = 0;

if strcmp(wave_type,'r')
    % Calculate q0 = q(c_s(a_-,u_-),u_-) based on initial soliton amplitude and initial conduit mean
    csoli  = @(a,m) m./a.^2 .* ( (a+m).^2 .* (2*log(1+a./m)-1) + m.^2);
    q      = @(cs,m) cs*(cs+2*m)/(4*m);
    q0     = q(csoli(aminus,uminus),uminus);

    % Ensure tunneling can happen
    cminus = csoli(aminus,uminus);
    cDSW   = -uminus + sqrt(uminus^2 + 8*uplus*uminus);
    if cminus <= cDSW
        disp('Tunneling criterion is not satisfied.');
        disp('Soliton will be trapped');
        trapped = 1;
    else
        trapped = 0;
    end

    % ODE right-hand side to be solved for the RW
    cs = @(q,m) -m+sqrt(m*(m+4*q0));

    % First part: calculate soliton position before interacting with the RW
        zsM = @(t) cs(q0,1)*t + zminus;

        % Calculate where soliton catches up with RW
        t1 = zminus/(2-cs(q0,1));
        z1 = 2*t1;
        disp(['Soliton reaches trailing edge of RW at t=',num2str(round(t1))]);

    % Second part: calculate soliton position throughout the RW
    if ~trapped
        % Calculate maximum possible time spent in the RW (based on initial speed)
        t2est = zminus/(2*uplus-cs(q0,1));
        if t2est<t1
            % Possible for this to not work
            disp('Initial guess: tunneling ends at t2 = t1 + 250');
            t2est = t1+250;
        else
            disp(['Initial guess: tunneling ends at t2 = ',num2str(round(t2est))]);
        end
    else
        t2est = t1+250;
        disp(['Will track soliton through RW for 250 (ND time), for a total time of ',num2str(round(t2est))]);
    end

        % Use ODE 45 to solve the "hard part"- RW
        [tout,zsout] = ode45(@(t,zs) cs(q0,zs/(2*t)), [t1,t2est], z1);
        zsRW = @(t) interp1(tout,zsout,t,'spline','extrap');

        if debug_on
            % Plot for debugging
            figure(1); clf;
                plot(tout,real(zsout));
                if sum(imag(zsout))>0
                    hold on;
                        plot(tout,imag(zsout),'r--');
                    hold off
                end
        end
        if ~trapped
            % Find where this solution actually intersects leading edge of RW
            t2 = fzero(@(t) zsRW(t)-2*uplus*t, t2est);
            t2ctr = 0;
                % If had to extrapolate madly, run ODE solver again
                while (t2-t2est) > 1 & t2ctr < 100
                    t2est = t2+10;
                    [tout,zsout] = ode45(@(t,zs) cs(q0,zs/(2*t)), [t1,t2est], z1);
                        binds = find(isnan(zsout));
                        ginds = setdiff(1:length(zsout),binds);
                    zsRW = @(t) interp1(tout(ginds),zsout(ginds),t,'spline','extrap');
                    t2 = fzero(@(t) zsRW(t)-2*uplus*t, t2est);
                    t2ctr = t2ctr + 1;
                end
                zsRW = @(t) interp1(tout,zsout,t,'spline',0);
                z2 = 2*uplus*t2;
                disp(['Soliton is through the RW at t=',num2str(round(t2))]);
            % Third part: calculate soliton position after interaction with RW
                zsP = @(t) cs(q0,uplus)*(t-t2) + z2;
        else
            t2 = t2est; 
            zsRW = @(t) interp1(tout,zsout,t,'spline','extrap');
        end


    % Combine all parts together to get full solution
    if ~trapped
        zs1 = @(t) zsM(t) .* (t<=t1)       +...
                  zsRW(t).* (t>t1 & t<t2) +...
                  zsP(t) .* (t>=t2);
    else
        zs1 = @(t) zsM(t) .* (t<=t1)       +...
                  zsRW(t).* (t>=t1);
    end

    if plot_on
        % Plot results
        figure(2); clf;
            tplot = 0:0.01:(t2+75);
            plot(tplot,zs1(tplot));
            hold on;
                plot(t1,z1,'b*',t2,z2,'rx');
            xlabel('t'); ylabel('z_s(t)');
    end

    tmax = t2+75;
    zs = @(t) zs1(t)-zminus+z0;
    
elseif strcmp(wave_type,'d')
        % Use phase shift theory to find trajectory
    csoli  = @(a,m) m./a.^2 .* ( (a+m).^2 .* (2*log(1+a./m)-1) + m.^2);
    if ~trapping
        [krat, newc] = ST_phase_shifts(Am, 1, csoli(asoli,Am));
            ps     = zminus*(1-krat);
            zs1     = @(t) (csoli(asoli,Am)*t + zminus) ;
            zs2     = @(t) (newc*t            + zminus - ps);
    else
        [krat, newc] = ST_phase_shifts(Am, 1, csoli(asoli,1));
            ps     = zminus*(1-krat);
            zs1     = @(t) (csoli(asoli,1)*t + zminus) ;
            zs2     = @(t) (newc*t            + zminus - ps);
    end
    if trapping
        zs = @(t) zs1(t)-zminus+z0;
    else
        zs    = @(t) zs2(t)-zminus+z0;
        zs_ps = @(t) zs1(t)-zminus+z0;
    end

% [foo,zm] = min(abs(max(zplot)-(zs1(t)-zminus+z0)));
% zm = zm-5;
% f1 = figure(1); clf;
%     contourf(zplot,t(1:end-5),A_full(1:end-5,:),100,'edgecolor','none');
%         cmap = load('CoolWarmFloat257.csv');
%         colormap(cmap); 
%         xlabel('z'); ylabel('t'); colorbar;
%     hold on;
%     if ~trapping | ~ trap_lines
%         plot(zs1(t(1:zm))-zminus+z0,t(1:zm),'k--','LineWidth',0.25);
%         if ~ trapping
%              plot(zs2(t(1:zm))-zminus+z0,t(1:zm),'k--','LineWidth',0.25);
%         end
%     end
else
    error('Incorrect wave type. Please input r for RW, d for DSW');
end

if ~exist('zs_ps','var')
    zs_ps = [];
end
disp('');