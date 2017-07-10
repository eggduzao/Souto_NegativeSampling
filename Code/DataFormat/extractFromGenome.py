######################################################################################################################
# Script to search for fragments in the genome and extract specific sites if it exists.
##########
# Input:
# 1. extLeft: How many bp to extendo for the left.
# 2. extRight: How many bp to extendo for the right.
# 3. inputFileName: A csv file containing the entry fragments to search.
# 4. genomeFileName: A fasta file containing the genome.
# 5. outputLocation: Location in which outputs will be writen.
##########
# Output:
# 1. <inputFileName>_ext.csv: The csv file containing the extracted sequences.
# 2. <inputFileName>_log.txt: The txt file containing the sequences that were not found.
#####################################################################################################################

import sys
import random

# Reading input
extLeft = int(sys.argv[1])
extRight = int(sys.argv[2])
inputFileName = sys.argv[3]
genomeFileName = sys.argv[4]
outputLocation = sys.argv[5]
if(outputLocation[-1] != "/"): outputLocation += "/"

# File handling
inputFile = open(inputFileName,"r")
genomeFile = open(genomeFileName,"r")
outputFileName = inputFileName.split("/")[-1].split(".")[0]
outputFile = open(outputLocation+outputFileName+"_ext.csv","w")
logFile = open(outputLocation+outputFileName+"_log.txt","w")

# Function transpose
def transpose(s):
    ret = []
    tDict = dict([("a","t"),("t","a"),("c","g"),("g","c")])
    for c in s: ret.insert(0, tDict[c])
    return ret

# Extract the genome
genome = []
for line in genomeFile:
    if(len(line) < 2): continue
    if(line[0] != ">"):
        ll = line.strip()
        for c in ll: genome.append(c.lower())

# Perform the search
counter = 1
for line in inputFile:
    print counter
    if(len(line) < 2):
        counter += 1
        continue
    q = [e.lower() for e in line.strip().split(",")]
    qt = transpose(q)
    myBreak = False
    for i in range(0,len(genome)):
        if(q == genome[i:i+len(q)]):
            newS = genome[i-extLeft:i+len(q)+extRight]
            outputFile.write(newS[0])
            for c in newS[1:]: outputFile.write(","+c)
            outputFile.write("\n")
            myBreak = True
            counter += 1
            break
        elif(qt == genome[i:i+len(q)]):
            newS = transpose(genome[i-extRight:i+len(q)+extLeft])
            outputFile.write(newS[0])
            for c in newS[1:]: outputFile.write(","+c)
            outputFile.write("\n")
            myBreak = True
            counter += 1
            break
    if(myBreak): continue
    logFile.write(str(counter)+"\t"+("".join(q))+"\n")
    counter += 1

# Termination
inputFile.close()
genomeFile.close()
outputFile.close()
logFile.close()

