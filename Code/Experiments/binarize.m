function [binDatabase] = binarize(database)

[nRow nCol] = size(database);
binDatabase = zeros(nRow,4*nCol);

for i=1:nRow
    for j=1:nCol
        if database(i,j) == 'a'
            binDatabase(i,((j-1)*4)+1:((j-1)*4)+4) = [1 0 0 0];
        elseif database(i,j) == 'c'
            binDatabase(i,((j-1)*4)+1:((j-1)*4)+4) = [0 1 0 0];
        elseif database(i,j) == 'g' 
            binDatabase(i,((j-1)*4)+1:((j-1)*4)+4) = [0 0 1 0];
        else
            binDatabase(i,((j-1)*4)+1:((j-1)*4)+4) = [0 0 0 1];
        end
    end
end
