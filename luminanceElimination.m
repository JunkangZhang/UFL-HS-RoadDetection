function im = luminanceElimination(im, dstLumi, window, sigma)

gray = rgb2gray(im);
% imwrite(gray, 'pic/gray.png');
if window(1)>1 && window(2)>1
    if nargin<=3 || isempty(sigma) ||sigma<=0
        h = fspecial('gaussian', window);
    else
        h = fspecial('gaussian', window, sigma);
    end
%     gray = filter2(h, gray);
    gray = imfilter(gray, h, 'replicate');
end
% imwrite(gray, 'pic/grayblur.png');

% imr = im;
% imr(:,:,2) = 0; imr(:,:,3) = 0;
% imwrite(imr, 'pic/r.png');
% imr = im;
% imr(:,:,1) = 0; imr(:,:,3) = 0;
% imwrite(imr, 'pic/g.png');
% imr = im;
% imr(:,:,1) = 0; imr(:,:,2) = 0;
% imwrite(imr, 'pic/b.png');

im = bsxfun(@rdivide, im, gray).*dstLumi;

% imr = im;
% imr(:,:,2) = 0; imr(:,:,3) = 0;
% imwrite(imr, 'pic/rl.png');
% imr = im;
% imr(:,:,1) = 0; imr(:,:,3) = 0;
% imwrite(imr, 'pic/gl.png');
% imr = im;
% imr(:,:,1) = 0; imr(:,:,2) = 0;
% imwrite(imr, 'pic/bl.png');

