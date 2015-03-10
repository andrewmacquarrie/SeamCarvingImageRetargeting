function J = seamAdd( J, P )

JJ = zeros(size(J,1),size(J,2)+1,size(J,3));
for j=1:size(J,3),
    for k=1:size(J,1),
        x = find(P(k,:)==1);
        xm = max(x-1,1);
        xp = min(x+1,size(J,2));
        JJ(k,:,j) = [J(k,1:x-1,j) 0.5*(J(k,xm,j)+J(k,x,j)) 0.5*(J(k,x,j)+J(k,xp,j)) J(k,x+1:end,j)];
    end;
end;
J = JJ;

return;