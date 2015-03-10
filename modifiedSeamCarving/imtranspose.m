function J = imtranspose(I)

for i=1:size(I,3)
   J(:,:,i)=I(:,:,i)'; 
end