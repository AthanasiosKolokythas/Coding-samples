% GENERATE MU_0 AND MU_1

function [MU_0, MU_1]=GEN_MU(Y,SIG2TT,STT,R0,T0)

%YSTAR=Y./sqrt(SIG2TT);
YSTAR=Y;
nt=size(YSTAR,1);
%XSTAR=[ones(nt,1) STT ]./repmat(sqrt(SIG2TT),[1,2]);
XSTAR=[ones(nt,1) STT ];
 
V = invpd(invpd(R0) + XSTAR'*XSTAR);     
MU =  V*(invpd(R0)*T0 + XSTAR'*YSTAR);
C = chol(V);
 
accept = 0;
    while accept == 0
          MU_G = MU + C'*randn(2,1);
          if MU_G(2) > 0
          accept = 1;
          end
     end
     
     MU_0=MU_G(1); MU_1=MU_G(2);
     
end
