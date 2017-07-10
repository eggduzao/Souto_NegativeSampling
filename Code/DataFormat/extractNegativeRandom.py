######################################################################################################################
# Script to extract sequences to for the random set. These sequences are extracted randomly from the E. coli genome
# but they may not overlap any bp of the sequences that were extracted as positive.
##########
# Input:
# 1. leftWindow: How many bps to consider unexctractable from the left of the +1 of the positive sequences. Eg. 60.
# 2. rightWindow: How many bps to consider unexctractable from the right of the +1 of the positive sequences. Eg. 20.
# 3. positiveFileName: The file obtained from regulonDB containing known promoters.
# 4. genomeFileName: The genome file.
# 5. outputLocation: Location in which outputs will be writen.
##########
# Output:
# 1. rand.csv: The csv file containing the extracted sequences.
#####################################################################################################################

import sys
import random

# Reading input
leftWindow = int(sys.argv[1])
rightWindow = int(sys.argv[2])
positiveFileName = sys.argv[3]
genomeFileName = sys.argv[4]
outputLocation = sys.argv[5]
if(outputLocation[-1] != "/"): outputLocation += "/"

# File handling
positiveFile = open(positiveFileName,"r")
genomeFile = open(genomeFileName,"r")
outputFile = open(outputLocation+"rand.csv","w")

# Extracting genome
genome = []
for line in genomeFile:
    if(len(line) < 2 or line[0] == ">"): continue
    for e in list(line.strip()): genome.append(e)

# Fetching positive region (that negative sequences shall not overlap)
posRegions = [False] * len(genome)
allowedEvidence = ['TIM','RPF']
for line in positiveFile:
    if(len(line) < 2 or "#" in line): continue
    lineList = line.strip().split("\t")
    tss = int(lineList[3])
    evidenceList = [e[1:len(e)-1].split("|")[0] for e in lineList[6].split(",")]
    containEvidence = False
    for e in evidenceList:
        if(e in allowedEvidence):
            containEvidence = True
            break
    if(containEvidence and lineList[2] == "forward"):
        for i in range(tss-leftWindow,tss+rightWindow): posRegions[i] = True
    elif(containEvidence and lineList[2] == "reverse"):
        for i in range(tss-rightWindow,tss+leftWindow): posRegions[i] = True
# End for line in inputFile

# Extracting random regions and writing to file
seqCount = 0
desiredNoOfSequences = 812 # Modify this parameter to change the number of desired sequences 812
desiredSequenceSize = leftWindow + rightWindow # Modify this parameter to change the desired sequence size
while seqCount < desiredNoOfSequences:
    pos1 = random.randint(0,len(genome)-desiredSequenceSize)
    overlapPositive = False
    for i in range(pos1,pos1+desiredSequenceSize):
        if(posRegions[i]):
            overlapPositive = True
            break
    if(not overlapPositive):
        toWrite = [e+"," for e in genome[pos1:pos1+desiredSequenceSize]]
        toWrite[-1] = toWrite[-1][0]
        outputFile.write(("".join(toWrite)).lower()+"\n")
        seqCount += 1
# End while seqCount < desiredNoOfSequences

# Termination
positiveFile.close()
genomeFile.close()
outputFile.close()

