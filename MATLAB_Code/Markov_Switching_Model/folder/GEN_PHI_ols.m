function [betaols,vbetaols] = GEN_PHI_ols(rawdat,tau,plag)

Y = rawdat(plag+1:tau+plag,:);

%Matric-variate notation
X=[lag0(Y,1) lag0(Y,2) ones(size(Y,1),1)];
Y=Y(3:end,:);
X=X(3:end,:);
p=size(Y,2);
T=size(Y,1);

betaols=vec(inv(X'*X)*(X'*Y));
Uhat=Y-X*reshape(betaols,p*plag+1,p);
%scale matrix
sig=(Uhat'*Uhat)/(T-p);
vbetaols=kron(sig,inv(X'*X));

end


