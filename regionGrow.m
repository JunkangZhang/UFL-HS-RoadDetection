function label = regionGrow(im, connect)
% connect -> 4 (default) or 8
if nargin<=1 || isempty(connect)==true || connect~=8
    connect = 4;
end
dim = size(im);
im = logical(im);
label = zeros(dim);
id = 1;
for r = 1:dim(1)
    if any(im(r,:))==true % has non-zero
        
        for c = 1:dim(2)
            if im(r,c)==true
                % start searching
                list = [r,c];
                while isempty(list)==false
                    rr = list(1,1);
                    cc = list(1,2);
                    if rr>0 && rr<=dim(1) && cc>0 && cc<=dim(2) ...
                            && im(rr,cc)==true
                        label(rr,cc) = id;
                        im(rr,cc) = false;
                        list = [list; ...
                                rr-1, cc; ...
                                rr+1, cc; ...
                                rr, cc-1; ...
                                rr, cc+1];
                        if connect==8
                            list = [list; ...
                                    rr-1, cc-1; ...
                                    rr+1, cc-1; ...
                                    rr-1, cc+1; ...
                                    rr+1, cc+1];
                        end
                    else
                        
                    end
                    list = list(2:end,:);
                end
                id = id+1;
            end
            if any(im(r,:))==false
                break;
            end
        end
        
    end
end
