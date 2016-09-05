function [code, centroids] = UFL(input, param)
% input -> 3-channel color image
% param -> a struct

%% image patch extraction
patch = ExtractPatches(input, param.rfHei, param.rfWid);

if param.trainPatchNum<=0 || param.trainPatchNum==size(patch,1)
    % normalize
    patch = bsxfun(@rdivide, bsxfun(@minus, patch, mean(patch,2)), sqrt(var(patch,[],2)+10/(255^2)));
    % whiten
    [patch, ~, ~] = whiten(patch);
    % shuffle
    trainPatch = shuffle(patch); 
    
else % specified param.trainPatchNum
    
    trainPatchNum = param.trainPatchNum;
    randIdx = randi([1,size(patch,1)], trainPatchNum, 1);
    trainPatch = patch(randIdx, :);
    
    trainPatch = bsxfun(@rdivide, bsxfun(@minus, trainPatch, mean(trainPatch,2)), sqrt(var(trainPatch,[],2)+10/(255^2)));
    [trainPatch, M, P] = whiten(trainPatch);
        
    patch = bsxfun(@rdivide, bsxfun(@minus, patch, mean(patch,2)), sqrt(var(patch,[],2)+10/(255^2)));
    patch = whiten(patch, M, P);
end


%% run K-means
centroids = run_kmeans(trainPatch, param.numCentroids, param.kmeansIterations);

%% encoding
code = encoder_triangle(patch, centroids, 'centroid');
