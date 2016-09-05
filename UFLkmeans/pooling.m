function output = pooling(input, hei, wid, step)

s = size(input);
if numel(s)<=2
    s(3) = 1;
end

pHei = floor( (s(1)-(hei-step)) / step );
pWid = floor( (s(2)-(wid-step)) / step );
output = zeros(pHei, pWid, s(3));

% slicePic = cell(s(3),1);
% for d = 1:s(3)
%     slicePic{d} = input(:,:,d);
% end

for d = 1:s(3)
    str = 1; % start of r
    for r = 1:pHei
        stc = 1; % start of c
        for c = 1:pWid
            patch = input(str:str+hei-1, stc:stc+wid-1, d);
%             patch = slicePic{d}(str:str+hei-1, stc:stc+wid-1);
            output(r,c,d) = max(patch(:));
            stc = stc+step;
        end
        str = str+step;
    end
end