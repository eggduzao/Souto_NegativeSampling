#################################################################################################
# Creates a bar graph (with or without standard deviation lines).
#################################################################################################
params = []
params.append("###")
params.append("Input: ")
params.append("    1. outExt = Output Extension. Eg. png or eps.")
params.append("    2. useLegend = 'y' to use legend, 'n' to not use it.")
params.append("    3. graphTitle = Graph title.")
params.append("    4. yLabel = Label of the y axis.")
params.append("    5. inputFileName = The location + name of the input file.")
params.append("    6. outputLocation = Location of the output and temporary files.")
params.append("###")
params.append("Output: ")
params.append("    1. <inputFileName>.<outExt> = Resulting graph image file.")
params.append("###")
#################################################################################################

# Import
import os
import sys
import pylab
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.lines import Line2D
if(len(sys.argv) <= 1): 
    for e in params: print e
    sys.exit(0)

# Reading input
outExt = sys.argv[1]
useLegend = sys.argv[2]
graphTitle = " ".join(sys.argv[3].split(","))
yLabel = " ".join(sys.argv[4].split(","))
inputFileName = sys.argv[5]
outputLocation = sys.argv[6]
if(outputLocation[-1] != "/"): outputLocation+="/"

# Parameters
colorList = ["blue", "green", "red", "yellow"]

# Reading graph data
inputFile = open(inputFileName,"r")
graphType = inputFile.readline().strip()
serieLabels = inputFile.readline().strip().split(" ")
smallXLabels = inputFile.readline().strip().split(" ")
meanList = [[] for e in serieLabels]
errorList = [[] for e in serieLabels]
if(graphType == "error"):
    for line in inputFile:
        ll = [float(e) for e in line.strip().split(" ")]
        for i in range(0,len(meanList)):
            meanList[i].append(ll[(i*2)+0])
            errorList[i].append(ll[(i*2)+1])
elif(graphType == "bar"):
    for line in inputFile:
        ll = [float(e) for e in line.strip().split(" ")]
        for i in range(0,len(ll)): meanList[i].append(ll[i])
inputFile.close()

# Bar width
barWidth = 0.9/float(len(serieLabels))

# Creating figure
fig = plt.figure(figsize=(8,5), facecolor='w', edgecolor='k')
ax = fig.add_subplot(111)

# Plot
for i in range(0,len(meanList)):
    rectList = []
    if(graphType == "error"):
        indexes = [e+(i*barWidth) for e in range(0,len(meanList[i]))]
        rectList.append(ax.bar(indexes, meanList[i], barWidth, color=colorList[i], yerr=errorList[i], label=serieLabels[i], ecolor='k'))
    elif(graphType == "bar"):
        indexes = [e+(i*barWidth) for e in range(0,len(meanList[i]))]
        rectList.append(ax.bar(indexes, meanList[i], barWidth, color=colorList[i], label=serieLabels[i]))

# Line legend
useLegend = True
if(useLegend == "y"): leg = ax.legend(loc = (0.03, 0.80))

# Titles and Axis Labels
ax.set_title(graphTitle)
ax.set_ylabel(yLabel)

# Ticks
#ax.set_yticks()
ax.set_xticks([e+0.45 for e in range(0,len(smallXLabels))])
ax.set_xticklabels(smallXLabels)
for tick in ax.xaxis.get_major_ticks(): tick.label.set_fontsize(8)
for tick in ax.yaxis.get_major_ticks(): tick.label.set_fontsize(10)

# Axis Limits
plt.ylim([0,100])

# Saving figure
if(useLegend == "y"): fig.savefig(outputLocation+inputFileName.split("/")[-1].split(".")[0]+"."+outExt, format=outExt, dpi=600, bbox_inches='tight', bbox_extra_artists=[leg]) 
else: fig.savefig(outputLocation+inputFileName.split("/")[-1].split(".")[0]+"."+outExt, format=outExt, dpi=600, bbox_inches='tight') 


