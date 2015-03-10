function G = errL1(M)

% Compute L1 error norm
[X,Y] = fastgradient(M);
G = abs(X)+abs(Y);

return;