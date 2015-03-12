function retargetVideoBasic(video_file, salience_map, x_reduction,frame_to_skip,frames_to_process,createSeams)

% makes use of Michael Rubinstein's seam carving implementation - available here: http://people.csail.mit.edu/mrub/
% makes use of Graph-Based Visual Saliency - available here: http://www.vision.caltech.edu/~harel/share/gbvs.php
% uses creative commons image: tpsdave, available from http://pixabay.com/en/deer-fawn-animal-forest-woods-301915/

scaleFactor = 1;
importance_of_saliency_in_seam_carving = 0.8;
% addpath(genpath('C:/Software/gbvs/'));
addpath('/Software/seam_carving-1.0');

%--- carving parameters
p.piecewiseThresh = 9e9; % threshold for piecewise-connected seams (see seamConstructPathPiecewise). Set to very large value to ignore
p.method = 'forward'; % 'backward' or 'forward'
p.seamFunc = @seamPath_dp; % @seamPath_dp for dynamic programming, @seamPath_gcut for graph-cut
p.s = 1; % permissible seam step (used by seamPath_dp)
p.errFunc.name = @errL1; % error function (used by backward energy)
p.errFunc.weightNorm = @errWeightAdd; % function for incorporating additional weight map (used by backward energy)

videoObj = VideoReader(video_file);

for i = 1:frame_to_skip
    fprintf(1,'Skipping (%d)\n',i); 
    readFrame(videoObj);
end

img = im2double(readFrame(videoObj));
img = imresize(img, scaleFactor);
[sizey, sizex, sizez] = size(img);

% x_reduction = floor((sizex / 360) * x_degree_reduction);
y_reduction = 0;

%map = gbvs(img);
%MM = map.master_map_resized;
%W = MM .* importance_of_saliency_in_seam_carving;


mask = ~logical(rgb2gray(imresize(imread(salience_map),scaleFactor)));
W = mask .* importance_of_saliency_in_seam_carving;

if createSeams
    [retargIm,S1,xp] = imretarget(img,[sizey - y_reduction,sizex - x_reduction],W,p);
    save('seams.mat','xp');
else
    load('seams.mat','xp');
end

mkdir('outputImages');
for imNum = 1:frames_to_process
    img = im2double(readFrame(videoObj));
    img = imresize(img, scaleFactor);
    
    J = img;
    n=x_reduction;
    for i=1:n
        fprintf(1,'Shrinking Seam %d (%d)\n',i,n); 
        % xpath = expand(xp(:,1:i)');
        xpath = xp(:,i)';
        J = seamRemove(J,xpath);
    end;
    imwrite(J,sprintf('outputImages/outputFile%06d.png',imNum));
end;

return




function xpath = expand(xp)

for i=1:size(xp,2),
    xpath(i) = xp(end,i) + 2*sum( xp(end,i)>=xp(1:end-1,i) );
end;

