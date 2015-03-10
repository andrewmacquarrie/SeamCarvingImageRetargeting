function J = seamOverlay(I,S)

J=I;
if (size(S,2)==1)
    Y = (1:length(S))';
    X = S;
else
    [Y,X]=find(S~=0);
end
if ndims(J)==3
    J(sub2ind(size(J),Y,X,ones(length(Y),1)*1)) = 1;
    J(sub2ind(size(J),Y,X,ones(length(Y),1)*2)) = 0;
    J(sub2ind(size(J),Y,X,ones(length(Y),1)*3)) = 0;
else
    J(sub2ind(size(J),Y,X))= 1;
end