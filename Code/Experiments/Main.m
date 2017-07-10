
clear all
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PARAMETERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
posFileName = 'Data/pos.csv';
negCod1FileName = 'Data/cod1.csv';
negCod2FileName = 'Data/cod2.csv';
negNonCodFileName = 'Data/ncod.csv';
negRandFileName = 'Data/rand.csv';
negMix1TrainFileName = 'Data/mix1_train.csv';
negMix1TestFileName = 'Data/mix1_test.csv';
negMix2TrainFileName = 'Data/mix2_train.csv';
negMix2TestFileName = 'Data/mix2_test.csv';
negCtrlFileName = 'Data/ctrl.csv';

outDiscFileName = 'Results/SequenceResults.txt';
outContFileName = 'Results/ZCurveResults.txt';
discGraphLocation = 'Results/disc/';
contGraphLocation = 'Results/cont/';
outFriedmanNemenyi = 'FriedmanNemenyi/';
outDatasetHypothesis = 'DatasetHypothesis/';
outBarGraph = 'BarGraph/';

nfoldnumber = 10;
foldnumber = 10;
windowSizeMax = 6;
featureNo = 300;
svmC = 0.5;
svmKernel = 'polynomial';
svmPolOrd = 3;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1.  Load the sequence input file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dataSetNames = {posFileName, negCod1FileName, negCod2FileName, negNonCodFileName, negRandFileName, negMix1TrainFileName, negMix2TrainFileName, negCtrlFileName};
dataSetTests = {negMix1TestFileName, negMix2TestFileName};
dataSetSequence = cell(1,size(dataSetNames,2));
dataSetTestsSequence = cell(1,size(dataSetTests,2));

for k = 1:size(dataSetNames,2)
    fileName = dataSetNames{k};
    inFile = fopen(fileName,'r');
    seqCellComma = textscan(inFile,'%s');
    seqCell = strrep(seqCellComma{1}, ',', '');
    dataSetSequence{k} = char(seqCell);
    fclose(inFile);
end
for k = 1:size(dataSetTests,2)
    fileName = dataSetTests{k};
    inFile = fopen(fileName,'r');
    seqCellComma = textscan(inFile,'%s');
    seqCell = strrep(seqCellComma{1}, ',', '');
    dataSetTestsSequence{k} = char(seqCell);
    fclose(inFile);
end
'Done Loading Data'

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2.  Perform the Z-curve evaluation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dataSetZcurve = cell(1,size(dataSetSequence,2));
dataSetZcurveTests = cell(1,size(dataSetTestsSequence,2));

for k = 1:size(dataSetSequence,2)
    
    % Initializing current dataset
    currDataset = dataSetSequence{k};
    
    % Fetching rows and cols
    currRow = size(currDataset,1);
    currCol = 0;
    for i = 1:windowSizeMax
        currCol = currCol + (3*(4^(i-1)));
    end
    
    % Initializing Z curve matrix
    currZcurve = zeros(currRow,currCol);
    
    % Creating Zcurve dataset
    for i = 1:currRow
        counter = 1;
        for j = 1:windowSizeMax
            parameters = vwzcurve(currDataset(i,:),j);
            for m=1:size(parameters,2)
                currZcurve(i,counter) = parameters(:,m);
                counter = counter + 1;
            end
        end
    end
    
    dataSetZcurve{k} = currZcurve;
    
end

for k = 1:size(dataSetTestsSequence,2)
    
    % Initializing current dataset
    currDataset = dataSetTestsSequence{k};
    
    % Fetching rows and cols
    currRow = size(currDataset,1);
    currCol = 0;
    for i = 1:windowSizeMax
        currCol = currCol + (3*(4^(i-1)));
    end
    
    % Initializing Z curve matrix
    currZcurve = zeros(currRow,currCol);
    
    % Creating Zcurve dataset
    for i = 1:currRow
        counter = 1;
        for j = 1:windowSizeMax
            parameters = vwzcurve(currDataset(i,:),j);
            for m=1:size(parameters,2)
                currZcurve(i,counter) = parameters(:,m);
                counter = counter + 1;
            end
        end
    end
    
    dataSetZcurveTests{k} = currZcurve;
    
end

'Done Z-curve Evaluation'

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3.  Adapt bases for some techniques
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Creating binary datasets
dataSetBinary = cell(1,size(dataSetSequence,2));
for k = 1:size(dataSetSequence,2)
    dataSetBinary{k} = binarize(dataSetSequence{k});
end
dataSetBinaryTests = cell(1,size(dataSetTestsSequence,2));
for k = 1:size(dataSetTestsSequence,2)
    dataSetBinaryTests{k} = binarize(dataSetTestsSequence{k});
end

% Creating categorized datasets
dataSetCategoric = cell(1,size(dataSetSequence,2));
for k = 1:size(dataSetSequence,2)
    dataSetCategoric{k} = categorize(dataSetSequence{k});
end
dataSetCategoricTests = cell(1,size(dataSetTestsSequence,2));
for k = 1:size(dataSetTestsSequence,2)
    dataSetCategoricTests{k} = categorize(dataSetTestsSequence{k});
end
'Done Adapting Datasets'

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 4.  Select Z-curve features and print Z-curve dataset
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Select features via B_index
featureSet = cell(1,size(dataSetZcurve,2)-1);
for k = 2:size(dataSetZcurve,2)
    featureSet{k-1} = plsFeatureSelection(dataSetZcurve{1}, dataSetZcurve{k}, foldnumber, featureNo);
end
featureSetTests = cell(1,size(dataSetZcurveTests,2)-1);
for k = 2:size(dataSetZcurveTests,2)
    featureSetTests{k-1} = plsFeatureSelection(dataSetZcurveTests{1}, dataSetZcurveTests{k}, foldnumber, featureNo);
end
'Done Feature Selection'

% Printing Zcurve datasets to csv
outZcurveFolders = {'DataZ/Cod1Feats/', 'DataZ/Cod2Feats/', 'DataZ/NcodFeats/', 'DataZ/RandFeats/', 'DataZ/Mix1TrainFeats/', 'DataZ/Mix2TrainFeats/', 'DataZ/CtrlFeats/'};
outZcurveNames = {'cod1.csv', 'cod2.csv', 'ncod.csv', 'rand.csv', 'mix1_train.csv', 'mix2_train.csv', 'ctrl.csv'};
for f = 1:size(outZcurveFolders,2)
    for k = 2:size(dataSetZcurve,2)
        csvwrite( [outZcurveFolders{f} outZcurveNames{k-1}] , [dataSetZcurve{1}(:,featureSet{f}) ; dataSetZcurve{k}(:,featureSet{f})] );
    end
end
'Done Printing Z-curve'

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 5.  Perform cross-validation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Sequence Predictions
[nbDiscS nbDiscR nbDiscH nbDiscFTR nbDiscFTS nbDiscSTD] = crossValidation(dataSetSequence,featureSet,dataSetTestsSequence,featureSetTests,'nb','disc',nfoldnumber,foldnumber,svmC,svmKernel,svmPolOrd);
'Done disc NB'
[dtDiscS dtDiscR dtDiscH dtDiscFTR dtDiscFTS dtDiscSTD] = crossValidation(dataSetCategoric,featureSet,dataSetCategoricTests,featureSetTests,'dt','disc',nfoldnumber,foldnumber,svmC,svmKernel,svmPolOrd);
'Done disc DT'
[svmDiscS svmDiscR svmDiscH svmDiscFTR svmDiscFTS svmDiscSTD] = crossValidation(dataSetBinary,featureSet,dataSetBinaryTests,featureSetTests,'svm','disc',nfoldnumber,foldnumber,svmC,svmKernel,svmPolOrd);
'Done disc SVM'

% Z-curve Predictions
[nbContS nbContR nbContH nbContFTR nbContFTS nbContSTD] = crossValidation(dataSetZcurve,featureSet,dataSetZcurveTests,featureSetTests,'nb','cont',nfoldnumber,foldnumber,svmC,svmKernel,svmPolOrd);
'Done cont NB'
[dtContS dtContR dtContH dtContFTR dtContFTS dtContSTD] = crossValidation(dataSetZcurve,featureSet,dataSetZcurveTests,featureSetTests,'dt','cont',nfoldnumber,foldnumber,svmC,svmKernel,svmPolOrd);
'Done cont DT'
[svmContS svmContR svmContH svmContFTR svmContFTS svmContSTD] = crossValidation(dataSetZcurve,featureSet,dataSetZcurveTests,featureSetTests,'svm','cont',nfoldnumber,foldnumber,svmC,svmKernel,svmPolOrd);
'Done cont SVM'
[plsContS plsContR plsContH plsContFTR plsContFTS plsContSTD] =  crossValidation(dataSetZcurve,featureSet,dataSetZcurveTests,featureSetTests,'pls','cont',nfoldnumber,foldnumber,svmC,svmKernel,svmPolOrd);
'Done cont PLS'

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 6.  Perform Hypothesis Test on Classifiers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

hyFileNames = {'cod1' , 'cod2' , 'ncod' , 'rand' , 'mix1' , 'mix2' , 'ctrl'};
hyMethodNames = {'NB' , 'DT' , 'SVM' , 'PLS'};

% Sequence
discALLH = {nbDiscH , dtDiscH , svmDiscH};
hDiscResFile = fopen('Hypothesis/sequence.txt','w');
for f1 = 1:size(hyFileNames,2)            % 1st database - right
    for f2 = 1:size(hyFileNames,2)        % 2nd database - left
        fprintf(hDiscResFile,'##### Train: %s  -  Test: %s\n',hyFileNames{f1},hyFileNames{f2});
        fprintf(hDiscResFile,'\tNB\t\t\tDT\t\t\tSVM\n');
        for c1 = 1:size(discALLH,2)       % 1st method
            fprintf(hDiscResFile,'%s',hyMethodNames{c1});
            for c2 = 1:size(discALLH,2)   % 2nd method
                if(c1 == c2)
                    fprintf(hDiscResFile,'\t                 ');
                else
                    [hypRes,pValue] = ttest(discALLH{c1}{f1,f2},discALLH{c2}{f1,f2},0.05,'both');
                    if(isnan(pValue) || pValue == 1)
                        fprintf(hDiscResFile,'\t(%d,1.000000e+00)',hypRes);
                    else
                        fprintf(hDiscResFile,'\t(%d,%s)',hypRes,pValue);
                    end
                end
            end
            fprintf(hDiscResFile,'\n');
        end
        fprintf(hDiscResFile,'\n');
    end
end

% Z-curve
contALLH = {nbContH , dtContH , svmContH , plsContH};
hContResFile = fopen('Hypothesis/Zcurve.txt','w');
for f1 = 1:size(hyFileNames,2)            % 1st database - right
    for f2 = 1:size(hyFileNames,2)        % 2nd database - left
        fprintf(hContResFile,'##### Train: %s  -  Test: %s\n',hyFileNames{f1},hyFileNames{f2});
        fprintf(hContResFile,'\tNB\t\t\tDT\t\t\tSVM\t\t\tPLS\n');
        for c1 = 1:size(contALLH,2)       % 1st method
            fprintf(hContResFile,'%s',hyMethodNames{c1});
            for c2 = 1:size(contALLH,2)   % 2nd method
                if(c1 == c2)
                    fprintf(hContResFile,'\t                 ');
                else
                    [hypRes,pValue] = ttest(contALLH{c1}{f1,f2},contALLH{c2}{f1,f2},0.05,'both');
                    if(isnan(pValue) || pValue == 1)
                        fprintf(hContResFile,'\t(%d,1.000000e+00)',hypRes);
                    else
                        fprintf(hContResFile,'\t(%d,%s)',hypRes,pValue);
                    end
                end
            end
            fprintf(hContResFile,'\n');
        end
        fprintf(hContResFile,'\n');
    end
end

fclose(hDiscResFile);
fclose(hContResFile);
'Done Hypothesis Testing on Classifiers'

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 7.  Writing results
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Initializations
setLabels = {'COD1      '; 'COD2      '; 'NCOD      '; 'RAND      '; 'MIX1      '; 'MIX2      '; 'CTRL      '};
setStats = {'Correct Rate'; 'Sensitivity'; 'Specificity'; 'PPV'; 'NPV'};
discFile = fopen(outDiscFileName,'w');
contFile = fopen(outContFileName,'w');

% Sequence Predictions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf(discFile,'##### Sequence Predictions #####\n');
fprintf(discFile,'# Format = (NB,DT,SVM)\n');
fprintf(discFile,'# Rows are the training sets and columns are the testing sets\n\n');
for k = 1:size(nbDiscR,3)
    fprintf(discFile,'# %s\n',setStats{k});
    fprintf(discFile,'TRAIN\\TEST\tCOD1              \tCOD2              \tNCOD              \tRAND              \tMIX1              \tMIX2              \tCTRL\n');
    for i = 1:size(nbDiscR,1)
        fprintf(discFile,'%s\t',setLabels{i});
        for j = 1:size(nbDiscR,2)
            fprintf(discFile,'(');
            if(nbDiscR(i,j,k) == 100.0)
                fprintf(discFile,'%3.1f, ',nbDiscR(i,j,k));
            else
                fprintf(discFile,'%2.2f, ',nbDiscR(i,j,k));
            end
            if(dtDiscR(i,j,k) == 100.0)
                fprintf(discFile,'%3.1f, ',dtDiscR(i,j,k));
            else
                fprintf(discFile,'%2.2f, ',dtDiscR(i,j,k));
            end
            if(svmDiscR(i,j,k) == 100.0)
                fprintf(discFile,'%3.1f)\t',svmDiscR(i,j,k));
            else
                fprintf(discFile,'%2.2f)\t',svmDiscR(i,j,k));
            end
        end
        fprintf(discFile,'\n');
    end
    fprintf(discFile,'\n');
end

% Z-Curve Predictions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf(contFile,'##### Z-Curve Predictions #####\n');
fprintf(contFile,'# Format = (NB,DT,SVM,PLS)\n');
fprintf(contFile,'# Rows are the training sets and columns are the testing sets\n\n');
for k = 1:size(nbContR,3)
    fprintf(contFile,'# %s\n',setStats{k});
    fprintf(contFile,'TRAIN\\TEST\tCOD1                    \tCOD2                    \tNCOD                    \tRAND                    \tMIX1                    \tMIX2                    \tCTRL\n');
    for i = 1:size(nbContR,1)
        fprintf(contFile,'%s\t',setLabels{i});
        for j = 1:size(nbContR,2)
            fprintf(contFile,'(');
            if(nbContR(i,j,k) == 100.0)
                fprintf(contFile,'%3.1f, ',nbContR(i,j,k));
            else
                fprintf(contFile,'%2.2f, ',nbContR(i,j,k));
            end
            if(dtContR(i,j,k) == 100.0)
                fprintf(contFile,'%3.1f, ',dtContR(i,j,k));
            else
                fprintf(contFile,'%2.2f, ',dtContR(i,j,k));
            end
            if(svmContR(i,j,k) == 100.0)
                fprintf(contFile,'%3.1f, ',svmContR(i,j,k));
            else
                fprintf(contFile,'%2.2f, ',svmContR(i,j,k));
            end
            if(plsContR(i,j,k) == 100.0)
                fprintf(contFile,'%3.1f)\t',plsContR(i,j,k));
            else
                fprintf(contFile,'%2.2f)\t',plsContR(i,j,k));
            end
        end
        fprintf(contFile,'\n');
    end
    fprintf(contFile,'\n');
end

% Termination
fclose(discFile);
fclose(contFile);
'Done Writing Results'

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 8. Input for Nemenyi Test
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Global Parameters
baseLabels = {'COD1' 'COD2' 'NCOD' 'RAND' 'MIX1' 'MIX2' 'CTRL'};

% Discrete Train
fList = {nbDiscFTR dtDiscFTR svmDiscFTR};
fLabel = {'NB' 'DT' 'SVM'};
outFileName = [ outFriedmanNemenyi 'train/disc/' ];
for k = 1:size(fList,2)
    for i3 = 1:size(fList{k},3)
        outFile = fopen([outFileName fLabel{k} '_' baseLabels{i3} '.txt'],'w');
        fprintf(outFile,'%d\t%d\tasc\n',size(fList{k},1),size(fList{k},2));
        for i1 = 1:size(fList{k},1)
            fprintf(outFile,'%3.4f',fList{k}(i1,1,i3));
            for i2 = 2:size(fList{k},2)
                fprintf(outFile,'\t%3.4f',fList{k}(i1,i2,i3));
            end
            fprintf(outFile,'\n');
        end
        fclose(outFile);
    end
end

% Discrete Test
fList = {nbDiscFTS dtDiscFTS svmDiscFTS};
fLabel = {'NB' 'DT' 'SVM'};
outFileName = [ outFriedmanNemenyi 'test/disc/' ];
for k = 1:size(fList,2)
    for i3 = 1:size(fList{k},3)
        outFile = fopen([outFileName fLabel{k} '_' baseLabels{i3} '.txt'],'w');
        fprintf(outFile,'%d\t%d\tasc\n',size(fList{k},1),size(fList{k},2));
        for i1 = 1:size(fList{k},1)
            fprintf(outFile,'%3.4f',fList{k}(i1,1,i3));
            for i2 = 2:size(fList{k},2)
                fprintf(outFile,'\t%3.4f',fList{k}(i1,i2,i3));
            end
            fprintf(outFile,'\n');
        end
        fclose(outFile);
    end
end

% Continuous Train
fList = {nbContFTR dtContFTR svmContFTR plsContFTR};
fLabel = {'NB' 'DT' 'SVM' 'PLS'};
outFileName = [ outFriedmanNemenyi 'train/cont/' ];
for k = 1:size(fList,2)
    for i3 = 1:size(fList{k},3)
        outFile = fopen([outFileName fLabel{k} '_' baseLabels{i3} '.txt'],'w');
        fprintf(outFile,'%d\t%d\tasc\n',size(fList{k},1),size(fList{k},2));
        for i1 = 1:size(fList{k},1)
            fprintf(outFile,'%3.4f',fList{k}(i1,1,i3));
            for i2 = 2:size(fList{k},2)
                fprintf(outFile,'\t%3.4f',fList{k}(i1,i2,i3));
            end
            fprintf(outFile,'\n');
        end
        fclose(outFile);
    end
end

% Continuous Test
fList = {nbContFTS dtContFTS svmContFTS plsContFTS};
fLabel = {'NB' 'DT' 'SVM' 'PLS'};
outFileName = [ outFriedmanNemenyi 'test/cont/' ];
for k = 1:size(fList,2)
    for i3 = 1:size(fList{k},3)
        outFile = fopen([outFileName fLabel{k} '_' baseLabels{i3} '.txt'],'w');
        fprintf(outFile,'%d\t%d\tasc\n',size(fList{k},1),size(fList{k},2));
        for i1 = 1:size(fList{k},1)
            fprintf(outFile,'%3.4f',fList{k}(i1,1,i3));
            for i2 = 2:size(fList{k},2)
                fprintf(outFile,'\t%3.4f',fList{k}(i1,i2,i3));
            end
            fprintf(outFile,'\n');
        end
        fclose(outFile);
    end
end
'Done Writing Friedman-Nemenyi Input'

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 9. Hypothesis Test on Datasets
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Global Parameters
baseLabels = {'COD1' 'COD2' 'NCOD' 'RAND' 'MIX1' 'MIX2' 'CTRL'};

% Discrete Train
fList = {nbDiscFTR dtDiscFTR svmDiscFTR};
fLabel = {'NB' 'DT' 'SVM'};
outFile = fopen([outDatasetHypothesis 'train_disc.txt'],'w');
for k = 1:size(fList,2)
    fprintf(outFile,['##### ' fLabel{k} ' #############################\n\n']);
    for i3 = 1:size(fList{k},3)
        fprintf(outFile,['### ' baseLabels{i3} '\n']);
        fprintf(outFile,'DATASETS\tCOD1\t\t\tCOD2\t\t\tNCOD\t\t\tRAND\t\t\tMIX1\t\t\tMIX2\t\t\tCTRL');
        for d1 = 1:size(fList{k},3)
            fprintf(outFile,['\n' baseLabels{d1} '\t']);
            for d2 = 1:size(fList{k},3)
                if(d1 == d2)
                    fprintf(outFile,'\t\t\t');
                else
                    [hypRes,pValue] = ttest(fList{k}(:,d1,i3),fList{k}(:,d2,i3),0.05,'both');
                    if(isnan(pValue) || pValue == 1)
                        fprintf(outFile,'\t(%d,1.000000e+00)',hypRes);
                    else
                        fprintf(outFile,'\t(%d,%s)',hypRes,pValue);
                    end
                end                
            end
        end
        fprintf(outFile,'\n\n');
    end
    fprintf(outFile,'\n');
end
fclose(outFile);

% Discrete Test
fList = {nbDiscFTS dtDiscFTS svmDiscFTS};
fLabel = {'NB' 'DT' 'SVM'};
outFile = fopen([outDatasetHypothesis 'test_disc.txt'],'w');
for k = 1:size(fList,2)
    fprintf(outFile,['##### ' fLabel{k} ' #############################\n\n']);
    for i3 = 1:size(fList{k},3)
        fprintf(outFile,['### ' baseLabels{i3} '\n']);
        fprintf(outFile,'DATASETS\tCOD1\t\t\tCOD2\t\t\tNCOD\t\t\tRAND\t\t\tMIX1\t\t\tMIX2\t\t\tCTRL');
        for d1 = 1:size(fList{k},3)
            fprintf(outFile,['\n' baseLabels{d1} '\t']);
            for d2 = 1:size(fList{k},3)
                if(d1 == d2)
                    fprintf(outFile,'\t\t\t');
                else
                    [hypRes,pValue] = ttest(fList{k}(:,d1,i3),fList{k}(:,d2,i3),0.05,'both');
                    if(isnan(pValue) || pValue == 1)
                        fprintf(outFile,'\t(%d,1.000000e+00)',hypRes);
                    else
                        fprintf(outFile,'\t(%d,%s)',hypRes,pValue);
                    end
                end                
            end
        end
        fprintf(outFile,'\n\n');
    end
    fprintf(outFile,'\n');
end
fclose(outFile);

% Continuous Train
fList = {nbContFTR dtContFTR svmContFTR plsContFTR};
fLabel = {'NB' 'DT' 'SVM' 'PLS'};
outFile = fopen([outDatasetHypothesis 'train_cont.txt'],'w');
for k = 1:size(fList,2)
    fprintf(outFile,['##### ' fLabel{k} ' #############################\n\n']);
    for i3 = 1:size(fList{k},3)
        fprintf(outFile,['### ' baseLabels{i3} '\n']);
        fprintf(outFile,'DATASETS\tCOD1\t\t\tCOD2\t\t\tNCOD\t\t\tRAND\t\t\tMIX1\t\t\tMIX2\t\t\tCTRL');
        for d1 = 1:size(fList{k},3)
            fprintf(outFile,['\n' baseLabels{d1} '\t']);
            for d2 = 1:size(fList{k},3)
                if(d1 == d2)
                    fprintf(outFile,'\t\t\t');
                else
                    [hypRes,pValue] = ttest(fList{k}(:,d1,i3),fList{k}(:,d2,i3),0.05,'both');
                    if(isnan(pValue) || pValue == 1)
                        fprintf(outFile,'\t(%d,1.000000e+00)',hypRes);
                    else
                        fprintf(outFile,'\t(%d,%s)',hypRes,pValue);
                    end
                end                
            end
        end
        fprintf(outFile,'\n\n');
    end
    fprintf(outFile,'\n');
end
fclose(outFile);

% Continuous Test
fList = {nbContFTS dtContFTS svmContFTS plsContFTS};
fLabel = {'NB' 'DT' 'SVM' 'PLS'};
outFile = fopen([outDatasetHypothesis 'test_cont.txt'],'w');
for k = 1:size(fList,2)
    fprintf(outFile,['##### ' fLabel{k} ' #############################\n\n']);
    for i3 = 1:size(fList{k},3)
        fprintf(outFile,['### ' baseLabels{i3} '\n']);
        fprintf(outFile,'DATASETS\tCOD1\t\t\tCOD2\t\t\tNCOD\t\t\tRAND\t\t\tMIX1\t\t\tMIX2\t\t\tCTRL');
        for d1 = 1:size(fList{k},3)
            fprintf(outFile,['\n' baseLabels{d1} '\t']);
            for d2 = 1:size(fList{k},3)
                if(d1 == d2)
                    fprintf(outFile,'\t\t\t');
                else
                    [hypRes,pValue] = ttest(fList{k}(:,d1,i3),fList{k}(:,d2,i3),0.05,'both');
                    if(isnan(pValue) || pValue == 1)
                        fprintf(outFile,'\t(%d,1.000000e+00)',hypRes);
                    else
                        fprintf(outFile,'\t(%d,%s)',hypRes,pValue);
                    end
                end                
            end
        end
        fprintf(outFile,'\n\n');
    end
    fprintf(outFile,'\n');
end
fclose(outFile);
'Done Hypothesis Test on Datasets'

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 10.  Graphs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

graphTitles = {'COD1'; 'COD2'; 'NCOD'; 'RAND'; 'MIX1'; 'MIX2'; 'CTRL'};
              
% Sequence Predictions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i = 1:size(nbDiscR,1)
    for j = 1:size(nbDiscR,2)
        toPlot = zeros(size(nbDiscR,3),3); % col = number of classifiers
        for k = 1:size(nbDiscR,3)
            toPlot(k,1) = nbDiscR(i,j,k);
            toPlot(k,2) = dtDiscR(i,j,k);
            toPlot(k,3) = svmDiscR(i,j,k);
        end
        h = bar(toPlot);
        title(['Train: ' char(graphTitles(i)) ' - Test: ' char(graphTitles(j))],'FontSize',16);
        set(h(1),'facecolor',[0.50 0.50 1.00]);
        set(h(2),'facecolor',[0.54 0.85 0.56]);
        set(h(3),'facecolor',[0.90 0.34 0.41]);
        ylabel('Rate (%)'); 
        legend('NB',1,'DT',2,'SVM',3);
        set(gca,'XTickLabel',setStats,'FontSize',9);
        axis([0.5 5.5 0 100]);
        saveas(gcf,[discGraphLocation char(graphTitles(i)) '_' char(graphTitles(j))], 'tif');
    end
end

% Writing sequence predictions to make matplotlib bar graphs
for i = 1:size(nbDiscR,1)
    for j = 1:size(nbDiscR,2)
        discFile = fopen([outBarGraph 'disc/' char(graphTitles(i)) '_' char(graphTitles(j)) '.txt'],'w');
        fprintf(discFile,'error\nNB DT SVN\nCorrectRate Sensitivity Specificity PPV NPV\n');
        for k = 1:size(nbDiscR,3)
            fprintf(discFile,'%3.2f %3.2f %3.2f %3.2f %3.2f %3.2f\n',nbDiscR(i,j,k),nbDiscSTD(i,j,k),dtDiscR(i,j,k),dtDiscSTD(i,j,k),svmDiscR(i,j,k),svmDiscSTD(i,j,k));
        end
        fclose(discFile);
    end
end

% Z-Curve Predictions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i = 1:size(nbContR,1)
    for j = 1:size(nbContR,2)
        toPlot = zeros(size(nbContR,3),4); % col = number of classifiers
        for k = 1:size(nbContR,3)
            toPlot(k,1) = nbContR(i,j,k);
            toPlot(k,2) = dtContR(i,j,k);
            toPlot(k,3) = svmContR(i,j,k);
            toPlot(k,4) = plsContR(i,j,k);
        end
        h = bar(toPlot);
        title(['Train: ' char(graphTitles(i)) ' - Test: ' char(graphTitles(j))],'FontSize',16);
        set(h(1),'facecolor',[0.50 0.50 1.00]);
        set(h(2),'facecolor',[0.54 0.85 0.56]);
        set(h(3),'facecolor',[0.90 0.34 0.41]);
        set(h(4),'facecolor',[0.94 0.92 0.40]);
        ylabel('Rate (%)'); 
        legend('NB',1,'DT',2,'SVM',3,'PLS',4);
        set(gca,'XTickLabel',setStats,'FontSize',9);
        axis([0.5 6.5 0 100]);
        saveas(gcf,[contGraphLocation char(graphTitles(i)) '_' char(graphTitles(j))], 'tif');
    end
end

% Writing z-curve predictions to make matplotlib bar graphs
for i = 1:size(nbContR,1)
    for j = 1:size(nbContR,2)
        contFile = fopen([outBarGraph 'cont/' char(graphTitles(i)) '_' char(graphTitles(j)) '.txt'],'w');
        fprintf(contFile,'error\nNB DT SVN PLS\nCorrectRate Sensitivity Specificity PPV NPV\n');
        for k = 1:size(nbContR,3)
            fprintf(contFile,'%3.2f %3.2f %3.2f %3.2f %3.2f %3.2f %3.2f %3.2f\n',nbContR(i,j,k),nbContSTD(i,j,k),dtContR(i,j,k),dtContSTD(i,j,k),svmContR(i,j,k),svmContSTD(i,j,k),plsContR(i,j,k),plsContSTD(i,j,k));
        end
        fclose(contFile);
    end
end
'Done Graphs'

%==========================================================================
