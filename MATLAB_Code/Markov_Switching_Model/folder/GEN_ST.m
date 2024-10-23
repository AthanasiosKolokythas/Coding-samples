% GENERATE THE REGIMES

function  [S_T]=GEN_ST(Y,P,Q,mu0,mu1,sig)

TSTAR=size(Y,1);
FLT_PR=zeros(TSTAR,2);

PR_TR=[[Q,(1-P)];[(1-Q),  P]];  % P = P[St=1|St-1=1], Q = P[St=0|St-1=0]
ap = [(eye(2)-PR_TR);ones(1,2)];
chsi = SUMC((invpd(ap'*ap))');    % steady state probabilities

mu=[mu0;mu0+mu1]';

captst=TSTAR;

% Likelihood function

et0 = ((Y - mu(1)).^2).*(1./sig);
et1 = ((Y - mu(2)).^2).*(1./sig);

eta0 =(1/sqrt(2*pi))* (1./sqrt(sig)).*exp(-et0/2);
eta1 =(1/sqrt(2*pi))* (1./sqrt(sig)).*exp(-et1/2);

eta=[eta0 eta1];
f=0;

% Hamilton filter

it=1;
while it <=captst
    fx = chsi .* eta(it,:)';
    fit =SUMC(fx);
    FLT_PR(it,:)=fx'/fit;      
    f=f+log(fit);
    chsi=PR_TR*fx/fit;
it=it+1;
end

% Kim and Nelson Algorithm

S_T=zeros(TSTAR,1);
S_T(TSTAR,1)=bingen(FLT_PR(TSTAR,1),FLT_PR(TSTAR,2),1);
J_ITER=TSTAR-1;

while J_ITER>=1
    if S_T(J_ITER+1,1)==0
        P01=Q*FLT_PR(J_ITER,1);
        P11=(1-P)*FLT_PR(J_ITER,2);
    elseif S_T(J_ITER+1,1)==1
        P01=(1-Q)*FLT_PR(J_ITER,1);
        P11=P*FLT_PR(J_ITER,2);
    end
        S_T(J_ITER,1)=bingen(P01,P11,1);
        J_ITER=J_ITER-1;
end

end
