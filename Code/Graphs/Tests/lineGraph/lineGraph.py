######################################################################################################################
# Script to create a line graph based on an input specially formated.
##########
# Input:
# 1. inputFileName: Name of the input csv file.
# 2. outputLocation: Location in which outputs will be writen.
##########
# Output:
# 1. graph.png: A line plot.
#####################################################################################################################

# Import
import sys
from pylab import *

# Reading input
inputFileName = sys.argv[1]
outputLocation = sys.argv[2]
if(outputLocation[-1] != "/"): outputLocation += "/"

# File handling
inputFile = open(inputFileName,"r")
seriesNames = inputFile.readline().strip().split(",")

# Creating printing structures
xData = []
ySeries = []
for line in inputFile:
    if(len(line) < 2): continue
    lineList = line.strip().split(",")
    for i in range(0,len(lineList)):
        if(i == 0): 
            xData.append(int(lineList[i]))
            continue
        if(len(ySeries) < len(lineList) - 1):
            ySeries.append([float(lineList[i])])
        else:
            ySeries[i-1].append(float(lineList[i]))


# Printing graph
fig = figure()
rcParams.update({'font.size': 10})
ax = fig.add_subplot(111)

# Titles
ax.set_xlabel("Number of z-curve variables")
ax.set_ylabel("Statistics (%)")

# Line style and color
styles = ['-', '--', ':', '-.']
colors = ['black', 'blue', 'green', 'red', 'cyan', 'magenta', 'orange', 'purple']
markers = ['o', 'D', 's', '+', '*', 'd', 'v', '.']

# Plot data
for i in range(0,len(ySeries)):
    col = colors[i%len(colors)]
    mar = markers[i%len(markers)]
    lst = styles[i/len(colors)]
    ax.plot(xData, ySeries[i], color=col, linestyle=lst, marker=mar ,label=seriesNames[i])
    
# Limits on the axis
axis([min(xData),max(xData),0,100])

# Legend
box = ax.get_position()
ax.set_position([box.x0, box.y0 - 0.025, box.width, box.height])
legend(bbox_to_anchor=(0., 1.02, 1., .102), loc=3, ncol=4, borderaxespad=0.)

# Saving Figure
fig.savefig("graph.png", format="png", dpi=300)

# Termination
inputFile.close()

