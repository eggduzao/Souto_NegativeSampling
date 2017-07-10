clc
A = [1 2 3 ; 4 5 6];
A(1,1:3) = [7 8 9];

A = ['a' 'c' 'g' 't' ; 'a' 'a' 'c' 'c' ; 'g' 't' 'g' 't'];
B = binarize(A);
C = categorize(A);

A = zeros(3,4,2);
A(:,:,1) = [1 2 3 4 ; 5 6 7 8 ; 9 10 11 12];
A(:,:,2) = [10 20 30 40 ; 50 60 70 80 ; 90 100 110 120];

A = zeros(4,4,3); % = tres matrizes 4x4, cada um pra um resultado diferente: sens, spec, % acerto, etc
%%%%%%%%%%%%%%%%%%% TEST %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% COD1 %% COD2 %% NCOD %% RAND %%
% T % COD1
% R % COD2
% A % NCOD
% I % RAND
% N %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

A = crossvalind('Kfold', 12, 3);
B = crossvalind('Kfold', 12, 3);
C = [A B];

A = 'ola';
B = 'hi';
if strcmp(A,B)
    A
end
    
A = [1 2 3 ; 4 5 6];
B = [7 8 9 ; 10 11 12 ; 13 14 15];
C = [A ; B];

A = ones(5,1);
B = zeros(4,1);
C = [A ; B];

A = zeros(4,4,10);
A(1,1,:) = [1 2 3 4 5 6 7 8 9 10];
A(2,2,:) = [10 20 30 40 50 60 70 80 90 100];
for i = 1:4
    for j = 1:4
    B = A(i,j,:);
    end
end

A = [1 ; 1 ; -1 ; -1 ; 1 ; 1 ; -1 ; -1];
A(A==-1)=0; 

A = [1; 2; 3; 4; 5];
B = 6:10;
C = [ [A ; A] ...
      [A ; A]  ];

  
A = [1 ; 2 ; 3];
B = [4 ; 5 ; 6 ; 7];
C = [8 ; 9];
D = {num2cell(A) num2cell(B) num2cell(C)};

A = -1*ones(5,1);


%h = bar([5 12 3 5; 14 2 11 12; 12 5 8 6; 13 3 11 12; 5 8 11 8]);
%title('Test Graph','FontSize',16)
%set(h(1),'facecolor',[0.50 0.50 1.00])
%set(h(2),'facecolor',[0.54 0.85 0.56])
%set(h(3),'facecolor',[0.90 0.34 0.41])
%set(h(4),'facecolor',[0.94 0.92 0.40])
%ylabel('Rate (%)'); 
%legend('NB',1,'DT',2,'SVM',3,'PLS',4);
%set(gca,'XTickLabel',{'Correct Rate';'Sensitivity';'Specificity';'PPV';'NPV'},'FontSize',9);
%axis([0.5 5.5 0 30])
%saveas(gcf,'teste', 'eps');

graphTitles = {'COD1'; 'COD2'; 'NCOD'; 'RAND'};
t = ['teste' char(graphTitles(1))];

A = [1 2 3 ; 4 5 6];
B = [7 8 9 ; 10 11 12 ; 13 14 15 ; 16 17 18];
C = {A, B};
size(C);
D = C{2};

C = {};
C{1} = A;
size(C,2);
C{2} = B;
C{3} = A;
C{4} = B;
size(C,2);
D = {C{1}};
E = {C{2}, C{3}, C{4}};

C = cell(1,2);
C{1} = A;
C{2} = B;



%h = bar([5 12 3 5; 14 2 11 12; 12 5 8 6; 13 3 11 12; 5 8 11 8; 13 3 11 12; 5 12 3 5; 14 2 11 12; 12 5 8 6; 5 12 3 5; 14 2 11 12; 12 5 8 6; 5 12 3 5; 14 2 11 12; 12 5 8 6; 5 12 3 5; 14 2 11 12; 12 5 8 6; 5 12 3 5; 14 2 11 12; 12 5 8 6]);
%title('Test Graph','FontSize',16)
%set(h(1),'facecolor',[0.50 0.50 1.00])
%set(h(2),'facecolor',[0.54 0.85 0.56])
%set(h(3),'facecolor',[0.90 0.34 0.41])
%set(h(4),'facecolor',[0.94 0.92 0.40])
%ylabel('Rate (%)'); 
%legend('NB',1,'DT',2,'SVM',3,'PLS',4);
%set(gca,'XTickLabel',{'Cr';'Sn';'Sp';'Cr';'Sn';'Sp';'Cr';'Sn';'Sp';'Cr';'Sn';'Sp';'Cr';'Sn';'Sp';'Cr';'Sn';'Sp';'Cr';'Sn';'Sp'},'FontSize',9);
%axis([0.5 21.5 0 30])
%saveas(gcf,'teste', 'eps');

A = {'Teste','Weste'};
B = {'1','2'};
%for i = 1:size(A,2)
%    for j = 1:size(B,2)
%        [A{i} B{j}];
%    end
%end


A = [90.1 90.0 87.8 88.8 85.0 89.0 92.0 91.3 92.3 94.1];
B = [78.9 83.4 82.2 71.3 73.3 71.1 72.9 77.7 81.3 84.1];
[h,p] = ttest(A,B,0.05,'right');
%h
%p

A = [1 2 3 ; 4 5 6 ; 7 8 9];
B = [11 12 13 ; 14 15 16 ; 17 18 19];
C = [21 22 23 ; 24 25 26 ; 27 28 29];
D = [31 32 33 ; 34 35 36 ; 37 38 39];

E = cell(2,2);
E{1,1} = A;

E = {A B ; C D};
F = {D C ; B A};

G = {E ; F};
G{2,1}{1,2};

E = cell(2,2);
%E{1,1}
E{1,1} = [E{1,1} 1];
%E{1,1}
E{1,1} = [E{1,1} 2];
%E{1,1}
E{1,1} = [E{1,1} 3];
%E{1,1}



h = bar([5 5 5 5 5 5 5 5 5 5 5 5 5; 5 5 5 5 5 5 5 5 5 5 5 5 5]);
title('Test Graph','FontSize',16)

% Cores que estou botando
set(h(1),'facecolor',[0.50 0.50 1.00])
set(h(2),'facecolor',[0.54 0.85 0.56])
set(h(3),'facecolor',[0.90 0.34 0.41])
set(h(4),'facecolor',[0.94 0.92 0.40])

% Vermelhos
set(h(5),'facecolor',[1.00 0.68 0.71])
set(h(6),'facecolor',[0.80 0.34 0.37])
set(h(7),'facecolor',[0.59 0.00 0.05])

% Azuis
set(h(8),'facecolor',[0.65 0.65 0.99])
set(h(9),'facecolor',[0.34 0.34 0.80])
set(h(10),'facecolor',[0.00 0.00 0.57])

% Verdes
set(h(8),'facecolor',[0.52 0.91 0.57])
set(h(9),'facecolor',[0.23 0.74 0.30])
set(h(10),'facecolor',[0.00 0.58 0.08])

% Amarelos
set(h(8),'facecolor',[0.87 0.83 0.42])
set(h(9),'facecolor',[0.72 0.65 0.10])
set(h(10),'facecolor',[0.77 0.44 1.00])

%ylabel('Rate (%)'); 
%legend('NB',1,'DT',2,'SVM',3,'PLS',4);
%set(gca,'XTickLabel',{'Cr';'Sn';'Sp';'Cr';'Sn';'Sp';'Cr';'Sn';'Sp';'Cr';'Sn';'Sp';'Cr';'Sn';'Sp';'Cr';'Sn';'Sp';'Cr';'Sn';'Sp'},'FontSize',9);
%axis([0.5 2.5 0 6])
%saveas(gcf,'teste', 'eps');

F = zeros(2,3,4);
F(1,1,2) = 3;

H = cell(3,4);
H{1,1} = [H{1,1} 5];
H{1,1} = [H{1,1} 6];

X = zeros(2,3,4);
X(1,1,1) = 1; X(1,2,1) = 10;  X(1,3,1) = 100;
X(2,1,1) = 1; X(2,2,1) = 100; X(2,3,1) = 1000;
X(1,1,2) = 1;
X(1,2,2) = 2;
X(1,3,2) = 3;
X(2,1,2) = 1;
X(2,2,2) = 5;
X(2,3,2) = 10;
s = std(X);
s = squeeze(s(1,:,:));

%{
X = [5 12 3 5; 14 2 11 12; 12 5 8 6];
E = [1 2 3 4; 5 6 7 8; 9 10 11 12];
Y = reshape(X,1,(size(X,1)*size(X,2)));
E = reshape(E,1,(size(E,1)*size(E,2)));
h = bar(X);
hold on;
title('Test Graph','FontSize',16)
set(h(1),'facecolor',[0.50 0.50 1.00])
set(h(2),'facecolor',[0.54 0.85 0.56])
set(h(3),'facecolor',[0.90 0.34 0.41])
set(h(4),'facecolor',[0.94 0.92 0.40])
ylabel('Rate (%)'); 
legend('NB',1,'DT',2,'SVM',3,'PLS',4);
set(gca,'XTickLabel',{'Cr';'Sn';'Sp';'Cr';'Sn';'Sp';'Cr';'Sn';'Sp';'Cr';'Sn';'Sp';'Cr';'Sn';'Sp';'Cr';'Sn';'Sp';'Cr';'Sn';'Sp'},'FontSize',9);
axis([0.5 10.5 0 30])
1:size(E,2)
er = errorbar(1:size(E,2),Y,E);
set(er(1),'linestyle','none');
saveas(gcf,'teste', 'eps');
%}

a = 'teste';
a = [a '11'];
%{
x = 1:20;
y = rand(size(x));
e = rand(size(x));
bar(x,y);
hold on;
h=errorbar(x,y,e,'r');
set(h(1),'linestyle','none');
%}

X = [1500 1600 1100 3100 3200 3100];
Y = [10 11 12 13 14 15];
[hypRes,pValue] = ttest(X,Y,0.05,'right');

X1 = [1 2 3 ; 4 5 6];
X2 = [10 2 3 ; 4 5 6];
X3 = [100 2 3 ; 4 5 6];
X = {X1 X2 X3};
Y1 = X{1};

%{
X = NaN;
if(isnan(X))
    class(X)
else
    class(X)
end
%}

X = 4; Y = 2;
if(X == 5 || Y == 3)
    'hey'
end
%X = [];
%Y = [];
%[hypRes,pValue] = ttest(X,Y,0.05,'right');

X = [1131 1145 1130 1137 1135 1131];
Y = [10 11 12 13 14 15];
[hypRes,pValue] = ttest(X,Y,0.05,'both');
hypRes
pValue





