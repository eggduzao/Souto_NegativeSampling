######################################################################################################################
# Script to create a logo graphic from an .pfm file.
##########
# Input:
# 1. nucsPerImage: Number of nucleotides per image file. If the whole sequence is to be in the same image use 0.
#                  If more than 1 images are generated, they are labeled 1, 2, etc.
# 2. inputFileLocation: The location to the input file.
# 3. outputLocation: Location in which outputs will be writen.
##########
# Output:
# 1. <inputFileName>.png: The logo graphic.
#####################################################################################################################

import sys
import os
import math
from Bio import Motif

# Reading input
nucsPerImage = int(sys.argv[1])
inputFileLocation = sys.argv[2]
outputLocation = sys.argv[3]

# Reading pfm file
inputFile = open(inputFileLocation,"r")
pwm = Motif.read(inputFile,"jaspar-pfm")

# Writing whole or splited logo
if(nucsPerImage <= 0):
    pwm.weblogo(outputLocation+(inputFileLocation.split("/")[-1].split(".")[0])+".png",res=300)
else:
    tempPWM = [[],[],[],[]]
    nucs = ["A","C","G","T"]
    counter = 0
    fileCount = 0
    for i in range(0,len(pwm)):
        for j in range(0,len(nucs)): tempPWM[j].append(pwm.counts[nucs[j]][i])
        counter += 1
        if(counter == nucsPerImage):
            fileCount += 1
            tempFile = open("temp"+str(fileCount)+".motif","w")
            for vec in tempPWM:
                tempFile.write(str(vec[0]))
                for v in vec[1:]: tempFile.write(" "+str(v))
                tempFile.write("\n")
            tempFile.close()
            tempPWM = [[],[],[],[]]
            counter = 0
    if(len(tempPWM[0]) > 0):
        fileCount += 1
        tempFile = open("temp"+str(fileCount)+".motif","w")
        for vec in tempPWM:
            tempFile.write(str(vec[0]))
            for v in vec[1:]: tempFile.write(" "+str(v))
            tempFile.write("\n")
        tempFile.close()
        
    # Writing logos
    quantOut = int(math.ceil(float(len(pwm))/nucsPerImage))
    for i in range(0,quantOut):
        tempFile = open("temp"+str(i+1)+".motif","r")
        pwm = Motif.read(tempFile,"jaspar-pfm")
        pwm.weblogo(outputLocation+(inputFileLocation.split("/")[-1].split(".")[0])+"_"+str(i+1)+".png",res=300)
        tempFile.close()
        os.remove("temp"+str(i+1)+".motif")

# Termination
inputFile.close()

