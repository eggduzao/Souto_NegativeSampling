######################################################################################################################
# Script to extract the positive promoter sequences from the regulonDB 7.0 files to a csv file.
##########
# Input:
# 1. leftWindow: How many bps to extract to the left of the +1. Eg. 60.
# 2. rightWindow: How many bps to extract to the right of the +1. Eg. 20.
# 3. inputFileName: The file obtained from regulonDB containing the sequences to be extracted.
# 4. outputLocation: Location in which outputs will be writen.
##########
# Output:
# 1. <inputFileName>.csv: The csv file containing the extracted sequences.
#####################################################################################################################

import sys

# Reading input
leftWindow = int(sys.argv[1])
rightWindow = int(sys.argv[2])
inputFileName = sys.argv[3]
outputLocation = sys.argv[4]
if(outputLocation[-1] != "/"): outputLocation += "/"

# File handling
inputFile = open(inputFileName,"r")
outputFile = open(outputLocation+inputFileName.split("/")[-1].split(".")[0]+".csv","w")

# Evidence vector
allowedEvidence = ['TIM','RPF']

# Iterating on inputFile
for line in inputFile:
    if(len(line) < 2 or "#" in line): continue
    lineList = line.strip().split("\t")
    seq = lineList[5]
    evidenceList = [e[1:len(e)-1].split("|")[0] for e in lineList[6].split(",")]
    containEvidence = False
    for e in evidenceList:
        if(e in allowedEvidence):
            containEvidence = True
            break
    if(containEvidence):
        index = -1
        for i in range(0,len(seq)):
            if(seq[i].isupper()):
                index = i
                break
        seq = seq[index-leftWindow:index+rightWindow].lower()
        outputFile.write(seq[0])
        for c in seq[1:]: outputFile.write(","+c)
        outputFile.write("\n")
# End for line in inputFile

# Termination
inputFile.close()
outputFile.close()

