######################################################################################################################
# Script to check the dissimilarity of sequences between and within datasets.
##########
# Input:
# 1. randomSize: The size (# instances) of random set. If you dont want to plot a random set, use 0.
# 2. outputLocation: Location in which outputs will be writen.
# 3. inputList: A list of CSV files.
##########
# Output:
# 1. dissimilarity.txt: A text file containing the evaluated dissimilarities.
# 2. graph.png: A box plot.
#####################################################################################################################

# Import
import sys
import numpy as np
from pylab import *
import random

# Reading input
randomSize = int(sys.argv[1])
outputLocation = sys.argv[2]
if(outputLocation[-1] != "/"): outputLocation += "/"
inputList = sys.argv[3:]

# File handling
outputFile = open(outputLocation+"dissimilarity.txt","w")
outputFile.write("Databases (in order):")
for e in inputList: outputFile.write(" "+e.split("/")[-1].split(".")[0])
outputFile.write("\n\n")

# Storing sequences into vectors
sequenceSet = []
for e in inputList: sequenceSet.append([])
for i in range(0,len(inputList)):
    inputFile = open(inputList[i],"r")
    for line in inputFile:
        if(len(line) < 2): continue
        sequenceSet[i].append(("".join(line.strip().split(","))).upper())
    inputFile.close()
    
# Creating random set
seqLen = len(sequenceSet[0][0])
convDic = dict([(1,"A"),(2,"C"),(3,"G"),(4,"T")])
if(randomSize > 0):
    sequenceSet.append([])
    for i in range(0,randomSize):
        randSeq = ""
        for j in range(0,seqLen):
            randSeq += convDic[random.randint(1,4)]
        sequenceSet[-1].append(randSeq)
    inputList.append("Random")


# Auxliary funcions to evaluate dissimilarity measures
def hamming(sequence1, sequence2):
    diss = 0.0
    for i in range(0,len(sequence1)):
        if(sequence1[i] != sequence2[i]): diss += 1.0
    return diss/len(sequence1)

# Checking dissimilarities
hammingDissMean = []
hammingDissSd = []
hammingDataVectors = []
for s1 in range(0,len(sequenceSet)):
    hammingDissMean.append([0.0] * len(sequenceSet))
    hammingDissSd.append([0.0] * len(sequenceSet))
    hammingDataVectors.append([])
    seqs1 = sequenceSet[s1]
    for s2 in range(0,len(sequenceSet)):
        seqs2 = sequenceSet[s2]
        hamVec = []
        if(s1 == s2):
            for i in range(0,len(seqs1)-1):
                for j in range(i+1,len(seqs2)):
                    hamVec.append(hamming(seqs1[i],seqs2[j]))
        else:
            for i in range(0,len(seqs1)):
                for j in range(0,len(seqs2)):
                    hamVec.append(hamming(seqs1[i],seqs2[j]))
        hammingDissMean[s1][s2] = np.array(hamVec).mean()
        hammingDissSd[s1][s2] = np.array(hamVec).std()
        hammingDataVectors[s1].append(hamVec)
    # End for s2 in range(0,len(sequenceSet))
# End for s1 in range(0,len(sequenceSet))

# Writing results to file
outputFile.write("Hamming:\n             ")
for e in inputList:
    toWrite = e.split("/")[-1].split(".")[0]
    outputFile.write("\t"+toWrite[:min(len(toWrite),13)]+" "*(13-min(len(toWrite),13)))
outputFile.write("\n")
for i in range(0,len(hammingDissMean)):
    toWrite = inputList[i].split("/")[-1].split(".")[0]
    outputFile.write(toWrite[:min(len(toWrite),13)]+" "*(13-min(len(toWrite),13)))
    for j in range(0,len(hammingDissMean[i])):
        outputFile.write("\t"+str(round(100*hammingDissMean[i][j],2))+"% "+str(round(100*hammingDissSd[i][j],2))+"%")
    outputFile.write("\n")
outputFile.write("\n")

# Creating box plot

dataToPlot = []
tickNames = []
for i in range(0,len(hammingDataVectors)):
    tickNames.append(inputList[i].split("/")[-1].split(".")[0])
    dataToPlot.append(hammingDataVectors[i][i])
for i in range(0,len(hammingDataVectors)-1):
    for j in range((i+1),len(hammingDataVectors)):
        tickNames.append(inputList[i].split("/")[-1].split(".")[0]+" &\n"+inputList[j].split("/")[-1].split(".")[0])
        dataToPlot.append(hammingDataVectors[i][j])

fig = figure(figsize=(15, 8))
rcParams.update({'font.size': 8})
ax = fig.add_subplot(111)

ax.set_title("Dissimilarity Boxplot", size = 20, position = (0.5,1.04))

ax.yaxis.grid(True, linestyle='-', which='major', color='lightgrey', alpha=1.0)
ax.xaxis.grid(True, linestyle='--', which='major', color='grey', alpha=0.7)
ax.set_axisbelow(True)

ax.get_xaxis().set_label_text("Datasets",fontsize=16)
ax.get_xaxis().set_label_coords(0.5,-0.07)

ax.get_yaxis().set_label_text("Dissimilarity",fontsize=16)
ax.get_yaxis().set_label_coords(-0.04,0.5)

bp = boxplot(dataToPlot)

plt.setp(bp['medians'], color='red')
plt.setp(bp['caps'], color='black')
plt.setp(bp['boxes'], color='black')
plt.setp(bp['whiskers'], color='black')
plt.setp(bp['fliers'], color='red', marker='o', markersize = 5)

ax.get_xaxis().set_ticks(range(1,len(tickNames)+1))
ax.get_xaxis().set_ticklabels(tickNames)
axis([0,len(tickNames)+1,0.0,1.0])

fig.savefig("boxplot.eps", format="eps", dpi=300, bbox_inches='tight')

# Creating error plot

meanToPlot = [np.array(e).mean() for e in dataToPlot]
stdToPlot = [np.array(e).std() for e in dataToPlot]

fig = figure(figsize=(15, 8))
rcParams.update({'font.size': 8})
ax = fig.add_subplot(111)

ax.set_title("Dissimilarity CI", size = 20, position = (0.5,1.04))

ax.yaxis.grid(True, linestyle='-', which='major', color='lightgrey', alpha=1.0)
ax.xaxis.grid(True, linestyle='--', which='major', color='grey', alpha=0.7)
ax.set_axisbelow(True)

ax.get_xaxis().set_label_text("Datasets",fontsize=16)
ax.get_xaxis().set_label_coords(0.5,-0.07)

ax.get_yaxis().set_label_text("Dissimilarity",fontsize=16)
ax.get_yaxis().set_label_coords(-0.04,0.5)

eb = errorbar(range(1,len(dataToPlot)+1), meanToPlot, yerr=stdToPlot, ecolor = 'k', fmt='ro')

ax.get_xaxis().set_ticks(range(1,len(tickNames)+1))
ax.get_xaxis().set_ticklabels(tickNames)
axis([0,len(tickNames)+1,0.0,1.0])

fig.savefig("errorplot.eps", format="eps", dpi=300, bbox_inches='tight')

# Termination
outputFile.close()

