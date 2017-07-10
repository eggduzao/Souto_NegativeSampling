######################################################################################################################
# Script to extract sequences to for the random set. These sequences are extracted randomly from the genome
# but they may not overlap any bp of the sequences that were extracted as positive.
##########
# Input:
# 1. leftWindow: How many bps to consider unexctractable from the left of the segment. Eg. 60.
# 2. rightWindow: How many bps to consider unexctractable from the right of the segment. Eg. 20.
# 3. seqSize: Size of the sequences. Eg. 100.
# 4. nSeq: Number of sequences. Eg. 800.
# 5. inputFileName: Csv file containing the known promoters.
# 6. genomeFileName: The genome file.
# 7. outputLocation: Location in which outputs will be writen.
##########
# Output:
# 1. rand.csv: The csv file containing the extracted sequences.
#####################################################################################################################

import os
import sys
import random

# Reading input
leftWindow = int(sys.argv[1])
rightWindow = int(sys.argv[2])
seqSize = int(sys.argv[3])
nSeq = int(sys.argv[4])
inputFileName = sys.argv[5]
genomeFileName = sys.argv[6]
outputLocation = sys.argv[7]
if(outputLocation[-1] != "/"): outputLocation += "/"

# File handling
inputFile = open(inputFileName,"r")
genomeFile = open(genomeFileName,"r")
outputFile = open(outputLocation+"rand.csv","w")

# Function transpose
def transpose(s):
    ret = []
    tDict = dict([("a","t"),("t","a"),("c","g"),("g","c")])
    for c in s: ret.insert(0, tDict[c])
    return ret
    
# Function overlap
def overlap(c1,cList):
    overl = False
    for c2 in cList:
        if(c2[1] < c1[0] or c2[0] > c1[1]): overl = False
        else: 
            overl = True
            break
    return overl

# Extract the genome
genome = []
for line in genomeFile:
    if(len(line) < 2): continue
    if(line[0] != ">"):
        ll = line.strip()
        for c in ll: genome.append(c.lower())

# Perform the search
counter = 1
coords = []
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
            coords.append([i-leftWindow,i+len(q)+rightWindow])
            break
        elif(qt == genome[i:i+len(q)]):
            coords.append([i-rightWindow,i+len(q)+leftWindow])
            break
    counter += 1
    
print coords

# Writing from genome
counter = 0
while counter < nSeq:
    r = random.randint(0,len(genome)-seqSize)
    coord = [r,r+seqSize]
    if(not overlap(coord,coords)):
        outputFile.write(genome[coord[0]])
        for c in genome[coord[0]+1:coord[1]]: outputFile.write(","+c)
        outputFile.write("\n")
        counter += 1

# Termination
inputFile.close()
genomeFile.close()
outputFile.close()

