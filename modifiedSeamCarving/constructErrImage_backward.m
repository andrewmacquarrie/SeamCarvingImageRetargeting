function E = constructErrImage_backward(M,W,p)

% Constructs error map using backward energy (original formulation)
%
% Michael Rubinstein, IDC 2008

G = errImage(M,W,p.errFunc);
s = p.s;

% Error image
K = 9e9*ones(size(G,1),size(G,2)+2*s);
x1 = 1+s;
x2 = x1+size(G,2)-1;
K(:,x1:x2) = G;

% Dynamic Programming image
E = 9e9*ones(size(K));
E(1,x1:x2) = G(1,:);

for i=2:size(E,1),
    for j=-s:s,
        T(j+s+1,:) = E(i-1,x1+j:x2+j);
    end
    E(i,x1:x2) = K(i,x1:x2) + min( T );
end

E = E(:,x1:x2);

return;

