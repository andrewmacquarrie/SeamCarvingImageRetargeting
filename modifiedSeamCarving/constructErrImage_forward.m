function E = constructErrImage_forward(M,W,p)

% Constructs error map using forward energy (new formulation)
%
% Michael Rubinstein, IDC 2008

K = zeros(size(M,1),size(M,2)+2);

K(:,1) = 9e9; K(:,end) = 9e9;

% M = [M(:,2) M M(:,end-1)]; <-- This is the "ground truth"
M = [M(:,1) M M(:,end)];

K(1,2:end-1) = abs(M(1,3:end)-M(1,1:end-2));

for i=2:size(K,1),
    T(:,1) = K(i-1,1:end-2) + abs(M(i-1,2:end-1)-M(i,1:end-2))+abs(M(i,3:end)-M(i,1:end-2));
    T(:,2) = K(i-1,2:end-1) + abs(M(i,3:end)-M(i,1:end-2));
    T(:,3) = K(i-1,3:end)   + abs(M(i-1,2:end-1)-M(i,3:end))+abs(M(i,3:end)-M(i,1:end-2));
    K(i,2:end-1) = min(T,[],2);
    
    K(i,2:end-1) = K(i,2:end-1)+W(i,:);
%     T(:,1) = max(K(i-1,1:end-2),max(abs(M(i-1,2:end-1)-M(i,1:end-2)),abs(M(i,3:end)-M(i,1:end-2))));
%     T(:,2) = max(K(i-1,2:end-1),max(M(i,3:end)-M(i,1:end-2)));
%     T(:,3) = max(K(i-1,3:end),max(abs(M(i-1,2:end-1)-M(i,3:end)),abs(M(i,3:end)-M(i,1:end-2))));
%     K(i,2:end-1) = min(T,[],2);

%     for j=2:size(K,2)-1
%         K(i,j) = min([K(i-1,j-1) + abs(M(i-1,j)-M(i,j-1))+abs(M(i,j+1)-M(i,j-1)), ...
%                       K(i-1,j)   + abs(M(i,j+1)-M(i,j-1)), ...
%                       K(i-1,j+1) + abs(M(i-1,j)-M(i,j+1))+abs(M(i,j+1)-M(i,j-1))]);
%     end
end

E = K(:,2:end-1);

end