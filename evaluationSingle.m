function eva = evaluationSingle(pred, lab)

crossRoad = lab & pred;
    
eva.A = sum(pred(:));
eva.M = sum(lab(:));
eva.Mn = sum(~lab(:));
eva.AM = sum(crossRoad(:)); 

% P R F
eva.Ps = eva.AM/eva.A;
eva.Rs = eva.AM/eva.M;
eva.Fs = 2*eva.Ps*eva.Rs/(eva.Ps+eva.Rs);

% roc
crossNoneRoad = (~lab)&pred;
eva.TP = eva.Rs;
eva.AMn = sum(crossNoneRoad(:));
eva.FP = eva.AMn/eva.Mn;
