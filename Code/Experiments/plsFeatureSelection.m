function [selectedCols] = plsFeatureSelection(positive, negative, foldnumber, desiredFeatures)

posRows = size(positive,1);
negRows = size(negative,1);
posIndex = crossvalind('Kfold', posRows, foldnumber);
negIndex = crossvalind('Kfold', negRows, foldnumber);

Btot = zeros(1,size(positive,2));

% Iterates in foldnumber
for k = 1:foldnumber

    % Dataset manipulation
    posTrainIndex = (posIndex ~= k); posTrain = positive(posTrainIndex,:);
    negTrainIndex = (negIndex ~= k); negTrain = negative(negTrainIndex,:);    

    % Performing pls
    [T,W,p,u,B] = pls([posTrain ; negTrain],[ones(size(posTrain,1),1) ; -1*ones(size(negTrain,1),1)],1);

    % Updating Btot
    for i = 1:size(Btot,2)
        Btot(1,i) = Btot(1,i) + B(i,1);
    end
    
end

for i = 1:size(Btot,2)
    Btot(1,i) = Btot(1,i) / foldnumber;
end
[Y,index] = sort(abs(Btot'),1,'descend');
selectedCols = index(1:desiredFeatures);

end