function [Bmean results]=crossvalidation(positive, negative, foldnumber)

row=size(positive,1); %calculate the number of the positive samples
foldlength=fix(row/foldnumber);
for k=1:foldnumber
    xtestp=positive((k-1)*foldlength+1:k*foldlength,:);      %the dataset is divided into 10 parts and tested on the 10 different one-tenths while trained on the remaining nine-tenths.
    extemp=positive;
    extemp((k-1)*foldlength+1:k*foldlength,:)=[];
    xtrainp=extemp;        %get the positive training samples
    rowtrain=9*foldlength;
    
    xtestn=negative((k-1)*foldlength+1:k*foldlength,:); %get the negative testing samples
    intemp=negative;
    intemp((k-1)*foldlength+1:k*foldlength,:)=[];
    xtrainn=intemp;         %get the negative training samples
    
    xtraintemp=[xtrainp
        xtrainn];
    [xtrain,mtrain,stdtrain]=autosc(xtraintemp); %scale training samples by its means and standard deviations.
    labelp=ones(rowtrain,1); %set the labels of the positive samples equal to 1
    labeln=-1*ones(rowtrain,1); %set the labels of the positive samples equal to -1
    labeltrain=[labelp
        labeln];
    xtesttemp=[xtestp
        xtestn];
    xtest=scal(xtesttemp,mtrain,stdtrain);   %scale testing samples by the means and standard deviations of the training samples.

    [T,W,p,u,B]=pls(xtrain,labeltrain,1) ;%The values of the elements of B could be used to evaluate the importance of the vw Z-curve features.
    %h is the number of the latent variables required in the model, for example h=2.
    Btemp(:,k)=B;
    labelpred=sign(xtest*B);
    TP(k)=size(find(labelpred(1:foldlength,1).*ones(foldlength,1)==1),1); %true positive
    FN(k)=size(find(labelpred(1:foldlength,1).*ones(foldlength,1)==-1),1); %false negative
    sn(k)=TP(k)/(TP(k)+FN(k)); %calculate the prediction sensitivity of the model
    TN(k)=size(find(labelpred(foldlength+1:foldlength*2,1).*(-1*ones(foldlength,1))==1),1); %true negative
    FP(k)=size(find(labelpred(foldlength+1:foldlength*2,1).*(-1*ones(foldlength,1))==-1),1); %false positive
    sp(k)=TN(k)/(TN(k)+FP(k));  %calculate the prediction specificity of the model
    a(k)=mean([sn(k) sp(k)]);   %calculate the prediction accuracy (the average of the sensitivity and specificity) of the model
end

snmean=mean(sn); %calculate the mean prediction sensitivity of the ten-fold cross-validation
spmean=mean(sp); %calculate the mean prediction specificity of the ten-fold cross-validation
amean=mean(a);   %calculate the mean prediction accuracy of the ten-fold cross-validation
Bmean=mean(Btemp,2);
results=[snmean spmean amean].*100;
end