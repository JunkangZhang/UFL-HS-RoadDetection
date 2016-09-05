function [roadPredict, thSeg, roadPredictStore] = MultiThSegment(projIm, numSample, minPts, paramE, iteration, thFilter)

dim = size(projIm);
patch = reshape(projIm, dim(1)*dim(2), dim(3));

im = sum(projIm,3);
im = im/max(im(:));
nonzeroIdx = im~=0;

multiTh = [];

dilateHei = 7; % empirical
dilateWid = 7;

plotTree = false;
% iteration = 2;
for it = 1:iteration
    %% pca
    if it==1
        reconstErrorMap = zeros(dim(1), dim(2));
    else
        reconstError = reconstructionPCA(patch, reconstIdx, 0.95);
        reconstError = reconstError - min(reconstError(nonzeroIdx));
        reconstError = reconstError ./ max(reconstError(nonzeroIdx));
        reconstError(~nonzeroIdx) = 0;
        reconstErrorMap = reshape(reconstError, dim(1), dim(2));
    end
    
    %% segmentation
    % Problem: A tree is constructed in each iteration, even though all
    % trees should be identical 
    [thSeg, retSta] = ...
        TreeOptimization(im, multiTh, numSample, minPts, reconstErrorMap, paramE, thFilter);
    
    %% dilate
    roadPredict = logical(zeros(size(im)));
    roadIdx = unique(thSeg(:));
    for i = 1:numel(roadIdx)
        if roadIdx(i)~=0 && retSta(roadIdx(i))>0
            roadPredict(thSeg==roadIdx(i)) = true;
        end
    end

    roadPredict = ordfilt2(roadPredict, dilateHei*dilateWid, true(dilateHei,dilateWid));
    
    roadPredictStore{it} = roadPredict;
    
    %% road pixels' indices for reconstruction
    [~,maxStabIdx] = max(retSta(:));
    if isempty(maxStabIdx)
        for reit = it+1:iteration
            roadPredictStore{reit} = roadPredict;
        end
        break;
    end
    reconstIdx = thSeg==maxStabIdx;

    %% plot
    
    if plotTree==true % plot
        imThSeg = zeros([size(thSeg),3]);
        for i = 1:max(thSeg(:));
            imThSeg(:,:,1) = imThSeg(:,:,1) + (thSeg==i)*rand();
            imThSeg(:,:,2) = imThSeg(:,:,2) + (thSeg==i)*rand();
            imThSeg(:,:,3) = imThSeg(:,:,3) + (thSeg==i)*rand();
        end
        figure(56); cla;
        imshow(imThSeg)
        
        if it==1
%             imwrite(imThSeg, 'pic/thSeg21.png');
        else
%             imwrite(imThSeg, 'pic/thSeg22.png');
        end
    end
    
end
