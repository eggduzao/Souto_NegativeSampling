######################################################################################################################
# Script to create a random nucleotide set
##########
# Input:
# 1. seqLen: The length of each sequence.
# 2. totalSeq: The total number of sequences.
# 3. outputLocation: Location in which outputs will be writen.
##########
# Output:
# 1. ctrl.csv: The csv file containing the random dataset.
#####################################################################################################################

import sys
import random

# Reading input
seqLen = int(sys.argv[1])
totalSeq = int(sys.argv[2])
outputLocation = sys.argv[3]
if(outputLocation[-1] != "/"): outputLocation += "/"

# File handling
outputFile = open(outputLocation+"ctrl.csv","w")

# Creating dataset
nucDict = dict([(0,"a"),(1,"c"),(2,"g"),(3,"t")])
for i in range(0,totalSeq):
    seq = ""
    for j in range(0,seqLen): seq += nucDict[random.randint(0,3)]+","
    outputFile.write(seq[:len(seq)-1]+"\n")

# Termination
outputFile.close()

