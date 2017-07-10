% Script based on the original by K. Song to create a new dataset of
% Z-curve parameters based on an input file containing sequences in the csv
% format.

clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PARAMETERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
inFileName = './teste.txt';
outFileName = './testeOut.txt';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1.  Load the sequence input file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

inFile = fopen(inFileName,'r');
seqCellComma = textscan(inFile,'%s');
seqCell = strrep(seqCellComma{1}, ',', '');
seqMatrix = char(seqCell);
fclose(inFile);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2.  Perform the Z-curve evaluation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

row = size(seqMatrix,1);

for i=1:row
    parameter1 = vwzcurve(seqMatrix(i,:),1);
    p1(i,:) = parameter1;

    parameter2 = vwzcurve(seqMatrix(i,:),2);
    p2(i,:) = parameter2;

    parameter3 = vwzcurve(seqMatrix(i,:),3);
    p3(i,:) = parameter3;

    parameter4 = vwzcurve(seqMatrix(i,:),4);
    p4(i,:) = parameter4;

    parameter5 = vwzcurve(seqMatrix(i,:),5);
    p5(i,:) = parameter5;

    parameter6 = vwzcurve(seqMatrix(i,:),6);
    p6(i,:) = parameter6;
end

zMatrix = [p1 p2 p3 p4 p5 p6];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3.  Write the Z-curve parameters into file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

csvwrite(outFileName,zMatrix);
