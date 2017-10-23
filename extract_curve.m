reload = 0;

if reload
files = dir('*.tif');
num = length(files);

% Get size
img = imread(files(1).name);
[n,m] = size(img);
diam = zeros(num,m);

for ii=1:num
    disp(['ii = ',int2str(ii),'/',int2str(num)]);
    img = imread(files(ii).name);
    BW = edge(img,'Canny');

    % Extract curve as a function of horizontal pixel number
    for jj=1:m
        inds = find(BW(:,jj)==1);
        if length(inds) > 1
            diam(ii,jj) = max(inds)-min(inds);%n-min(inds);
        else
            diam(ii,jj) = nan;
        end
    end

    % Now interpolate to fill in nans
    for jj=1:m
        if isnan(diam(ii,jj))
           diam(ii,jj) = interp1([1:m],diam(ii,:),jj,'spline'); 
        end
    end
end
%Re-check for nans
% for ii=1:num
%     for jj=1:m
%         if isnan(diam(ii,jj))
%            diam(ii,jj) = interp1([1:m],diam(ii,:),jj,'spline'); 
%         end
%     end
% end
end

L = 5.08/187*0.94; % in cm
T = 1; % in s
z = L*[0:m-1];
t = T*[0:num-1];
A = pi*(0.5*diam*L/10).^2;
figure(1);
clf();
contourf(z,t,A,40,'edgecolor','none');
set(gca,'fontsize',16,'fontname','times');
title('DSW-DSW, Trial 3, 4/18/14');
xlabel('{\itz} (cm)');
ylabel('{\itt} (s)');
caxis([0.008,0.38]);

% Load the cool-warm colormap
cmap = load('CoolWarmFloat257.csv');
colormap(cmap);
%caxis([1,90]*L/10);
ch=colorbar();
set(get(ch,'ylabel'),'string','{\itA} (cm^2)','fontsize',16,...
    'fontname','times');


figure(2);
clf();
contourf(z,t,A,40,'edgecolor','none');
axis([30,65,45,150]);
caxis([0.02,0.2]);
set(gca,'fontsize',16,'fontname','times');
title('DSW-DSW, Trial 3, 4/18/14');
xlabel('{\itz} (cm)');
ylabel('{\itt} (s)');

% Load the cool-warm colormap
cmap = load('CoolWarmFloat257.csv');
colormap(cmap);
%caxis([1,90]*L/10);
ch=colorbar();
set(get(ch,'ylabel'),'string','{\itA} (cm^2)','fontsize',16,...
    'fontname','times')