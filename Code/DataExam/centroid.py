
# Import
import sys
import math

# Reading input
outputLocation = sys.argv[1]
if(outputLocation[-1] != "/"): outputLocation += "/"
inputList = sys.argv[2:]

# File handling
outputFile = open(outputLocation+"centroid.txt","w")
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
        sequenceSet[i].append([float(e) for e in line.strip().split(",")])
    inputFile.close()

# Evaluating Centroids
centroids = []
for k in range(0,len(sequenceSet)):
    centroid = [0.0] * len(sequenceSet[k][0])
    for j in range(0,len(sequenceSet[k][0])):
        for i in range(0,len(sequenceSet[k])):
            centroid[j] += sequenceSet[k][i][j]
    for j in range(0,len(centroid)): centroid[j] = centroid[j] / len(sequenceSet[k])
    centroids.append(centroid)
    
#print "centroids"
#for e in centroids: print e
#print "\n"

# Auxliary funcions to evaluate dissimilarity measures
def euclidean(sequence1, sequence2):
    diss = 0.0
    for i in range(0,len(sequence1)):
        diss += ((sequence1[i] - sequence2[i])**2)
    return math.sqrt(diss)

# Evaluating distance between centroids
# When i != j = Evaluating the distance between these centroids
# When i == j = Evaluating the mean of the distance between the centroid i == j and each element of the set i == j
for i in range(0,len(centroids)):
    for j in range(0,len(centroids)):
        #print "Iteration i = "+str(i)+" "+str(j)
        #print centroid[i]
        #print centroid[j]
        if(i == j):
            mean = 0.0
            counter = 0.0
            for m in range(0,len(sequenceSet[i])):
                dist = euclidean(centroids[i],sequenceSet[i][m])
                mean += dist
                counter += 1.0
            mean = mean / counter
            outputFile.write(str(round(mean,2))+"\t")
        else:
            outputFile.write(str(round(euclidean(centroids[i],centroids[j]),2))+"\t")
        #print ""
    outputFile.write("\n")

