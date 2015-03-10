function [xpath,cost,E] = seamPath(M,W,p)

% Run Dynamic Programming to find optimal seam
if (strcmpi(p.method,'backward')==1)
    E = constructErrImage_backward(M,W,p);
elseif (strcmpi(p.method,'forward')==1)
    E = constructErrImage_forward(M,W,p);
end

% Reconstruct path
[xpath,cost] = seamConstructPathPiecewise(E,p.s,p.piecewiseThresh);

return;