######################################################################################################################
# Script to extract random fragments of coding regions.
##########
# Input:
# 1. seqSize: Size of the extracted sequences. Eg. 80.
# 2. quantSeq: How many sequences to extract. Eg. 836.
# 3. inputFileName: A fasta file containing the coding regions.
# 4. outputLocation: Location in which outputs will be writen.
##########
# Output:
# 1. cod2.csv: The csv file containing the extracted sequences.
#####################################################################################################################

import sys
import random

# Reading input
seqSize = int(sys.argv[1])
quantSeq = int(sys.argv[2])
inputFileName = sys.argv[3]
outputLocation = sys.argv[4]
if(outputLocation[-1] != "/"): outputLocation += "/"

# File handling
inputFile = open(inputFileName,"r")
outputFile = open(outputLocation+"cod2.csv","w")

# Extracting coding regions
codingList = []
codingSeq = ""
flagFirst = True
for line in inputFile:
    if(len(line) < 2): continue
    if(line[0] == ">"):
        if(flagFirst):
            flagFirst = False
            continue
        codingList.append(codingSeq)
        codingSeq = ""
    else: codingSeq += line.strip()
codingList.append(codingSeq)

# Writing coding sequences
seqCount = 0
while(seqCount < quantSeq):
    rSeq = random.randint(0,len(codingList)-1)
    seq = codingList[rSeq]
    if(len(seq) < seqSize): continue
    rPos = random.randint(0,len(seq)-seqSize)
    seq = (seq[rPos:rPos+seqSize]).lower()
    outputFile.write(seq[0])
    for e in seq[1:]: outputFile.write(","+e)
    outputFile.write("\n")
    seqCount += 1

# Termination
inputFile.close()
outputFile.close()

