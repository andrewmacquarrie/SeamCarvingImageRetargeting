function rearrangeImageBasedOnClicks()

importance_of_saliency_in_seam_carving = 0.1;

surface_good = 0.8;
surface_okay = 0.4;
surface_bad = 0.01;

%--- Parameters

p.piecewiseThresh = 9e9; % threshold for piecewise-connected seams (see seamConstructPathPiecewise). Set to very large value to ignore
p.method = 'forward'; % 'backward' or 'forward'
p.seamFunc = @seamPath_dp; % @seamPath_dp for dynamic programming, @seamPath_gcut for graph-cut
p.s = 1; % permissible seam step (used by seamPath_dp)
p.errFunc.name = @errL1; % error function (used by backward energy)
p.errFunc.weightNorm = @errWeightAdd; % function for incorporating additional weight map (used by backward energy)


addpath('../../saliency/gbvs/');
addpath('../../retargeting/seam_carving-1.0/');
% img = im2double(imread('deer-301915_1280.jpg'));
img = im2double(imread('ccAppleWhite.png'));

img = imresize(img, 0.5);

[sizey, sizex, sizez] = size(img);

map = gbvs(img);
MM = map.master_map_resized;
W = MM .* importance_of_saliency_in_seam_carving;



% show_imgnmap( img , map );

% display_surface = repmat([surface_okay], sizey, sizex);
% display_surface(100:249,150:299) = repmat([surface_good], 150, 150);
% display_surface(400:499,400:499) = repmat([surface_bad], 100, 100);
% fake good calculation
gx = 300;
gy = 500;

[iy, ix] = ind2sub(size(MM),find(MM==(max(max(MM)))));

figure; imshow(img);
[ix,iy] = ginput(1);
[gx,gy] = ginput(1);

%varx = 100;
%vary = 100;
%new_image = im2double(zeros(sizey, sizex, sizez));
%new_image((gy - vary + 1):(gy + vary),(gx - varx + 1):(gx + varx),:) = img((iy-vary+1):(iy+vary), (ix-varx+1):(ix+varx), :);

lhs = img(:,1:ix,:);
rhs = img(:,ix+1:end,:);

[Nlhs,S1] = imretarget(lhs,[sizey,gx],W(:,1:ix,:),p);
[Nrhs,S2] = imretarget(rhs,[sizey,(sizex - gx)],W(:,ix+1:end,:),p); % testing adding weights
new_image = [Nlhs Nrhs];

top = new_image(1:iy,:,:);
bottom = new_image(iy+1:end,:,:);

[Ntop,S3] = imretarget(top,[gy,sizex],W(1:iy,:,:),p);
[Nbottom,S4] = imretarget(bottom,[(sizey - gy),sizex],W(iy+1:end,:,:),p);
new_image = [Ntop ; Nbottom];

figure;
subplot(1,3,1); show_imgnmap( img , map );

im1 = seamOverlayBlue(img,[S1 zeros(size(S2))]);
im2 = seamOverlayBlue(im1,[[S3 ; zeros(size(S4))]]);
im3 = seamOverlay(im2,[zeros(size(S1)) S2]);
im4 = seamOverlay(im3,[[zeros(size(S3)) ; S4]]);

subplot(1,3,2); imshow(im4);
subplot(1,3,3); imshow(new_image);
hold on;
scatter(ix,iy,'x');
scatter(gx,gy,'o');


x = 123;









