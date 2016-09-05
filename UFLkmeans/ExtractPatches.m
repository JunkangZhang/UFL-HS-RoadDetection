function patches = ExtractPatches(im, rfHei, rfWid)
% im -> 3-channel
% rfHei, rfWid -> size of reception field

dim = size(im);
if numel(dim)<3
    dim(3) = 1;
end
pHei = (dim(1)-rfHei+1);
pWid = (dim(2)-rfWid+1);
patches = zeros(pHei*pWid, rfHei*rfWid*dim(3));

for c = 1:pWid
    for r = 1:pHei
        pat = im(r:r+rfHei-1, c:c+rfWid-1, :);
        patches((c-1)*pHei+r,:) = reshape(pat, 1, rfHei*rfWid*dim(3));
    end
end
