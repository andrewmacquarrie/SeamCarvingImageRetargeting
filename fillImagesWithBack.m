function fillImagesWithBlack(filename_format, cols_to_add, num_ims)

filename_format = 'outputImages/outputFile%06d.png';

for i = 1:num_ims
   filename = sprintf(filename_format,i);
   img = imread(filename);
   [y, x, z] = size(img);
   img = [img zeros(y, cols_to_add, z)];
   imwrite(img, filename);
end

