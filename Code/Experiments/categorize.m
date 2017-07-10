function [catDatabase] = categorize(database)

[nRow nCol] = size(database);
catDatabase = zeros(nRow,nCol);

for i=1:nRow
    for j=1:nCol
        if database(i,j) == 'a'
            catDatabase(i,j) = 1;
        elseif database(i,j) == 'c'
            catDatabase(i,j) = 2;
        elseif database(i,j) == 'g' 
            catDatabase(i,j) = 3;
        else
            catDatabase(i,j) = 4;
        end
    end
end

end