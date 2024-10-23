function Qdraw=GEN_Q_rw(Btdraw,K,t,Q_prmean,Q_prvar)
   
    % Frist: take the SSE in the state equation of B(t)
    Btemp = Btdraw(:,2:t)' - Btdraw(:,1:t-1)';
    sse_2 = zeros(K,K);
    for i = 1:t-1
        sse_2 = sse_2 + Btemp(i,:)'*Btemp(i,:);
    end
    
    % Second: draw Q, the covariance matrix of B(t)
    Qinv = inv(sse_2 + Q_prmean);
    Qinvdraw = wish(Qinv,t-1+Q_prvar);
    Qdraw = inv(Qinvdraw);  

end

