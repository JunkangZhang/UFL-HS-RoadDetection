function [fullSize, roadPredict, fullSizeStore] = RoadDetection(im, param)
% im -> 3-channel color image in range [0,255]
% param -> a struct

%% image preprocessing

im = im2double(im);

% resize
imgDim = [param.inputSize, 3];

if imgDim(1)~=size(im,1)
    im = imresize(im, imgDim(1:2));
end

% blurring
if param.LPFwindow>1
    if isfield(param,'LPFsigma')==false || param.LPFsigma<=0
        gaussianFilter = fspecial('gaussian', ...
                                  [param.LPFwindow, param.LPFwindow]);
    else
        gaussianFilter = fspecial('gaussian', ...
                                  [param.LPFwindow, param.LPFwindow], ...
                                  param.LPFsigma);
    end
    im = imfilter(im, gaussianFilter, 'replicate');
end

% brightness equalization
if param.lumiWid>0 && param.lumiHei>0
    im = luminanceElimination(im, param.lumiSigma, [param.lumiHei, param.lumiWid]);
end

%% UFL settings

% parameters
rfWid = param.rfWid;
rfHei = param.rfHei;
numCentroids = param.numCentroids; 

% input
input = im;
inDim = size(input);

% output size
outDim = [inDim(1)-rfHei+1, inDim(2)-rfHei+1, inDim(3)];

%% UFL train
paramUFL.trainPatchNum = param.numPatches;
paramUFL.numCentroids = param.numCentroids;
paramUFL.kmeansIterations = param.kmeansIterations;
paramUFL.rfWid = rfWid;
paramUFL.rfHei = rfHei;
codeTri2 = UFL(input, paramUFL);

%% UFL feature selection
fsPriorRatio = param.fsPriorRatio;
coden = bsxfun(@rdivide, codeTri2, max(codeTri2,[],1)); 
proj = reshape(coden, outDim(1), outDim(2), numCentroids);
if sum(fsPriorRatio(:))>0
    % rate
    priorIdx = FilterRankingPrior(proj, param.filter);
    totalIdx = priorIdx;
    
    % project to selected filters
    fsNum = round(numCentroids.*fsPriorRatio);
    selIdx = [totalIdx(1:fsNum(1)); totalIdx(end-fsNum(2)+1:end)];
    
    slicIm = proj(:, :, selIdx);
else
    slicIm = proj;
end

%% threshold
[roadPredict, ~, roadPredictStore] = MultiThSegment(slicIm, param.numSamples, param.minPts, param.paramE, param.thIteration, param.thFilter);

%% final -- switch to 160*120
[fullSize] = expandResLabel(roadPredict, param.inputSize, rfWid, rfHei);
for it = 1:numel(roadPredictStore)
    fullSizeStore{it} = expandResLabel(roadPredictStore{it}, param.inputSize, rfWid, rfHei);
end
