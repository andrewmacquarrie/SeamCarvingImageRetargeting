function S = updateSurvivalImage(S,xpath,err)

if nargin==2
    err = 1;
end;

v = max(S(:))+err;

for i=1:length(xpath),
    idx = find(S(i,:)==0);
    S(i,idx(xpath(i))) = v;
end;

return;