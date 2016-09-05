%% over the first dim
function patchRand = shuffle(patch, dim)

s = size(patch);
if nargin==1 || dim==1
    patchRand = patch(randperm(s(1)),:);
elseif dim==2
    patchRand = patch(:, randperm(s(2)));
end
