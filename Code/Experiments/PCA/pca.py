
# Import

import os
import sys
from matplotlib.mlab import PCA
import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

# Input
fileList = sys.argv[1:]
outLocation = "/".join(fileList[0].split("/")[:-1])+"/"

# Parameters
colorList = ["green", "blue", "red", "orange", "purple"]

# Reading input
datasets = []
for fileName in fileList:
    dataMatrix = []
    inFile = open(fileName,"r")
    for line in inFile:
        dataMatrix.append([float(e) for e in line.strip().split(",")])
    inFile.close()
    datasets.append(dataMatrix)

###############

# Performing PCA
resultList = []
for dataset in datasets:
    npDataset = np.array(dataset)
    resultList.append(PCA(npDataset))

# Recording variance percentage
varString = ""
for i in range(0,len(resultList)): varString += fileList[i].split("/")[-1].split(".")[0]+"="+str(round(sum(resultList[i].fracs[:3]),4))+" "

############### STD GRAPH
"""
# Creating figure
fig = plt.figure(figsize=(8,5), facecolor='w', edgecolor='k')
ax = fig.add_subplot(111)

# Plot
for i in range(0,len(resultList)):
    summVec = [0.0]
    for v in resultList[i].fracs:
        summVec.append(v+summVec[-1])
    plt.plot(range(0,len(summVec)), summVec, color=colorList[i])

plt.show()

############### PCA GRAPH
"""
# Creating figure
fig = plt.figure(figsize=(8,5), facecolor='w', edgecolor='k')
ax = Axes3D(fig)

# Plot
for i in range(0,len(resultList)):
    x = []; y = []; z = []
    for item in resultList[i].Y:
        x.append(item[0])
        y.append(item[1])
        z.append(item[2])
    pltData = [x,y,z]
    ax.scatter(pltData[0], pltData[1], pltData[2], 'bo', color=colorList[i])

ax.set_xlabel("1st component") 
ax.set_ylabel("2nd component")
ax.set_zlabel("3rd component")
ax.set_title(varString)
plt.show() # show the plot


