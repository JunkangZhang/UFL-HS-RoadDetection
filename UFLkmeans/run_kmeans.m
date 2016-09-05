function centroids = run_kmeans(X, k, iterations, verbose)
% This file is revised based on Adam Coates's code. 
% Original code is available at: http://cs.stanford.edu/~acoates/
% Reference 
% Adam Coates, Honglak Lee, and Andrew Y. Ng. 
% An Analysis of Single-Layer Networks in Unsupervised Feature Learning. 
% In AISTATS, 2011. 

if nargin<=3 || strcmp(verbose,'verbose')==false
    verb = false;
else
    verb = true;
end
    x2 = sum(X.^2,2);
    centroids = randn(k,size(X,2))*0.1;%X(randsample(size(X,1), k), :);
    BATCH_SIZE=1000;


    for itr = 1:iterations
        if verb==true
            fprintf('K-means iteration %d / %d\n', itr, iterations);
        end

        c2 = 0.5*sum(centroids.^2,2);

        summation = zeros(k, size(X,2));
        counts = zeros(k, 1);

        loss =0;

        for i=1:BATCH_SIZE:size(X,1)
            lastIndex=min(i+BATCH_SIZE-1, size(X,1));
            m = lastIndex - i + 1;

            [val,labels] = max(bsxfun(@minus,centroids*X(i:lastIndex,:)',c2));
            loss = loss + sum(0.5*x2(i:lastIndex) - val');

            S = sparse(1:m,labels,1,m,k,m); % labels as indicator matrix
            summation = summation + S'*X(i:lastIndex,:);
            counts = counts + sum(S,1)';
        end


        centroids = bsxfun(@rdivide, summation, counts);

        % just zap empty centroids so they don't introduce NaNs everywhere.
        badIndex = find(counts == 0);
        centroids(badIndex, :) = 0;
    end
