
import os
import sys

inFile = open(sys.argv[1],"r")
outFile = open(sys.argv[2],"w")

for line in inFile:
    if(len(line) < 2): continue
    if(line[0] == ">"): continue
    ll = line.strip()
    outFile.write(ll[0])
    for c in ll[1:]: outFile.write(","+c)
    outFile.write("\n")

inFile.close()
outFile.close()


