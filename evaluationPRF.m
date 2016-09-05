function [tot, sep] = evaluationPRF(predCell, labCell)
fileNum = numel(labCell);
rfWid = 6; rfHei = 6;
Ps = zeros(fileNum, 1); Rs = zeros(fileNum, 1); Fs = zeros(fileNum, 1);
A = zeros(fileNum, 1); M = zeros(fileNum, 1); AM = zeros(fileNum, 1);
for i = 1:fileNum
    lab = labCell{i};
    pred = predCell{i};
    
    if isempty(predCell{i})==false
        eva = evaluationSingle(pred, lab);

        A(i) = eva.A;
        M(i) = eva.M;
        AM(i) = eva.AM;

        Ps(i) = eva.Ps;
        Rs(i) = eva.Rs;
        Fs(i) = eva.Fs;
    else
        
    end
end

sep.P = Ps;
sep.R = Rs;
sep.F = Fs;

P = sum(AM(:))/sum(A(:));
R = sum(AM(:))/sum(M(:));
F = 2*P*R/(P+R);

tot.P = P;
tot.R = R;
tot.F = F;
