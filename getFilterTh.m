%% 
function filter = getFilterTh(dim, choice)

%% 
rrhalf = (dim(1)+1) / 2;
if choice<=3
    rr = repmat( ((1:dim(1))'-rrhalf)./rrhalf, 1, dim(2) ); % row filter
else
    rr = repmat( ((1:dim(1))'-dim(1))./rrhalf, 1, dim(2) ); % row filter
end

%% 
cc = 1:dim(2);
cchalf = (dim(2)+1) / 2;
cc(cc>=cchalf) = dim(2)+1 - cc(cc>=cchalf);

if choice==1 || choice==4
    cc = cc ./ cchalf;
elseif choice==2 || choice==5
    cc = cc - cchalf +dim(1);
    cc = cc ./ dim(1);
elseif choice==3 || choice==6
    cc = cc - cchalf + rrhalf;
    cc = cc ./ rrhalf;
end

cc = repmat(cc, dim(1), 1);

%%
filter = rr + cc;

% figure()
% imshow(prob2heatmap(filter))
% imwrite(prob2heatmap(filter), 'pic/thfilter.png');