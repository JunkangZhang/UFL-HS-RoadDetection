%% reconstIdx specifies points used to calculate PCA
function reconstError = reconstructionPCA(patch, reconstIdx, retainRatio)

input = patch(reconstIdx,:);
mu = mean(input);
% variance stores eigenvalues
% explained stores percentage of each eigenvalues (sum -> 100), in descending order
% mu is avg of data
% [R, ~, variance, ~, explained, mu] = pca(input); 
[R, ~, variance] = pca(input); 

% explained = explained/100;
explained = variance ./ sum(variance(:));
sumEigenV = 0;
for s = 1:numel(explained)
    sumEigenV = sumEigenV + explained(s);
    if sumEigenV >= retainRatio
        break;
    end
end

Rs = R(:, 1:s);
patch = bsxfun(@minus, patch, mu);
patchReconst = patch*(Rs*Rs');
reconstError = ( sum( (patchReconst-patch).^2, 2 ) ).^0.5;
