%% proj: row*col*channel
function rateIdx = FilterRankingPrior(proj, filter)

dim = size(proj);
if numel(dim)<=2
    rateIdx = 1;
    return
end

if nargin<=1 || isempty(filter)==true
    verticalSum = reshape(sum(proj, 2), dim(1), dim(3));

    rateMin = ceil(-dim(1)/2);
    filter = rateMin:rateMin+dim(1) - 1;
    rate = filter*verticalSum;
else
    filterRes = bsxfun(@times, proj, filter);
    rate = sum(reshape(filterRes, dim(1)*dim(2),dim(3)), 1);
end

[~,rateIdx] = sort(rate(:), 'descend');
