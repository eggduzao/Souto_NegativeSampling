clc

foldNo = 10;
A = [1 ;2 ;3 ;4 ;5 ;6 ;7 ;8 ;9 ;10; 11 ;12 ;13 ;14 ;15 ;16];
[rows, cols] = size(A);

Indices = crossvalind('Kfold', rows, foldNo);
Indices

for k=1:foldnumber
   
    testInd = (Indices == k); trainInd = ~testInd;
    test = A(testInd,:); 
    train = A(trainInd,:);
    k
    test
    train
    [test ; train]
end



