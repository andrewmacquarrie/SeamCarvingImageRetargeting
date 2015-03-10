function [X,Y] = fastgradient(M)

T = padarray(M,[1,1],'replicate','both');

X = .5*(T(2:end-1,3:end)-T(2:end-1,1:end-2));
Y = .5*(T(3:end,2:end-1)-T(1:end-2,2:end-1));

return;