function [T,W,P,U,B]=pls(X,Y,h)
%This PLS program calculates the T,C,P,U and B matrices
%for the given X and Y blocks and the number of latent
%variables specified by the input parameter h.
%B is the coefficient matrix. For univariate regression problems, B is a
%column vector. The absolute values of the elements of B is a reasonable measurement of
%the contributions of the corresponding variables.
%Input format is as follows:
%[T,C,P,U,B]=pls(x,y,h)

%copyright
% Kai Song (ksong@tju.edu.cn), 2011
%School of Chemical Engineering and Technology, Tianjin University, Tianjin, 300072, China
%Institute of Life Science and Biotechnology, Tianjin University, Tianjin,
%300072, China


for i=1:h
    YX=Y'*X;
    U(:,i)=YX(1,:)'/norm(YX(1,:));
    if size(Y,2)>1 %only loop if dimension greater than 1
        uold=U(:,i)+1;
        while norm(U(:,i)-uold)>0.001
            uold=U(:,i);
            tu=YX'*YX*U(:,i);
            U(:,i)=tu/norm(tu);
        end
    end
    t=X*U(:,i);
    T(:,i)=t;
    W(:,i)=Y'*t/(t'*t);
    P(:,i)=X'*t/(t'*t);
    X=X-t*P(:,i)';
end
B=U*((P'*U)\W');
end