function [Bmean results]=crossvalidation(positive, negative, foldnumber)

posRows = size(positive,1);
negRows = size(negative,1);

WholeSet = [positive ; negative];
WholeLabel = [ones(posRows,1) ; -1*ones(negRows,1)];


rows = size(WholeSet,1);
CrossIndex = crossvalind('Kfold', rows, foldnumber);

tp = 0; fp = 0; tn = 0; fn = 0;

% Iterates in foldnumber
for k=1:foldnumber

    % Dataset manipulation
    TestIndex = (CrossIndex == k); TrainIndex = ~TestIndex;
    TestSet = WholeSet(TestIndex,:); TrainSet = WholeSet(TrainIndex,:);
    TestLabel = WholeLabel(TestIndex,:); TrainLabel = WholeLabel(TrainIndex,:);
    
    % Rescaling datasets (Song et al)
    %[TrainSetScaled,trainMean,trainStd] = autosc(TrainSet);
    %TestSetScaled = scal(TestSet,trainMean,trainStd);
    
    % Performing pls
    %[T,W,p,u,B] = pls(TrainSetScaled,TrainLabel,1);
    [T,W,p,u,B] = pls(TrainSet,TrainLabel,1);
    Btemp(:,k) = B;
    
    % Calculating statistics
    %PredLabel = sign(TestSetScaled*B);
    PredLabel = sign(TestSet*B);
    
    for i=1:size(PredLabel,1)
        if(PredLabel(i,1) == -1 && TestLabel(i,1) == -1)
            tn = tn + 1;
        elseif(PredLabel(i,1) == -1 && TestLabel(i,1) == 1)
            fn = fn + 1;
        elseif(PredLabel(i,1) == 1 && TestLabel(i,1) == -1)
            fp = fp + 1;
        elseif(PredLabel(i,1) == 1 && TestLabel(i,1) == 1)
            tp = tp + 1;
        end
    end

end

snmean = tp/(tp+fn);
spmean = tn/(tn+fp);
amean = mean([snmean spmean]);

[tp fp fn tn]

Bmean = mean(Btemp,2);
results = [snmean spmean amean].*100;

end