function [fullSize] = expandResLabel(res, inputSize, rfWid, rfHei)

outDim = size(res);
fullSize = logical(zeros(inputSize));
rbeg = floor((rfHei-1)/2) + 1;
rbor = rbeg-1;
cbeg = floor((rfWid-1)/2) + 1;
cbor = cbeg-1;
if mod(rfWid,2)==0
    fullSize(rbeg:rbeg+outDim(1)-1, cbeg:cbeg+outDim(2)-1) = res;
    fullSize(rbeg+1:rbeg+outDim(1), cbeg:cbeg+outDim(2)-1) = fullSize(rbeg+1:rbeg+outDim(1), cbeg:cbeg+outDim(2)-1) | res;
    fullSize(rbeg:rbeg+outDim(1)-1, cbeg+1:cbeg+outDim(2)) = fullSize(rbeg:rbeg+outDim(1)-1, cbeg+1:cbeg+outDim(2)) | res;
    fullSize(rbeg+1:rbeg+outDim(1), cbeg+1:cbeg+outDim(2)) = fullSize(rbeg+1:rbeg+outDim(1), cbeg+1:cbeg+outDim(2)) | res;
    fullSize(1:rbor,:) = repmat( fullSize(rbor+1,:), rbor,1 );
    fullSize(end-rbor+1:end,:) = repmat( fullSize(end-rbor,:), rbor,1 );
    fullSize(:,1:cbor) = repmat( fullSize(:,cbor+1), 1, cbor);
    fullSize(:,end-cbor+1:end) = repmat( fullSize(:,end-cbor), 1, cbor);
else
    
end
