% Script based on the original by K. Song to a positive and negative csv
% datasets using Songs method.
clear all
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PARAMETERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
%load 'C:/Users/Eduardo Gade/Desktop/TesteZcurve/mat/possequence.mat'
%load 'C:/Users/Eduardo Gade/Desktop/TesteZcurve/mat/negsequence.mat'

posFileName = 'C:/Users/Eduardo Gade/Desktop/TesteZcurve/Bsub/bspromoter.csv';
negFileName = 'C:/Users/Eduardo Gade/Desktop/TesteZcurve/Bsub/dataset5neg.csv';

%posFileName = 'testPos.csv';
%negFileName = 'testNeg.csv';

outFileName = 'C:/Users/Eduardo Gade/Desktop/TesteZcurve/out.csv';
foldnumber=1325;
windowSizeMax=6;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1.  Load the sequence input file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Positive
inFile = fopen(posFileName,'r');
seqCellComma = textscan(inFile,'%s');
seqCell = strrep(seqCellComma{1}, ',', '');
posMatrix = char(seqCell);
fclose(inFile);

% Negative
inFile = fopen(negFileName,'r');
seqCellComma = textscan(inFile,'%s');
seqCell = strrep(seqCellComma{1}, ',', '');
negMatrix = char(seqCell);
fclose(inFile);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2.  Perform the Z-curve evaluation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rowP = size(posMatrix,1);
rowN = size(negMatrix,1);
col = 0;
for i=1:windowSizeMax
    col = col + (3*(4^(i-1)));
end

positive = zeros(rowP,col);
negative = zeros(rowN,col);

% Positive
for i=1:rowP
    counter = 1;
    for j=1:windowSizeMax
        parameters = vwzcurve(posMatrix(i,:),j);
        for m=1:size(parameters,2)
            positive(i,counter) = parameters(:,m);
            counter = counter + 1;
        end
    end
end

% Negative
for i=1:rowN
    counter = 1;
    for j=1:windowSizeMax
        parameters = vwzcurve(negMatrix(i,:),j);
        for m=1:size(parameters,2)
            negative(i,counter) = parameters(:,m);
            counter = counter + 1;
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3.  Perform cross-validation according to Songs feature selection
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[Bmean results] = crossvalidationLOO(positive, negative, foldnumber);
[Y,index] = sort(abs(Bmean),1,'descend');  %Sorting the absolute values of the elements of Bmean in descending order

for number = 400:-20:300
    currIndex = index(1:number); %The selected number of the vw Z-curve features should be optimized to make the prediction accuracy high enough
    pos = positive(:,currIndex);%Selecting given number vw Z-curve features of the positive samples with the largest absolute coefficient values
    neg = negative(:,currIndex);%Selecting given number vw Z-curve features of the negative samples with the largest absolute coefficient values
    [B results] = crossvalidationLOO(pos, neg, foldnumber); %use the cross-validation procedure to assess the prediction performance of these selected variables.
    number
    results
end

%==========================================================================
