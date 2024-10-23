% GENERATE lambda                 

function B = GEN_LAMDA(ndx,yy,ztt,psi1,psi2,sigma2,Sigma0,B0)

    Y=yy(ndx,3:end)'-psi1*yy(ndx,2:end-1)'-psi2*yy(ndx,1:end-2)';
    X=ztt(3:end,1)  -psi1*ztt(2:end-1,1)  -psi2*ztt(1:end-2,1);
    %remove missing obs
    Y=Y(3:end);
    X=X(3:end,:);
     
     M = inv(Sigma0 + (1/sigma2)*(X'*X))*(inv(Sigma0)*B0 + (1/sigma2)*X'*Y);
     V = inv(Sigma0 + (1/sigma2)*(X'*X));

     B=M+(randn(1,1)*chol(V))';
     
end
