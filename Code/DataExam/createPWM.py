######################################################################################################################
# Script to create a PWM from a set of sequences. All sequences must have the same length.
# Input formats allowed:
#     1. Sequence file (seq): nucleotides are not separated and sequences are separated by line break.
#     2. Comma separated values (csv): nucleotides are separated by comma and sequences are separated by line break.
##########
# Input:
# 1. inputFormat: Can be seq (sequence file) or csv (comma separated values).
# 2. inputFileLocation: The location to the input file.
# 3. outputLocation: Location in which outputs will be writen.
##########
# Output:
# 1. <inputFileName>.pfm: PWM in a JASPAR-like format.
# 2. <inputFileName>.log: A log containing tab separated versions of PWM and % PWM values.
#####################################################################################################################

import sys

# Reading input
inputFormat = sys.argv[1]
inputFileLocation = sys.argv[2]
outputLocation = sys.argv[3]
if(outputLocation[-1] != "/"): outputLocation += "/"

# Auxiliary dictionary
# A -> 0     C -> 1     G -> 2     T -> 3
nucDict = dict([("A",0),("C",1),("G",2),("T",3),("a",0),("c",1),("g",2),("t",3)])

# Counting nucleotide frequencies
pwm = []
first = True
totSeq = 0
inputFile = open(inputFileLocation,"r")
for line in inputFile:
    if(len(line) < 2): continue
    line = line.strip()
    if(inputFormat == "seq"): sequence = list(line)
    elif(inputFormat == "csv"): sequence = line.split(",")
    for i in range(0,len(sequence)):
        if(first):
            vec = [0] * 4
            vec[nucDict[sequence[i]]] = 1
            pwm.append(vec)
        else:
            pwm[i][nucDict[sequence[i]]] += 1
    totSeq += 1
    if(first): first = False
# end of for line in inputFile

# Fetching the name of the file
fileName = inputFileLocation.split("/")[-1].split(".")[0]

# Writing PWM
pfmFile = open(outputLocation+fileName+".pfm","w")
for j in range(0,len(pwm[0])):
    pfmFile.write(str(pwm[0][j]))
    for i in range(1,len(pwm)):
        pfmFile.write(" "+str(pwm[i][j]))
    pfmFile.write("\n")

# Writing log results
logFile = open(outputLocation+fileName+".pfmlog","w")
for j in range(0,len(pwm[0])):
    logFile.write(str(pwm[0][j]))
    for i in range(1,len(pwm)):
        logFile.write("\t"+str(pwm[i][j]))
    logFile.write("\n")
logFile.write("\n")

for j in range(0,len(pwm[0])):
    logFile.write(str(round(pwm[0][j]*100.0/totSeq,2))+"%")
    for i in range(1,len(pwm)):
        logFile.write("\t"+str(round(pwm[i][j]*100.0/totSeq,2))+"%")
    logFile.write("\n")

# Termination
inputFile.close()
pfmFile.close()
logFile.close()
