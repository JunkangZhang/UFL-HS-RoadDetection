function code = encoder_triangle(patch, centroids, reluType)

% compute 'triangle' activation function
z = CalDistMatL2(patch, centroids);

if strcmp(reluType, 'data')
    mu = mean(z, 2); % average distance to all centroids for each patch
    code = max(bsxfun(@minus, mu, z), 0);
elseif strcmp(reluType, 'centroid')
    mu = mean(z, 1); % average distance to each centroid for all patches
    code = max(bsxfun(@minus, mu, z), 0);
else
    fprintf('Error in encoder_triangle(). \n')
end
