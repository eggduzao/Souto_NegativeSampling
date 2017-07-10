function parameter=vwzcurve(sequence,windowsize)

%The variable-window Z-curve method
%This vwzcurve program calculate the vw Z-curve parameters of frequencies of
%N-nucleotides (N=windowsize) of given sequence
%parameter: the vw Z-curve parameters of the given sequence, the number of
%the parameters is equal to 3*4^(windowsize-1)
%pattern: the permutation and combination of N-nucleotides


%Note: This program could only calculate the vw Z-curve parameters of one
%sequence at a time

%Acknowledgments
%The subprogram 'pick' could be freely downloaded from the internet and it is used to
%pick elements from a set with order and repetition
%The URL of "pick" is: http://www.mathworks.com/matlabcentral/fileexchange/12724-picking-elements-from-a-set


%The details of the methodology of this proposed method please refer to
%"Recognition of prokaryotic promoters based on a novel variable-window
%Z-curve method".
%copyright
% Kai Song (ksong@tju.edu.cn), 2011
%School of Chemical Engineering and Technology, Tianjin University, Tianjin, 300072, China
%Institute of Life Science and Biotechnology, Tianjin University, Tianjin,
%300072, China


sequence=upper(sequence);  %unify the sequence into upper case
N=windowsize;
lengths=size(sequence,2); %get the length of the given sequence
step=fix(lengths/N);
sequence=sequence(:,1:step*N); %The length of the sequence must be the integer times of windowsize
lines=step*N;

h=0;
for i=1:N
    h=h+1;
    temp(i,:)=sequence(:,h:lines-(N-h));
end

word='AGCT';
for i=1:4
    for k=1:N
        tempp(k,i,:)=~(temp(k,:)-word(i).*ones(1,lines+1-N));    %replace 'A' with 1 and other nucleotides with 0 in the first iteration
        %replace 'G'with 1 and other nucleotides with 0 in the second iteration, and so on
    end
end

S=pick(1:4,N,'or');     %picking N elements from the set word with order and repetition
[rowS,lineS]=size(S);  %calculate the number of the permutation and combination

for k=1:rowS          %This section is to calculate the occuring number of every N-nucleotides pattern
    T=ones(1,1,lines+1-N);
    A{k,1}=word(S(k,:));  %A is a cell array. The first element of A contains the permutation and combination of N-nucleotides
    for i=1:N
        T=T.*tempp(i,S(k,i),:);
    end
    A{k,2}=sum(T,3); %The second element of A is the corresponding occuring number of kth permutation and combination of N-nucleotides
end

for k=1:rowS/4
    first(k)=0;
    for i=1:4
        first(k)=first(k)+A{(i+(k-1)*4),2};%calculate the occuring number of every permutation and combination of (N-1)-nucleotides pattern
    end
end

for k=1:rowS/4
    for i=1:4
        if first(k)==0
            frequence(i+(k-1)*4)=0;
        else
            frequence(i+(k-1)*4)=A{i+(k-1)*4,2}./first(k); %%calculate the frequence of every permutation and combination of N-nucleotides pattern
        end
    end
end

for k=1:rowS/4
    a=frequence(1+(k-1)*4);
    t=frequence(4+(k-1)*4);
    c=frequence(3+(k-1)*4);
    g=frequence(2+(k-1)*4);
    
    x=(a+g)-(c+t);%calculate the coordinate values of the vw Z-curve
    y=(a+c)-(g+t);
    z=(a+t)-(c+g);
    %Please refer to the following reference for the details of the Z-curve converter method
    %Zhang, C.T. and Zhang, R. (1991) Analysis of distribution of bases in the
    %coding sequences by a diagrammatic technique. Nucleic Acids Res., 19,
    %6313-6317.
    
    parameter(1+(k-1)*3)=x;
    parameter(2+(k-1)*3)=y;
    parameter(3+(k-1)*3)=z;
end

end
