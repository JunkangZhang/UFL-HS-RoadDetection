function patches = ExtractRandomPatches(im, numPatches, rfHei, rfWid)
dim = size(im);
patches = zeros(numPatches, rfHei*rfWid*dim(3));
for i = 1:numPatches
    r = random('unid', dim(1) - rfHei + 1);
    c = random('unid', dim(2) - rfWid + 1);
    pat = im(r:r+rfHei-1, c:c+rfWid-1, :);
    patches(i,:) = reshape(pat, 1, rfWid*rfHei*dim(3));
end