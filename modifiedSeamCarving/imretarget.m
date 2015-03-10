function [J,S,xp] = imretarget(I,s,W,p)

% One-dimensionally retargets an image using the Seam-Carving algorithm.
% input:
%   I - input image
%   s - target size [height,width] (should differ from size(I) in one
%   dimension only)
%   W - additional weight map
%   p - parameters structure (see demo.m for more details)
% output:
%   J - the retargeted image
%   S - seam map: S(S==i) = seam removed at iteration i
%
% Michael Rubinstein, IDC 2008


if ~isa(I,'double')
    I=im2double(I);
end

[h,w,c] = size(I);
hnew=s(1); wnew=s(2);

if nargin<3 | isempty(W)
    W = zeros(h,w);
end
if nargin<4 | isempty(p) % some default setting
    p.piecewiseThresh = 9e9;
    p.method = 'forward';
    p.seamFunc = @seamPath_dp;
    p.s = 1;
    p.errFunc.name = @errL1;
    p.errFunc.weightNorm = @errWeightAdd;
end

% support one dimension
if (hnew~=h)
    I = imtranspose(I);
    W = W';
    w = h; wnew = hnew;
end

if (wnew <= w)
    [J,S,xp] = seamShrink(I,wnew,W,p);
else
    [J,S,xp] = seamExpand(I,wnew,W,p);
end

% transpose back
if (hnew~=h)
    J = imtranspose(J);
    S = imtranspose(S);
end

