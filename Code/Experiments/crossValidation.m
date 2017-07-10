function [S,R,H,FTR,FTS,STD] = crossValidation(datasets, fSet, datasetsTests, fSetTests, classifType, dataType, nFoldNumber, foldNumber, svmC, svmKernel, svmPolOrd)

% Initializations
numberDatasets = size(datasets,2)-1;
datasetRows = zeros(1,size(datasets,2));
datasetCols = zeros(1,size(datasets,2));
for d = 1:size(datasets,2)
    [datasetRows(1,d) datasetCols(1,d)] = size(datasets{d});
end

% Statistics Matrix - 4 matrices with dimensions equals the number of datasets
% Matrix 1 = TP | Matrix 2 = FN | Matrix 3 = FP | Matrix 4 = TN
% Lines = Trained By
% Columns = Teste By
S = zeros(numberDatasets,numberDatasets,4);

% Results Matrix - 3 matrices with dimensions equals the number of datasets
% Matrix 1 = Correct Rate | Matrix 2 = Sensitivity | Matrix 3 = Specificity
% Matrix 4 = PPV | Matrix 5 = NPV
R = zeros(numberDatasets,numberDatasets,5);

% Vectors Matrix - numberDatasets x numberDatasets matrix with the Cr rate vectors for each cell
H = cell(numberDatasets,numberDatasets);

% Matrix for Friedman-Nemenyi Hypothesis Test - (nFoldNumber*foldNumber) x numberDatasets x numberDatasets
% This matrix stores Specificiry
FTR = zeros((nFoldNumber*foldNumber),numberDatasets,numberDatasets);
FTS = zeros((nFoldNumber*foldNumber),numberDatasets,numberDatasets);
fCounter = 1;

% Matrices to evaluate the standard deviations - (nFoldNumber*foldNumber) x numberDatasets x numberDatasets x number of measures (sens, spec, etc)
STD = zeros((nFoldNumber*foldNumber),numberDatasets,numberDatasets,5);
%STDcr = zeros((nFoldNumber*foldNumber),numberDatasets,numberDatasets);
%STDsn = zeros((nFoldNumber*foldNumber),numberDatasets,numberDatasets);
%STDsp = zeros((nFoldNumber*foldNumber),numberDatasets,numberDatasets);
%STDpp = zeros((nFoldNumber*foldNumber),numberDatasets,numberDatasets);
%STDnp = zeros((nFoldNumber*foldNumber),numberDatasets,numberDatasets);

% Iterating on nFoldNumber = the number of times the fold validation will be performed %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for nfn = 1:nFoldNumber

    % Fold Numbers
    foldNumbers = cell(1,size(datasets,2));
    for d = 1:size(datasets,2)
        foldNumbers{d} = crossvalind('Kfold', datasetRows(1,d), foldNumber);
    end

    % Cross Validation Iteration
    for k = 1:foldNumber

        % Training and Testing separation
        test = cell(1,size(datasets,2));
        train = cell(1,size(datasets,2));
        for d = 1:size(datasets,2)
            test{d} = datasets{d}((foldNumbers{d} == k),:);
            train{d} = datasets{d}(~(foldNumbers{d} == k),:);
        end

        % Choosing between the different data types and classifiers
        if strcmp(dataType,'cont')
        
            if strcmp(classifType,'svm')
            
                % Building the models
                options = optimset('maxiter',15000);
                models = cell(1,numberDatasets);
                for d = 1:numberDatasets
                    models{d} = svmtrain([train{1}(:,fSet{d}) ; train{d+1}(:,fSet{d})], [ones(size(train{1},1),1) ; zeros(size(train{d+1},1),1)], 'Autoscale',true, 'Showplot',false, 'Method','LS', 'BoxConstraint',svmC, 'Kernel_Function',svmKernel,'polyOrder',svmPolOrd, 'quadprog_opts',options);
                end
            
                % Making all the predictions
                pred = cell(1,numberDatasets^2);
                counter = 1;
                for dModel = 1:numberDatasets
                    for dTest = 1:numberDatasets
                        if dModel == dTest
                            pred{counter} = svmclassify(models{dModel}, [test{1}(:,fSet{dModel}) ; test{dTest+1}(:,fSet{dModel})], 'Showplot',false);
                        else
                            pred{counter} = svmclassify(models{dModel}, [test{1}(:,fSet{dModel}) ; datasets{dTest+1}(:,fSet{dModel})], 'Showplot',false);
                        end
                        pred{counter} = num2cell(pred{counter});
                        counter = counter + 1;
                    end
                end
            
            elseif strcmp(classifType,'dt')
            
                % Building the models
                models = cell(1,numberDatasets);
                for d = 1:numberDatasets
                    models{d} = classregtree([train{1}(:,fSet{d}) ; train{d+1}(:,fSet{d})], [ones(size(train{1},1),1) ; zeros(size(train{d+1},1),1)], 'method','classification', 'prune','on','splitcriterion','gdi');
                end
            
                % Making all the predictions
                pred = cell(1,numberDatasets^2);
                counter = 1;
                for dModel = 1:numberDatasets
                    for dTest = 1:numberDatasets
                        if dModel == dTest
                            pred{counter} = str2num(cell2mat(eval(models{dModel}, [test{1}(:,fSet{dModel}) ; test{dTest+1}(:,fSet{dModel})])));
                        else
                            pred{counter} = str2num(cell2mat(eval(models{dModel}, [test{1}(:,fSet{dModel}) ; datasets{dTest+1}(:,fSet{dModel})])));
                        end
                        pred{counter} = num2cell(pred{counter});
                        counter = counter + 1;
                    end
                end
            
            elseif strcmp(classifType,'nb') 
            
                % Making all the predictions
                pred = cell(1,numberDatasets^2);
                counter = 1;
                for dModel = 1:numberDatasets
                    for dTest = 1:numberDatasets
                        if dModel == dTest
                            pred{counter} = classify([test{1}(:,fSet{dModel}) ; test{dTest+1}(:,fSet{dModel})], [train{1}(:,fSet{dModel}) ; train{dModel+1}(:,fSet{dModel})], [ones(size(train{1},1),1) ; zeros(size(train{dModel+1},1),1)], 'diaglinear');
                        else
                            pred{counter} = classify([test{1}(:,fSet{dModel}) ; datasets{dTest+1}(:,fSet{dModel})], [train{1}(:,fSet{dModel}) ; train{dModel+1}(:,fSet{dModel})], [ones(size(train{1},1),1) ; zeros(size(train{dModel+1},1),1)], 'diaglinear');
                        end
                        pred{counter} = num2cell(pred{counter});
                        counter = counter + 1;
                    end
                end
            
            else % 'pls'
            
                % Building the models
                models = cell(1,numberDatasets);
                for d = 1:numberDatasets
                    [T,W,p,u,models{d}] = pls([train{1}(:,fSet{d}) ; train{d+1}(:,fSet{d})], [ones(size(train{1},1),1) ; -1*ones(size(train{d+1},1),1)],1);
                end
            
                % Making all the predictions
                pred = cell(1,numberDatasets^2);
                counter = 1;
                for dModel = 1:numberDatasets
                    for dTest = 1:numberDatasets
                        if dModel == dTest
                            pred{counter} = sign([test{1}(:,fSet{dModel}) ; test{dTest+1}(:,fSet{dModel})]*models{dModel}); pred{counter}(pred{counter}==-1) = 0; 
                        else
                            pred{counter} = sign([test{1}(:,fSet{dModel}) ; datasets{dTest+1}(:,fSet{dModel})]*models{dModel}); pred{counter}(pred{counter}==-1) = 0; 
                        end
                        pred{counter} = num2cell(pred{counter});
                        counter = counter + 1;
                    end
                end
            
            end
        
        else
        
            if strcmp(classifType,'svm')
            
                % Building the models
                options = optimset('maxiter',15000);
                models = cell(1,numberDatasets);
                for d = 1:numberDatasets
                    models{d} = svmtrain([train{1} ; train{d+1}], [ones(size(train{1},1),1) ; zeros(size(train{d+1},1),1)], 'Autoscale',true, 'Showplot',false, 'Method','LS', 'BoxConstraint',svmC, 'Kernel_Function',svmKernel,'polyOrder',svmPolOrd, 'quadprog_opts',options);
                end
            
                % Making all the predictions
                pred = cell(1,numberDatasets^2);
                counter = 1;
                for dModel = 1:numberDatasets
                    for dTest = 1:numberDatasets
                        if dModel == dTest
                            pred{counter} = svmclassify(models{dModel}, [test{1} ; test{dTest+1}], 'Showplot',false);
                        else
                            pred{counter} = svmclassify(models{dModel}, [test{1} ; datasets{dTest+1}], 'Showplot',false);
                        end
                        pred{counter} = num2cell(pred{counter});
                        counter = counter + 1;
                    end
                end
            
            elseif strcmp(classifType,'dt')
            
                % Building the models
                models = cell(1,numberDatasets);
                for d = 1:numberDatasets
                    models{d} = classregtree([train{1} ; train{d+1}], [ones(size(train{1},1),1) ; zeros(size(train{d+1},1),1)], 'method','classification', 'prune','on','splitcriterion','gdi','categorical',1:datasetCols(1,1));
                end
            
                % Making all the predictions
                pred = cell(1,numberDatasets^2);
                counter = 1;
                for dModel = 1:numberDatasets
                    for dTest = 1:numberDatasets
                        if dModel == dTest
                            pred{counter} = str2num(cell2mat(eval(models{dModel}, [test{1} ; test{dTest+1}])));
                        else
                            pred{counter} = str2num(cell2mat(eval(models{dModel}, [test{1} ; datasets{dTest+1}])));
                        end
                        pred{counter} = num2cell(pred{counter});
                        counter = counter + 1;
                    end
                end
            
            elseif strcmp(classifType,'nb') 
            
                % Making all the predictions
                pred = cell(1,numberDatasets^2);
                counter = 1;
                for dModel = 1:numberDatasets
                    for dTest = 1:numberDatasets
                        if dModel == dTest
                            pred{counter} = classify([test{1} ; test{dTest+1}], [train{1} ; train{dModel+1}], [ones(size(train{1},1),1) ; zeros(size(train{dModel+1},1),1)], 'diaglinear');
                        else
                            pred{counter} = classify([test{1} ; datasets{dTest+1}], [train{1} ; train{dModel+1}], [ones(size(train{1},1),1) ; zeros(size(train{dModel+1},1),1)], 'diaglinear');
                        end
                        pred{counter} = num2cell(pred{counter});
                        counter = counter + 1;
                    end
                end
            
            else % 'pls'
            
                % Do nothing
                doNothing = 'Do nothing';
            
            end
        
        end
    
        % Creating labels
        labels = cell(1,numberDatasets^2);
        counter = 1;
        for dModel = 1:numberDatasets
            for dTest = 1:numberDatasets
                if dModel == dTest
                    labels{counter} = num2cell([ones(size(test{1},1),1) ; zeros(size(test{dTest+1},1),1)]);
                else
                    labels{counter} = num2cell([ones(size(test{1},1),1) ; zeros(size(datasets{dTest+1},1),1)]);
                end
                counter = counter + 1;
            end
        end
    
        % Variables only necessary to hypothesis testing (H matrix)
        tempS = zeros(numberDatasets,numberDatasets,4);

        % Evaluating predictions
        for i = 1:numberDatasets
            for j = 1:numberDatasets
                currInd = (numberDatasets*(i-1))+j;
                currPred = pred{currInd};
                currLabel = labels{currInd};
                for m = 1:size(currPred,1)
                    if currPred{m} == 1 && currLabel{m} == 1
                        S(i,j,1) = S(i,j,1) + 1;
                        tempS(i,j,1) = tempS(i,j,1) + 1;
                    elseif currPred{m} == 0 && currLabel{m} == 1
                        S(i,j,2) = S(i,j,2) + 1;
                        tempS(i,j,2) = tempS(i,j,2) + 1;
                    elseif currPred{m} == 1 && currLabel{m} == 0
                        S(i,j,3) = S(i,j,3) + 1;
                        tempS(i,j,3) = tempS(i,j,3) + 1;
                    else
                        S(i,j,4) = S(i,j,4) + 1;
                        tempS(i,j,4) = tempS(i,j,4) + 1;
                    end
                end
            end
        end
    
        % Update Hvec, FTR and FTS
        for i = 1:numberDatasets
            for j = 1:numberDatasets
                tp = tempS(i,j,1);
                fn = tempS(i,j,2);
                fp = tempS(i,j,3);
                tn = tempS(i,j,4);
                H{i,j} = [H{i,j} ((tp+tn) / (tp+tn+fp+fn))]; % Correct Rate
                %%%%%%%%%%%
                FTR(fCounter,j,i) = 100*(tn/(tn+fp)); % Specificity
                FTS(fCounter,i,j) = 100*(tn/(tn+fp)); % Specificity
                %%%%%%%%%%%
                STD(fCounter,i,j,1) = 100*((tp+tn) / (tp+tn+fp+fn));
                STD(fCounter,i,j,2) = 100*(tp /(tp+fn));
                STD(fCounter,i,j,3) = 100*(tn /(tn+fp));
                STD(fCounter,i,j,4) = 100*(tp /(tp+fp));
                STD(fCounter,i,j,5) = 100*(tn /(tn+fn));
            end
        end
        
        % Update fCounter for FTR and FTS matrices
        fCounter = fCounter + 1;
    
    end

end

% Dividing each S entry by foldNumber
for i = 1:numberDatasets
    for j = 1:numberDatasets
        for m = 1:4
            S(i,j,m) = S(i,j,m) / (foldNumber*nFoldNumber);
        end
    end
end

% Calculating Statistics
for i = 1:numberDatasets
    for j = 1:numberDatasets
        tp = S(i,j,1);
        fn = S(i,j,2);
        fp = S(i,j,3);
        tn = S(i,j,4);
        R(i,j,1) = 100*((tp+tn) / (tp+tn+fp+fn)); % Correct Rate
        R(i,j,2) = 100*(tp /(tp+fn)); % Sensitivity
        R(i,j,3) = 100*(tn /(tn+fp)); % Specificity
        R(i,j,4) = 100*(tp /(tp+fp)); % PPV
        R(i,j,5) = 100*(tn /(tn+fn)); % NPV
    end
end

% Evaluating STD matrices
STD = std(STD); STD = squeeze(STD(1,:,:,:));
%STDcr = std(STDcr); STDcr = squeeze(STDcr(1,:,:));
%STDsn = std(STDsn); STDsn = squeeze(STDsn(1,:,:));
%STDsp = std(STDsp); STDsp = squeeze(STDsp(1,:,:));
%STDpp = std(STDpp); STDpp = squeeze(STDpp(1,:,:));
%STDnp = std(STDnp); STDnp = squeeze(STDnp(1,:,:));

end