
# Import
import os
import sys
import glob

# Parameters
outExt = "png"
useLegend = "y"
yLabel = "Percentage"

# Execution
for fileName in glob.glob("./disc/*.txt"):
    graphTitle = fileName.split("/")[-1].split(".")[0]
    os.system("python barGraph.py "+outExt+" "+useLegend+" "+graphTitle+" "+yLabel+" "+fileName+" ./disc/\n")
for fileName in glob.glob("./cont/*.txt"):
    graphTitle = fileName.split("/")[-1].split(".")[0]
    os.system("python barGraph.py "+outExt+" "+useLegend+" "+graphTitle+" "+yLabel+" "+fileName+" ./cont/\n")







