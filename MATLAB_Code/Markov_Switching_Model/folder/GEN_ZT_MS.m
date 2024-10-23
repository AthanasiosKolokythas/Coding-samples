
% GENERATE THE STATE VECTOR

function [Z_MAT]=GEN_ZT_MS(yy,mu0,mu1,lamd1,psi11,psi12,sig21,lamd2,psi21,psi22,sig22,lamd3,psi31,psi32,sig23,lamd4,psi41,psi42,sig24,lag,state)

    H= [lamd1 -lamd1*psi11 -lamd1*psi12 ;
        lamd2 -lamd2*psi21 -lamd2*psi22 ;
        lamd3 -lamd3*psi31 -lamd3*psi32 ;
        lamd4 -lamd4*psi41 -lamd4*psi42];

    F=[0   0 0; 
       eye(2) zeros(2,1)];
      
    R=zeros(4,4);
    R(1,1)=sig21;
    R(2,2)=sig22;
    R(3,3)=sig23;
    R(4,4)=sig24;

    Q=zeros(3,3);
    Q(1,1)=1;
    
    MU0=[mu0;0;0];
    MU1=[mu1;0;0];

    ns=size(Q,1);    % size of the state vector
    nk=size(yy,1);    % number of indicators
          
    T=size(yy,2);
    yystar=zeros(nk,T-lag);
      
    yystar(1,:) = yy(1,3:end) -psi11*yy(1,2:end-1) - psi12*yy(1,1:end-2);
    yystar(2,:) = yy(2,3:end) -psi21*yy(2,2:end-1) - psi22*yy(2,1:end-2);
    yystar(3,:) = yy(3,3:end) -psi31*yy(3,2:end-1) - psi32*yy(3,1:end-2);
    yystar(4,:) = yy(4,3:end) -psi41*yy(4,2:end-1) - psi42*yy(4,1:end-2);
    
    tstar=size(yystar,2);

    Sp=zeros(ns,1);
    Pp=eye(ns);
    S=zeros(tstar,ns);
    P=zeros(ns,ns,tstar);
    
   for i=1:tstar
        y = yystar(:,i);
        nu = y - H*Sp;   % conditional forecast error
        f = H*Pp*H' + R;    % variance of the conditional forecast error
        finv=inv(f);
        
        Stt = Sp + Pp*H'*finv*nu;
        Ptt = Pp - Pp*H'*finv*H*Pp;
        
        if i < tstar
            Sp = F*Stt + (MU0+MU1*state(i+lag,:)) ;
            Pp = F*Ptt*F' + Q;
        
        
        S(i,:) = Stt';
        P(:,:,i) = Ptt;
   end
     
    % draw Sdraw(T|T) ~ N(S(T|T),P(T|T))
    Sdraw(tstar,:)=S(tstar,:);
    Sdraw(tstar,:)=mvnrnd(Sdraw(tstar,:)',Ptt,1);

    km=1;    % KEY! "number of nonzero elements in the diagonal of the covariance matrix of transition equation (from top to bottom)"
    % iterate 'down', drawing at each step, use modification for singular Q
    Qstar=Q(1:km,1:km);
    Fstar=F(1:km,:);
    MU0star=MU0(1:km,:);
    MU1star=MU1(1:km,:);
    
    for i=tstar-1:-1:1
        Sf = Sdraw(i+1,1:km)';
        Stt = S(i,:)';
        Ptt = P(:,:,i);
        f = Fstar*Ptt*Fstar' + Qstar;
        finv = inv(f);
        nu = Sf - Fstar*Stt - (MU0star+MU1star*state(i,:));
        
        Smean = Stt + Ptt*Fstar'*finv*nu;
        Svar = Ptt - Ptt*Fstar'*finv*Fstar*Ptt;
       
        Sdraw(i,:) = Smean';
        Sdraw(i,:) = mvnrnd(Sdraw(i,:)',Svar,1);
    end
    
    Z_MAT=[zeros(lag,1);Sdraw(:,1)];    % take the first element that corresponds to the estimated factor
         
end
        