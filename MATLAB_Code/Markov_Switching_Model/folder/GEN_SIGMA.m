% GENERATE SIGMA_2

function [SIG2TT]=GEN_SIGMA(y,MU0TT,MU1TT,STT,T0,D0)

resids=y-(MU0TT+MU1TT*STT); %compute residuals
T=size(y,1);    %sample size
T1=T0+T;    %compute posterior df and scale matrix
D1=D0+resids'*resids;
z0=randn(T1,1); %draw from IG
z0z0=z0'*z0;
SIG2TT=D1/z0z0;

end
