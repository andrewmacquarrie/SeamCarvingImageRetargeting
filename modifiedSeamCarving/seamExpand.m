function [J,S,xp] = seamExpand(J,wnew,W,p)

n=wnew-size(J,2);
fprintf('Preprocessing...\n');
[JJ,S,xp] = seamShrink(J,size(J,2)-n,W,p);

% Expand seams
fprintf('Expanding...\n');
for i=1:n
    fprintf(1,'Expanding Seam %d (%d)\n',i,n); 
   
    xpath = expand(xp(:,1:i)');

    % Create path image
    P = zeros(size(J(:,:,1)));
    idx=sub2ind(size(P),1:length(xpath),xpath);
    P(idx) = 1;

    J = seamAdd(J,P);

end;


function xpath = expand(xp)

for i=1:size(xp,2),
    xpath(i) = xp(end,i) + 2*sum( xp(end,i)>=xp(1:end-1,i) );
end;
