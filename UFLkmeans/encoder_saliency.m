%% Saliency Coding
function code = encoder_saliency(patch, centroids, knn)

z = CalDistMatL2(patch, centroids);
[zSort, idx] = sort(z, 2, 'ascend');

code = zeros(size(patch,1), size(centroids,1));
for i = 1:size(patch,1)
    code(i, idx(i,1)) = (knn-1)*zSort(i,1) / sum(zSort(i, 2:knn)); % CVPR
    code(i, idx(i,1)) = 1 - (knn-1)*zSort(i,1) / sum(zSort(i, 2:knn)); % ICIP
    code(i, idx(i,1)) = sum( (zSort(i,2:knn)-zSort(i,1)) ./  zSort(i, 2:knn) ); % TPAMI
end

% see ICPR for more improvements
