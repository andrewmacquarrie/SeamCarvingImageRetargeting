function [J,S,xp] = seamShrink(J,wnew,W,p)

M = rgb2gray(J);
 
S = zeros(size(J,1),size(J,2));
n = size(J,2)-wnew;
if nargout==3
    xp = zeros(size(J,1),n);
%   energy = zeros(1,n);
end
for i=1:n
    fprintf(1,'Seam %d (%d)\n',i,n);

    [xpath,cost] = p.seamFunc(M,W,p);
    normEnergy = cost;%E(end,xpath(end))/length(xpath);
    if nargout==3
        xp(:,i) = xpath;
%       energy(i) = normEnergy;
    end

    % update
    J = seamRemove(J,xpath); % remove seam from original image
    M = seamRemove(M,xpath); % remove seam from work image
    W = seamRemove(W,xpath); % remove seam from weights
    S = updateSurvivalImage(S,xpath,normEnergy);
    
end;
