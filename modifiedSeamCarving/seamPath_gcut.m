function [xpath,cost] = seamPath_gcut(m,W,p)

% Optimal seam using graph-cut.
% Currently supports backward energy only, but can be easily extended for
% forward energy. 
% Note that multiscale graph-cut is not implemented here, so this function
% will be SLOW. Make sure to use it on small images only!
%
% Michael Rubinstein, IDC 2008

[height,width]=size(m);
N=height*width;

G = errImage(m,W,p.errFunc);

% construct graph

% connect forward horizontally
us = [1:N-height]';
vs = us+height;
U=us; V=vs;
E=G(U)+eps;

% connect diagonally
[x,y]=meshgrid(1:width,1:height);
x=x(:)'; y=y(:)';
vy=[y-1;y+1]; vy=vy(:);
vx=[x-1;x-1]; vx=vx(:);
inBounds=vy>=1 & vy<=height & vx>=1;
% create repeating sequence (each node is connect backward using two edges)
xx=[x;x]; xx=xx(:); 
yy=[y;y]; yy=yy(:);
us=sub2ind(size(m),yy(inBounds),xx(inBounds));
vs=sub2ind(size(m),vy(inBounds),vx(inBounds));
U=[U;us]; V=[V;vs];
E=[E;ones(length(us),1)*9e9];

A = sparse(U,V,E,N,N,4*N);

% terminal weights
% connect source to leftmost column.
% connect rightmost column to target.
T = sparse([1:height;N-height+1:N]',[ones(height,1);ones(height,1)*2],ones(2*height,1)*9e9);

[cost,labels] = maxflow(A,T);
labels = reshape(labels,[height width]);

% find crossing point at each row
xpath=zeros(height,1);
for i=1:height
    dif=diff(labels(i,:));
    if sum(dif)>1
        error('non-monotonic seam!');
    end
    if width==1
        xpath(i)=1;
    else
        xpath(i)=find(dif);
    end
end

