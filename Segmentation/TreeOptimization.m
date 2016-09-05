function [segments, retStability] ...
        = TreeOptimization(im, multiTh, numSample, minPts, reconstErrorMap, paramE, thFilter)
% including tree construction and optimization 
% The basic idea of this optimization process is based on the following papers
% [1] Ricardo J. G. B. Campello, Davoud Moulavi, Joerg Sander. 
%     Density-Based Clustering Based on Hierarchical Density Estimates. 
%     PAKDD, 2013
% [2] Ricardo J. G. B. Campello, Davoud Moulavi, Arthur Zimek, Joerg Sande. 
%     Hierarchical Density Estimates for Data Clustering, Visualization, and Outlier Detection. 
%     TKDD, 2015

dim = size(im);
sp = dim(1)*dim(2);
if max(im(:))>1 || min(im(:))<0
    im = ( im-min(im(:)) ) ./ ( max(im(:))-min(im(:)) );
end

if isempty(multiTh)==true
    multiTh = (0:numSample)'./numSample;
end

minPtsRatio = minPts/sp;

sumIm = im;
thHierarchy = logical( zeros([dim, numSample+1]) );
regSegHierarchy = zeros([dim, numSample+1]);
nodeNum = zeros(numSample+1,1); % num of nodes in each level
nodeIdx = zeros(numSample+1,2); % start & end idx of node at each level

% node 1 @ threshold = 0
thHierarchy(:,:,1) = 1;
regSegHierarchy(:,:,1) = 1;
nodeNum(1) = 1;
nodeIdx(1,:) = [1,1];
nodeShrinkIdx = [1]; % nodes in the reduced tree

tree{1}.parent = 0;
tree{1}.child = [];
tree{1}.area = dim(1)*dim(2);
tree{1}.areaRatio = 1;
tree{1}.nodeShrink = 1;
tree{1}.parentShrink = 0;
tree{1}.childShrink = [];
tree{1}.areaAccu = tree{1}.areaRatio;
tree{1}.stability = 0;

%% construct a tree
for level = 2:numSample+1
    th = multiTh(level);
    thRes = sumIm>=th;
    thHierarchy(:,:,level) = thRes;
    regionIm = regionGrow(thRes);
    nodeNum(level) = max(regionIm(:));
    nodeIdx(level,:) = [nodeIdx(level-1,2)+1, nodeIdx(level-1,2) + nodeNum(level)];
    regionIm(thRes~=0) = regionIm(thRes~=0) + nodeIdx(level-1,2);
    regSegHierarchy(:,:,level) = regionIm;
    
    cover = regSegHierarchy(:,:,level-1); % mask from parent level
    for parent = nodeIdx(level-1,1) : nodeIdx(level-1,2) 
        extraction = regionIm(cover==parent);
        list = unique(extraction); % nodes covered by parent
        listChildSplit = []; % children >= minPtsRatio
        %% a complete tree
        for i = 1:numel(list)
            if list(i)==0
                continue;
            end
            child = list(i);
            childIdx = regionIm(:)==child;
            childIm = reshape(childIdx, dim(1), dim(2));
            
            tree{parent}.child = [tree{parent}.child, child];
            tree{child}.parent = parent;
            tree{child}.child = [];
            tree{child}.area = sum(childIdx(:)); 
            tree{child}.areaRatio = tree{child}.area/sp; 
            
            if tree{child}.areaRatio >= minPtsRatio
                listChildSplit = [listChildSplit; child];
                
                %%% add non-accumulative measurement here
                
            end
            
            %%% add accumulative measurement here
            tree{child}.weightedAreaRatio = sum(thFilter(childIdx)) / sp;
            tree{child}.reconstError = sum(reconstErrorMap(childIdx))/sp;
        end
        
        %% a reduced tree
        if numel(listChildSplit)>=2
            tree{tree{parent}.nodeShrink}.childShrink = listChildSplit;
            nodeShrinkIdx = [nodeShrinkIdx; listChildSplit];
            for i = 1:numel(listChildSplit)
                child = listChildSplit(i);
                tree{child}.nodeShrink = child;
                tree{child}.parentShrink = tree{parent}.nodeShrink;
                tree{child}.childShrink = [];
                tree{child}.stability = 0 ... % non-accumulative values
                                        + tree{child}.weightedAreaRatio ... % initial accumulative value
                                        - paramE * tree{child}.reconstError ... % initial accumulative value
                                        ; 
            
            end
        elseif numel(listChildSplit)==1
            child = listChildSplit(1);
            tree{listChildSplit}.nodeShrink = tree{parent}.nodeShrink;
            tree{tree{parent}.nodeShrink}.stability = tree{tree{parent}.nodeShrink}.stability ...
                                                      + tree{child}.weightedAreaRatio ...
                                                      - paramE * tree{child}.reconstError ...
                                                      ; 
        
        elseif isfield(tree{parent}, 'nodeShrink')==true % leaf node (no child) of the reduced tree
            tree{tree{parent}.nodeShrink}.staOp = max([0; tree{tree{parent}.nodeShrink}.stability]); %%%
            
            if tree{tree{parent}.nodeShrink}.staOp>0
                tree{tree{parent}.nodeShrink}.sel = 1; % initial selection of each leaf
                selLabel(tree{parent}.nodeShrink) = 1;
            else
                tree{tree{parent}.nodeShrink}.sel = 0; % initial selection of each leaf
                selLabel(tree{parent}.nodeShrink) = 0;
            end
        end
    end
end
selLabel( max(nodeIdx(:)) ) = 0; % set full length of selLabel

%% optimization
usedLabel = zeros(sp,1);
for n = numel(nodeShrinkIdx):-1:2 % bottom-up
    c = nodeShrinkIdx(n);
    if usedLabel(c)==1
        continue;
    end
    usedLabel(c) = 1;
    
    p = tree{c}.parentShrink;
    % revised on Mar 14
    if p==1 
        break; 
    end 
    
    children = tree{p}.childShrink;
    sumStab = 0;
    for i = 1:numel(children)
        sumStab = sumStab + tree{children(i)}.staOp; %%%
        usedLabel(children(i)) = 1;
    end
    
    if tree{p}.stability>0 && tree{p}.stability>=sumStab
        tree{p}.staOp = tree{p}.stability; %%%
        tree{p}.sel = 1;
        selLabel(p) = 1;
        % set all its children to 0
        listSetZero = children(:);
        while isempty(listSetZero)==false
            cz = listSetZero(1);
            tree{cz}.sel = 0;
            selLabel(cz) = 0;
            listSetZero = [listSetZero; tree{cz}.childShrink(:)];
            listSetZero = listSetZero(2:end);
        end
    else % sumStab >= max([0;tree{p}.stability])
        tree{p}.staOp = sumStab; %%%
        tree{p}.sel = 0;
    end
end

%% prepare return values
segIdx = find(selLabel); % selected idx
segments = zeros(dim); % return segments
retStability = []; % zeros(max(nodeIdx(:)), 1); % return value
for i = 1:numel(segIdx)
    level = sum(nodeIdx(:,1)<=segIdx(i));
    segments = segments + i*double(regSegHierarchy(:,:,level)==segIdx(i));
    retStability(i) = tree{segIdx(i)}.stability;
end
