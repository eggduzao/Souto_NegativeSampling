######################################################################################################################
# Script to calculate the nucleotide frequency for a dataset
##########
# Input:
# 1. inputFileLocation: The location to the input file (CSV).
# 2. outputLocation: Location in which outputs will be writen.
##########
# Output:
# 1. <inputFileName>.log: A text file containing the frequencies.
#####################################################################################################################

import sys

# Reading input
inputFileLocation = sys.argv[1]
outputLocation = sys.argv[2]
if(outputLocation[-1] != "/"): outputLocation += "/"

# Opening files
inputFile = open(inputFileLocation,"r")
outFile = open(outputLocation+inputFileLocation.split("/")[-1].split(".")[0]+".log","w")

# Auxiliary dictionary
# A -> 0     C -> 1     G -> 2     T -> 3
nucDict = dict([("a",0),("c",1),("g",2),("t",3)])
nucs = [0,0,0,0] # ORDER = A C G T
totalSeqs = 0
minSeqLen = 999999999
maxSeqLen = -1

# Iterate on input file to store the frequencies
for line in inputFile:
    if(len(line) < 2): continue
    totalSeqs += 1
    lineList = line.strip().lower().split(",")
    if(len(lineList) < minSeqLen): minSeqLen = len(lineList)
    if(len(lineList) > maxSeqLen): maxSeqLen = len(lineList)
    for e in lineList: nucs[nucDict[e]] += 1
totalNucs = sum(nucs)

# Writing results
outFile.write("A\tC\tG\tT\n")
for e in nucs: outFile.write(str(e)+"\t")
outFile.write("\n")
for e in nucs: outFile.write(str(round((100.0*float(e))/totalNucs,2))+"%\t")
outFile.write("\n\nTotal Nucleotides = "+str(totalNucs))
outFile.write("\nTotal Sequences = "+str(totalSeqs))
outFile.write("\nMean Sequence Length = "+str(round(float(totalNucs)/totalSeqs,2)))
outFile.write("\nMin Sequence Length = "+str(minSeqLen))
outFile.write("\nMax Sequence Length = "+str(maxSeqLen))

# Termination
inputFile.close()
outFile.close()
