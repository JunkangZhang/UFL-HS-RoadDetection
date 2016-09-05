%% data in row
function z = CalDistMatL2(mat1, mat2)

xx = sum(mat1.^2, 2);
cc = sum(mat2.^2, 2)';
xc = mat1 * mat2';
m = bsxfun(@plus, cc, bsxfun(@minus, xx, 2*xc));
m(m<0) = 0;
z = sqrt( m ); % distances
