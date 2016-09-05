function [patch, M, P] = whiten(patch, M, P)

if nargin==1
    C = cov(patch);
    M = mean(patch);
    [V,D] = eig(C);
    P = V * diag(sqrt(1./(diag(D) + 0.1))) * V';
end

patch = bsxfun(@minus, patch, M) * P;