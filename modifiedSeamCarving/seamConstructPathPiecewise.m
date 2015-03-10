function [xpath,cost] = seamConstructPathPiecewise(E,s,thresh)

% Traces back the given error map for the optimal seam path.
% Input:
%   E - error map
%   s - permissible seam step
%   thresh - if step > thresh, causes the seam to restart in current row 
%   (thus producing piecewise connected seams)
% output:
%   xpath - optimal seam
%   cost - seam cost
%
% Michael Rubinstein, IDC 2008

if nargin<2
    s = 1;
end;

if nargin<3
    thresh = 9e9;
end

xpath = zeros(size(E,1),1);
[cost,xpath(end)] = min(E(end,:));
for i=size(E,1)-1:-1:1,
    xmin = max(xpath(i+1)-s,1);
    xmax = min(xpath(i+1)+s,size(E,2));
    bias = eps*abs([xmin:xmax]-xpath(i+1));
    [m,xpath(i)] = min(E(i,xmin:xmax)+bias);
    step = m-E(i+1,xpath(i+1));
    if abs(step)>thresh
        [tmp,xpath(i)] = min(E(i,:));
        fprintf('restarting (step = %.2f)\n',step);
    else
        xpath(i) = xpath(i) + xmin-1;
    end
end;


end
