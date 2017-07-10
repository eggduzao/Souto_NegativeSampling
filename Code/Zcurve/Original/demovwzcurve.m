clear all
clc
echo on
%This script demonstrates the use of the variable-window Z-curve (vw Z-curve) method and partial
%least squares (PLS) method to recognize promoter sequences from non-promoter
%sequences.
%For given sequence samples, this program outputs the prediction
%performance: average accuracy, sensitivity, specificity.
%The vw Z-curve method is used to extract features of DNA sequences
%partial least squares (PLS) method is as supervised classifier.

%The details of the methodology of this proposed method please refer to
%"Recognition of prokaryotic promoters based on a novel variable-window
%Z-curve method".

% Kai Song (ksong@tju.edu.cn), 2011
%School of Chemical Engineering and Technology, Tianjin University, Tianjin, 300072, China
%Institute of Life Science and Biotechnology, Tianjin University, Tianjin, 300072, China

%pause
echo off

load possequence.mat  %load the features of positive samples extracted by vw Z-curve method
load negsequence.mat  %load the features of negative samples extracted by vw Z-curve method

row=size(possequence,1); %calculate the number of the positive samples

foldnumber=10; %To overcome the randomicity of samples, ten-fold leave-one-out method is performed as the cross-validation jackknife test

for i=1:row   %calculate the vw Z-curve parameters of positive samples (windowsize=1...6)
    parameter1=vwzcurve(possequence(i,:),1);
    pos1(i,:)=parameter1;

    parameter2=vwzcurve(possequence(i,:),2);
    pos2(i,:)=parameter2;

    parameter3=vwzcurve(possequence(i,:),3);
    pos3(i,:)=parameter3;

    parameter4=vwzcurve(possequence(i,:),4);
    pos4(i,:)=parameter4;

    parameter5=vwzcurve(possequence(i,:),5);
    pos5(i,:)=parameter5;

    parameter6=vwzcurve(possequence(i,:),6);
    pos6(i,:)=parameter6;
end
positive=[pos1 pos2 pos3 pos4 pos5 pos6];

for i=1:row %calculate the vw Z-curve parameters of negative samples (windowsize=1...6)
    parameter1=vwzcurve(negsequence(i,:),1);
    neg1(i,:)=parameter1;

    parameter2=vwzcurve(negsequence(i,:),2);
    neg2(i,:)=parameter2;

    parameter3=vwzcurve(negsequence(i,:),3);
    neg3(i,:)=parameter3;

    parameter4=vwzcurve(negsequence(i,:),4);
    neg4(i,:)=parameter4;

    parameter5=vwzcurve(negsequence(i,:),5);
    neg5(i,:)=parameter5;

    parameter6=vwzcurve(negsequence(i,:),6);
    neg6(i,:)=parameter6;
end
negative=[neg1 neg2 neg3 neg4 neg5 neg6];

[Bmean results]=crossvalidation(positive, negative, foldnumber);

for number=500:20:700
    [Y,index]=sort(abs(Bmean),1,'descend');  %Sorting the absolute values of the elements of Bmean in descending order
    index=index(1:number); %The selected number of the vw Z-curve features should be optimized to make the prediction accuracy high enough
    pos=positive(:,index);%Selecting given number vw Z-curve features of the positive samples with the largest absolute coefficient values
    neg=negative(:,index);%Selecting given number vw Z-curve features of the negative samples with the largest absolute coefficient values
    [B results]=crossvalidation(pos, neg, foldnumber); %use the cross-validation procedure to assess the prediction performance of these selected variables.
    results
end
%==========================================================================
