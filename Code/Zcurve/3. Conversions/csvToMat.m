% Script based on the original by K. Song to create a new dataset of
% Z-curve parameters based on an input file containing sequences in the csv
% format.

clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PARAMETERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
inFileName = 'dataset5neg.csv';
outFileName = 'negsequence';

% Positive
inFile = fopen(inFileName,'r');
seqCellComma = textscan(inFile,'%s');
seqCell = strrep(seqCellComma{1}, ',', '');
negsequence = char(seqCell);
fclose(inFile);

save(outFileName,outFileName)
    



