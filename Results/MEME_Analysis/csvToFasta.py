import os
import sys
inputList=["cod1.csv","cod2.csv","ctrl.csv","mix1_train.csv","mix2_train.csv","ncod.csv","pos.csv","rand.csv"]
for ifn in inputList:
    counter = 0
    inputFile = open(ifn,"r")
    outputFile = open(ifn.split(".")[0]+".fa","w")
    for line in inputFile:
        if(counter == 750): break
        outputFile.write(">seq"+str(counter)+"\n"+"".join(line.strip().split(","))+"\n")
        counter += 1
    inputFile.close()
    outputFile.close()


