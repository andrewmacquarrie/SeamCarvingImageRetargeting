function retargetImage()

% makes use of Michael Rubinstein's seam carving implementation - available here: http://people.csail.mit.edu/mrub/
% makes use of Graph-Based Visual Saliency - available here: http://www.vision.caltech.edu/~harel/share/gbvs.php
% uses creative commons image: tpsdave, available from http://pixabay.com/en/deer-fawn-animal-forest-woods-301915/

importance_of_saliency_in_seam_carving = 0.1;
addpath(genpath('C:/Software/gbvs/'));
addpath('C:/Software/seam_carving-1.0/');

x_reduction = 10;
y_reduction = 0;

%--- Salience detector parameters
p.piecewiseThresh = 9e9; % threshold for piecewise-connected seams (see seamConstructPathPiecewise). Set to very large value to ignore
p.method = 'forward'; % 'backward' or 'forward'
p.seamFunc = @seamPath_dp; % @seamPath_dp for dynamic programming, @seamPath_gcut for graph-cut
p.s = 1; % permissible seam step (used by seamPath_dp)
p.errFunc.name = @errL1; % error function (used by backward energy)
p.errFunc.weightNorm = @errWeightAdd; % function for incorporating additional weight map (used by backward energy)

img = im2double(imread('deer-301915_1280.jpg'));
img = imresize(img, 0.5);
[sizey, sizex, sizez] = size(img);

map = gbvs(img);
MM = map.master_map_resized;
W = MM .* importance_of_saliency_in_seam_carving;

[retargIm, S1] = imretarget(img,[sizey - y_reduction,sizex - x_reduction],W,p);

figure;
subplot(1,3,1); show_imgnmap( img , map );

im1 = seamOverlayBlue(img, S1);
subplot(1,3,2); imshow(im1);

subplot(1,3,3); imshow(retargIm);