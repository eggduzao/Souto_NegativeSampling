######################################################################################################################
# Script to extract sequences from a genome based on a coordinates file given Song representation.
#
# 1. In the forward strand:
#    The -1 region will be identified as tssPosition. Then the interval will be:
#    <tssPosition> - <leftValue> to <tssPosition> + <rightValue>
#
# 2. In the backward strand:
#    The -1 region will be identified as tssPosition. Then the interval will be:
#    <tssPosition> - <rightValue> to <tssPosition> + <leftValue>
##########
# Input:
# 1. leftValue: The desired position of left value of the interval to be extracted. Song = 60.
# 2. rightValue: The desired position of right value of the interval to be extracted. Song = 19.
# 3. coordFile: The tab-separated coordinates file.
#               Format: <pos1> <pos2> <strand> <relPos1>:<relPos2>
#                  Obs: 1. pos1 and pos2 are included and 1-relative.
#                       2. relPos is the position relative to the TSS. TSS = +1.
# 4. genomeFile: The genome file.
# 5. outputLocation: Location in which outputs will be writen.
##########
# Output:
# 1. <coordFile>.csv: A text file containing the extracted sequences.
#####################################################################################################################

import sys
import math

# Reading input
leftValue = int(sys.argv[1])
rightValue = int(sys.argv[2])
coordFileName = sys.argv[3]
genomeFileName = sys.argv[4]
outputLocation = sys.argv[5]
if(outputLocation[-1] != "/"): outputLocation += "/"

# Auxiliary Function
def transpose(seq):
    auxDic = dict([("a","t"),("t","a"),("g","c"),("c","g")])
    res = ""
    for n in seq: res += auxDic[n]
    return res[::-1]

# Opening files
coordFile = open(coordFileName,"r")
genomeFile = open(genomeFileName,"r")
outFile = open(coordFileName.split("/")[-1].split(".")[0]+".csv","w")

# Putting genome into a list
genome = []
genomeFile.readline() # Fasta header
for line in genomeFile:
    if(len(line) < 2): continue
    if(line[-1] == "\n"): line = line[:len(line)-1]
    genome += list(line.lower())

# Extracting sequences
for line in coordFile:

    if(len(line) < 2): continue
    line = line.strip()

    # Obtaining coordenates
    lineList = line.split("\t")
    pos1 = int(lineList[0])
    pos2 = int(lineList[1])
    strand = lineList[2]
    posRel1 = int(lineList[3].split(":")[0])
    posRel2 = int(lineList[3].split(":")[1])

    # Changing actual pos1 and pos2 to the desired pos1 and pos2
    tssLocation = pos1 + (-posRel1) - 1
    if(strand == "+"):
        pos1 = tssLocation - leftValue
        pos2 = tssLocation + rightValue
    if(strand == "-"):
        pos1 = tssLocation - rightValue
        pos2 = tssLocation + leftValue

    # Fetching desired sequence
    seq = ""
    for i in range(pos1-1,pos2): seq += genome[i]
    if(strand == "-"): seq = transpose(seq)

    # Writing sequence
    outFile.write(seq[0])
    for n in seq[1:]: outFile.write(","+n)
    outFile.write("\n")

# Termination
coordFile.close()
genomeFile.close()
outFile.close()
