% Script based on the original by K. Song to create a new dataset of
% Z-curve parameters based on an input file containing sequences in the csv
% format.

clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PARAMETERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
%load 'possequence.mat'
%csvwrite('./possequence.csv',possequence);

%load 'negsequence.mat'
%csvwrite('./negsequence.csv',negsequence);

S = load('presigma70.mat');
outFile = fopen('presigma70.txt','w');
for i=1:size(S.direction,1)
    fprintf(outFile,'%d %s\n',S.location(i,:),S.direction(i,:));
end
fclose(outFile);
    



