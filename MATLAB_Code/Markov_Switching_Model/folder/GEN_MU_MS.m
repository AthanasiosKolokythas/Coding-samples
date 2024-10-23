% GENERATE MU_0 AND MU_1

function [MU_G1, MU_G2]=GEN_MU_MS(ytz,STT,R0_M,T0_M)

YSTAR = ytz;
nt=size(YSTAR,1);
XSTAR = [ones(nt,1) STT ];

V = invpd(invpd(R0_M) + XSTAR'*XSTAR);     
MU =  V*(invpd(R0_M)*T0_M + XSTAR'*YSTAR);
C = chol(V);
 
accept = 0;
    while accept == 0
        MU_G = MU + C'*randn(2,1);
        if MU_G(2) > 0
        accept = 1;
        end
    end
    
    MU_G1=MU_G(1); MU_G2=MU_G(2);
     
end
