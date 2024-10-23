% GENERATE psi_1,psi_2,sig2_v

function [B1,B2,sigma2]=GEN_PSI(ndx,yy,ztt,lamda,sigma2,Sigma0,B0,T0,D0)
     
Y=yy(ndx,1:end)'-lamda*ztt(1:end,1);
X=[lag0(Y,1) lag0(Y,2)];
%remove missing obs
Y=Y(3:end);
X=X(3:end,:);
T=size(X,1);
     
     % Sample B conditional on sigma N(M*,V*)
     M = inv(Sigma0+(1/sigma2)*(X'*X))*(inv(Sigma0)*B0+(1/sigma2)*X'*Y);
     V = inv(Sigma0+(1/sigma2)*(X'*X));
     chck=-1;
     while chck<0                     %check for stability
        B=M+(randn(1,2)*chol(V))';
        b=[B(1) B(2);1   0];
        ee=max(abs(eig(b)));
        if ee<=1
            chck=1;
        end
     end
     B1=B(1,:);
     B2=B(2,:);
   
    % Sample sigma2 conditional on B from IG(T1,D1); 
    %compute residuals
    resids=Y-X*B;
    %compute posterior df and scale matrix
    T1=T0+T;
    D1=D0+resids'*resids;
    %draw from IG
    z0=randn(T1,1);
    z0z0=z0'*z0;
    sigma2=D1/z0z0;
     
end

