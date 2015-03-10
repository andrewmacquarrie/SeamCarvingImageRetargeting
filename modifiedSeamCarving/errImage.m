function G = errImage(I,W,errFunc)

if size(I,3)==3
    M = rgb2gray(I);
else
    M = I;
end;

G = errFunc.name(M);  

% Add weights
if ~isempty(errFunc.weightNorm)
    G = errFunc.weightNorm(G,W);   
end;

return;