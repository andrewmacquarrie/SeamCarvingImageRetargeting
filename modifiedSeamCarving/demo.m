
% Seam-Carving demo.
% Current version works with 3-channel images. If you input a 1-channel
% image, it automatically replicates it to a 3-channel image
%
% This code is based on the paper:
% 
% Improved Seam Carving for Video Retargeting
% Michael Rubinstein, Ariel Shamir, Shai Avidan
% ACM Transactions on Graphics, Volume 27, Number 3 SIGGRAPH 2008
% 
% Michael Rubinstein, IDC 2008

imagename = 'waterfall_small.png';

%--- Parameters

p.piecewiseThresh = 9e9; % threshold for piecewise-connected seams (see seamConstructPathPiecewise). Set to very large value to ignore
p.method = 'forward'; % 'backward' or 'forward'
p.seamFunc = @seamPath_dp; % @seamPath_dp for dynamic programming, @seamPath_gcut for graph-cut
p.s = 1; % permissible seam step (used by seamPath_dp)
p.errFunc.name = @errL1; % error function (used by backward energy)
p.errFunc.weightNorm = @errWeightAdd; % function for incorporating additional weight map (used by backward energy)

%--- Run

I = im2double(imread(imagename));
nChannels=size(I,3);
if (nChannels == 1)
    I = repmat(I,[1,1,3]);
end
[height,width,nChannels] = size(I);

% target size (change either width or height, but not both).
% maintain target size within bounds of the image, otherwise will cause 
% an index out of bounds error.
new_width = floor(.75*width);        
new_height = height;
% J is the retargeted image, S is the seams map
[J,S] = imretarget(I,[new_height,new_width],[],p);

figure; imshow(I); title('Input');
figure; imshow(J); title('Retarget');
figure; imshow(seamOverlay(I,S)); title('Seams');

