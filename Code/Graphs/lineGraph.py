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
import numpy as np
from pylab import *

# Reading input
inputFileName = sys.argv[1]
outputLocation = sys.argv[2]
if(outputLocation[-1] != "/"): outputLocation += "/"

# File handling
inputFile = open(inputFileName,"r")

# Creating printing structures
xData = []
ySeries = []
for line in inputFile:
    if(len(line) < 2): continue
    lineList = line.strip().split(",")
    for i in range(0,len(lineList)):
        if(i == 0): 
            xData.append(int(v))
            continue
        if(len(ySeries) < len(lineList) - 1):
            ySeries.append([float(v)])
        else:
            ySeries[i-1].append(v)
            
print xData
for e in ySeries: print e

# Printing graph







# Termination
inputFile.close()











