% This script is for trying various methods for extracting conduit edges
turn_off_warnings;
picnum = 50;
trialnum = '15';
diam_scale = 1;%29.5873;
% Parameters
    hfac = 5; % Factor to increase the size in the horizontal direction
%     pix = [1024]; % Number of pixels in horizontal direction
%     tfac = 12;  % Speedup in time
    myrect = [275       14222/5*hfac        5447         544/5*hfac]; %Trial 13
    rotation = -60;  % Rotation angle to apply to all images
	vlengthscale = 30/1279.92; % Vertical (axial) length scale in cm/pixel, ; % Vertical (axial) length scale in cm/pixel, 
    theta = 1.5665/5*hfac; % post-stretching rotation factor
    %% HALF-SIZED
    rect_rotated = [ 24         245/5*hfac        5000         230/5*hfac]; % post-stretching cropping rectangle
    fontsize = 10; % Fontsize for length and time scales
% Get all tif files in source directory
    img_files = glob(['\Volumes\APPM-DHL\Trial15\TIFF\*.tif']);    

% Image processing/resizing
    pic = fullfile(img_files(picnum));
    pic = pic{1};
    % Load, convert to grayscale, rotate, and resize
    img = imrotate(rgb2gray(imread(pic)),rotation);
    sz = size(img);
    img = imresize(img,[sz(1)*hfac,sz(2)]);
    img = imcrop(img,myrect);
    imgrot = imrotate(img,theta,'bicubic');
    img = imcrop(imgrot,rect_rotated);
            
% Extract and smooth conduit edges
    [el,er] = get_conduit_edges(img',2*hfac,'deriv');
	[els,ers] = smooth_conduit_edges_large_dsw(el,er);
    [f1, f2, ax1] = imshow_edges_horiz(img,els/diam_scale,ers/diam_scale,1,'Derivative method, Smoothing');
    [el,er] = get_conduit_edges(img',2*hfac,'mp');
    [els,ers] = smooth_conduit_edges_large_dsw(el,er);
    [f3, f4, ax2] = imshow_edges_horiz(img,els/diam_scale,ers/diam_scale,3,'Midpoint method, Smoothing');
%     [el,er] = get_conduit_edges(img',2*hfac,'mpinterp');
%     [els,ers] = smooth_conduit_edges_large_dsw(el,er);
%     [f5, f6, ax3] = imshow_edges_horiz(img,els,ers,5,'Midpoint method (interpolation), Smoothing');

    linkaxes([ax1(1), ax2(1)],'xy'); %, ax3(1)
    linkaxes([ax1(2), ax2(2)],'xy'); %, ax3(2)
    
    
    