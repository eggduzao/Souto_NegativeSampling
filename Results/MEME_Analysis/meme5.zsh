#!/bin/zsh

# MEME
fList=( "rand" )
nMotifs="5"
minSites="100"
maxSites="750"
minWidth="3"
maxWidth="10"

for ff in $fList
do
    echo $ff
    seq1="/home/egg/Desktop/Ecoli/"$ff".fa"
    ol="/home/egg/Desktop/Ecoli/MEME2/"$ff"/"
    meme $seq1 -dna -nmotifs $nMotifs -minsites $minSites -maxsites $maxSites -revcomp -nostatus -minw $minWidth -maxw $maxWidth -mod zoops -maxsize 100000000 -oc $ol
done

