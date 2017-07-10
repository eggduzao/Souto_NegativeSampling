######################################################################################################################
# Script to align sequences.
##########
# Input:
# 1. alignType: Alignment type. Can be global, local and semi.
# 2. matchScore: Match score.
# 3. missScore: Missmatch score.
# 4. gapScore: Gap score.
# 5. threshold: Only alignments whose score >= threshold will be written.
# 6. inputFileName1: File representing the dataset 1.
# 7. inputFileName2: File representing the dataset 2.
# 8. outputLocation: Location in which outputs will be writen.
##########
# Output:
# 1. <alignType>_<matchScore>_<missScore>_<gapScore>_<inputFileName1>_<inputFileName2>.txt: Results of the alignment.
#####################################################################################################################

import os
import sys
import random

# Reading input
alignType = sys.argv[1]
matchScore = float(sys.argv[2])
missScore = float(sys.argv[3])
gapScore = float(sys.argv[4])
threshold = float(sys.argv[5])
inputFileName1 = sys.argv[6]
inputFileName2 = sys.argv[7]
outputLocation = sys.argv[8]

# Constants
UP = 0
CORN = 1
LEFT = 2
STOP = 3

# File handling
inputFile1 = open(inputFileName1,"r")
inputFile2 = open(inputFileName2,"r")
outFile = open(outputLocation+alignType+"_"+str(matchScore)+"_"+str(missScore)+"_"+str(gapScore)+"_"+inputFileName1.split("/")[-1].split(".")[0]+"_"+inputFileName2.split("/")[-1].split(".")[0]+".txt","w")

# Reading input sequences
seqList1 = []; seqList2 = []
for line in inputFile1: seqList1.append(("".join(line.strip().split(","))).upper())
for line in inputFile2: seqList2.append(("".join(line.strip().split(","))).upper())

# Global alignment method
def globalAlignment(s1,s2,matchScore,missScore,gapScore):
   
    # Initializations
    matrix = [[0.0]*(len(s2)+1) for e in range(0,len(s1)+1)]
    path = [[0.0]*(len(s2)+1) for e in range(0,len(s1)+1)]
    for i in range(0,len(s1)+1):
        matrix[i][0] = i*gapScore
        path[i][0] = UP
    for j in range(0,len(s2)+1):
        matrix[0][j] = j*gapScore
        path[0][j] = LEFT

    # Evaluating matrix
    for i in range(1,len(s1)+1):
        for j in range(1,len(s2)+1):
            # UP, CORNER, LEFT
            if(s1[i-1] == s2[j-1]): corn = matrix[i-1][j-1] + matchScore
            else: corn = matrix[i-1][j-1] + missScore
            values = [matrix[i-1][j]+gapScore,corn,matrix[i][j-1]+gapScore]
            maximum = max(values)
            matrix[i][j] = maximum
            index = values.index(maximum)
            if(index == 0): path[i][j] = UP
            elif(index == 1): path[i][j] = CORN
            elif(index == 2): path[i][j] = LEFT

    # Backtracking
    i = len(s1); j = len(s2); score = matrix[i][j]; alig1 = ""; alig2 = ""; aligStr = ""
    while(i > 0 or j > 0):
        if(path[i][j] == UP):
            alig1 = s1[i-1] + alig1
            alig2 = " " + alig2
            aligStr = " " + aligStr
            i -= 1
        elif(path[i][j] == LEFT):
            alig1 = " " + alig1
            alig2 = s2[j-1] + alig2
            aligStr = " " + aligStr
            j -= 1
        elif(path[i][j] == CORN):
            alig1 = s1[i-1] + alig1
            alig2 = s2[j-1] + alig2
            if(s1[i-1] == s2[j-1]): aligStr = "|" + aligStr
            else: aligStr = "." + aligStr
            i -= 1
            j -= 1

    return score, alig1, alig2, aligStr

# Local alignment method
def localAlignment(s1,s2,matchScore,missScore,gapScore):

    # Initializations
    matrix = [[0.0]*(len(s2)+1) for e in range(0,len(s1)+1)]
    path = [[0.0]*(len(s2)+1) for e in range(0,len(s1)+1)]
    for i in range(0,len(s1)+1): path[i][0] = STOP
    for j in range(0,len(s2)+1): path[0][j] = STOP

    # Evaluating matrix
    for i in range(1,len(s1)+1):
        for j in range(1,len(s2)+1):
            # UP, CORNER, LEFT
            if(s1[i-1] == s2[j-1]): corn = matrix[i-1][j-1] + matchScore
            else: corn = matrix[i-1][j-1] + missScore
            values = [matrix[i-1][j]+gapScore,corn,matrix[i][j-1]+gapScore,0]
            maximum = max(values)
            matrix[i][j] = maximum
            index = values.index(maximum)
            if(index == 0): path[i][j] = UP
            elif(index == 1): path[i][j] = CORN
            elif(index == 2): path[i][j] = LEFT
            elif(index == 3): path[i][j] = STOP

    # Backtracking
    i = 0; j = 0; maxV = 0.0
    for m in range(0,len(s1)+1):
        for n in range(0,len(s2)+1):
            if(matrix[m][n] > maxV):
                maxV = matrix[m][n]
                i = m
                j = n
    score = matrix[i][j]; alig1 = s1[i:]; alig2 = s2[j:]; aligStr = ""
    if(len(alig1) < len(alig2)): alig1 = alig1 + (" "*(len(alig2)-len(alig1)))
    else: alig2 = alig2 + (" "*(len(alig1)-len(alig2)))
    for k in range(0,len(alig1)):
        if(alig1[k] == " " or alig2[k] == " "): aligStr = aligStr + " "        
        elif(alig1[k] == alig2[k]): aligStr = aligStr + "|"
        else: aligStr = aligStr + "."
    while(i > 0 or j > 0):
        if(path[i][j] == UP):
            alig1 = s1[i-1] + alig1
            alig2 = " " + alig2
            aligStr = " " + aligStr
            i -= 1
        elif(path[i][j] == LEFT):
            alig1 = " " + alig1
            alig2 = s2[j-1] + alig2
            aligStr = " " + aligStr
            j -= 1
        elif(path[i][j] == CORN):
            alig1 = s1[i-1] + alig1
            alig2 = s2[j-1] + alig2
            if(s1[i-1] == s2[j-1]): aligStr = "|" + aligStr
            else: aligStr = "." + aligStr
            i -= 1
            j -= 1
        elif(path[i][j] == STOP):
            alig1 = s1[:i] + alig1; alig2 = s2[:j] + alig2
            if(len(s1[:i]) < len(s2[:j])): alig1 = (" "*(len(s2[:j])-len(s1[:i]))) + alig1
            else: alig2 = (" "*(len(s1[:i])-len(s2[:j]))) + alig2
            for k in range(max(len(s1[:i]),len(s2[:j]))-1,-1,-1):
                if(alig1[k] == " " or alig2[k] == " "): aligStr = " " + aligStr      
                elif(alig1[k] == alig2[k]): aligStr = "|" + aligStr
                else: aligStr = "." + aligStr
            break

    return score, alig1, alig2, aligStr

# Semi-Global alignment method
# ----------AAAAAAAAGGGGGGG
# CCCCCCCCCCAAAAAAAA-------
def semiGlobalAlignment(s1,s2,matchScore,missScore,gapScore):

    # Initializations
    matrix = [[0.0]*(len(s2)+1) for e in range(0,len(s1)+1)]
    path = [[0.0]*(len(s2)+1) for e in range(0,len(s1)+1)]
    for i in range(0,len(s1)+1): path[i][0] = UP
    for j in range(0,len(s2)+1):
        matrix[0][j] = j*gapScore
        path[0][j] = LEFT

    # Evaluating matrix
    for i in range(1,len(s1)+1):
        for j in range(1,len(s2)+1):
            # UP, CORNER, LEFT
            if(s1[i-1] == s2[j-1]): corn = matrix[i-1][j-1] + matchScore
            else: corn = matrix[i-1][j-1] + missScore
            values = [matrix[i-1][j]+gapScore,corn,matrix[i][j-1]+gapScore]
            maximum = max(values)
            matrix[i][j] = maximum
            index = values.index(maximum)
            if(index == 0): path[i][j] = UP
            elif(index == 1): path[i][j] = CORN
            elif(index == 2): path[i][j] = LEFT

    # Backtracking
    i = 0; j = len(s2); value = -99999
    for k in range(0,len(s1)+1):
        if(value < matrix[k][j]):
            value = matrix[k][j]
            i = k
    score = matrix[i][j]; alig1 = s1[i:]; alig2 = " "*(len(s1[i:])); aligStr = " "*(len(s1[i:]))
    while(i > 0 or j > 0):
        if(path[i][j] == UP):
            alig1 = s1[i-1] + alig1
            alig2 = " " + alig2
            aligStr = " " + aligStr
            i -= 1
        elif(path[i][j] == LEFT):
            alig1 = " " + alig1
            alig2 = s2[j-1] + alig2
            aligStr = " " + aligStr
            j -= 1
        elif(path[i][j] == CORN):
            alig1 = s1[i-1] + alig1
            alig2 = s2[j-1] + alig2
            if(s1[i-1] == s2[j-1]): aligStr = "|" + aligStr
            else: aligStr = "." + aligStr
            i -= 1
            j -= 1

    return score, alig1, alig2, aligStr

# Performing alignment and writing results
counter1 = 1
for s1 in seqList1:
    outFile.write("### Seq "+str(counter1)+" ################################################################\n")
    counter2 = 1
    for s2 in seqList2:
        if(alignType == "global"): score, alig1, alig2, aligStr = globalAlignment(s1,s2,matchScore,missScore,gapScore)
        elif(alignType == "local"): score, alig1, alig2, aligStr = localAlignment(s1,s2,matchScore,missScore,gapScore)
        elif(alignType == "semi"):
            score_1, alig1_1, alig2_1, aligStr_1 = semiGlobalAlignment(s1,s2,matchScore,missScore,gapScore)
            score_2, alig1_2, alig2_2, aligStr_2 = semiGlobalAlignment(s2,s1,matchScore,missScore,gapScore)
            if(score_1 > score_2): score = score_1; alig1 = alig1_1; alig2 = alig2_1; aligStr = aligStr_1
            else: score = score_2; alig1 = alig1_2; alig2 = alig2_2; aligStr = aligStr_2
        if(score >= threshold): outFile.write("# Seq "+str(counter2)+" = "+str(score)+"\n"+alig1+"\n"+aligStr+"\n"+alig2+"\n")
        counter2 += 1
    counter1 += 1

# Termination
inputFile1.close()
inputFile2.close()
outFile.close()


