######################################################################################################################
# Script to create a mixed set from randomly sampled sequences from 2 other sets.
##########
# Input:
# 1. percentage: Percentage of sequences to retrieve from each file. E.g. 0.5
# 2. inputFileName1: File representing the dataset 1.
# 3. inputFileName2: File representing the dataset 2.
# 4. outputLocation: Location in which outputs will be writen.
##########
# Output:
# 1. mix_1.csv: The csv file containing the mix dataset.
# 2. mix_2.csv: The csv file containing the remaining sequences.
#####################################################################################################################

import sys
import random

# Reading input
percentage = float(sys.argv[1])
inputFileName1 = sys.argv[2]
inputFileName2 = sys.argv[3]
outputLocation = sys.argv[4]
if(outputLocation[-1] != "/"): outputLocation += "/"

# File handling
inputFile1 = open(inputFileName1,"r")
inputFile2 = open(inputFileName2,"r")
outputFile1 = open(outputLocation+"mix_1.csv","w")
outputFile2 = open(outputLocation+"mix_2.csv","w")

# Storing sequences
inputList1 = []
inputList2 = []
for line in inputFile1:
    if(len(line) < 2): continue
    inputList1.append(line.strip())
for line in inputFile2:
    if(len(line) < 2): continue
    inputList2.append(line.strip())

# Extracting the desired proportion of sequences
seqNo1 = percentage * len(inputList1)
seqNo2 = percentage * len(inputList2)
toWrite2 = []
while len(inputList1) > seqNo1:
    r = random.randint(0,len(inputList1)-1)
    toWrite2.append(inputList1.pop(r))
while len(inputList2) > seqNo2:
    r = random.randint(0,len(inputList2)-1)
    toWrite2.append(inputList2.pop(r))

# Scramble set
toWrite = inputList1 + inputList2
for i in range(0,1000):
    r1 = random.randint(0,len(toWrite)-1)
    r2 = random.randint(0,len(toWrite)-1)
    temp = toWrite[r1]
    toWrite[r1] = toWrite[r2]
    toWrite[r2] = temp
for i in range(0,1000):
    r1 = random.randint(0,len(toWrite2)-1)
    r2 = random.randint(0,len(toWrite2)-1)
    temp = toWrite2[r1]
    toWrite2[r1] = toWrite2[r2]
    toWrite2[r2] = temp

# Writing coding sequences
for e in toWrite: outputFile1.write(e+"\n")
for e in toWrite2: outputFile2.write(e+"\n")

# Termination
inputFile1.close()
inputFile2.close()
outputFile1.close()
outputFile2.close()


