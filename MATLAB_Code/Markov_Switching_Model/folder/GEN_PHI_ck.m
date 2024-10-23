function [BTDRAW] = GEN_PHI_ck(Y,Ht,Qt,m,B0,V0,tau)

%Multi-variate notation
Y=Y(tau+1:end,:);
p=2;
X=[lag0(Y,1) lag0(Y,2) ones(size(Y,1),1)];
Y=Y(p+1:end,:);
X=X(p+1:end,:);
t=size(Y,1);
M=size(Y,2);
yy=vec(Y);
xx=kron(eye(M),X);

MaxEig=1.01;
MaxRoot=MaxEig+1;
% Kalman Filter
bp = B0;
Vp = V0;
bt = zeros(t,m);
Vt = zeros(m^2,t);
for i=1:t
    R = Ht;
    H = xx([i t+i 2*t+i],:);
    cfe = yy([i t+i 2*t+i],:) - H*bp;   % conditional forecast error
    f = H*Vp*H' + R;    % variance of the conditional forecast error
    inv_f = inv(f);
    btt = bp + Vp*H'*inv_f*cfe;
    Vtt = Vp - Vp*H'*inv_f*H*Vp;
    if i < t
        bp = btt;
        Vp = Vtt + Qt;
    end
    bt(i,:) = btt';
    Vt(:,i) = reshape(Vtt,m^2,1);
end

while MaxRoot>=MaxEig
    % draw Sdraw(T|T) ~ N(S(T|T),P(T|T))
    bdraw = zeros(t,m);
    bdraw(t,:) = mvnrnd(btt,Vtt,1);
    % Backward recurssions
    for i=1:t-1
        bf = bdraw(t-i+1,:)';
        btt = bt(t-i,:)';
        Vtt = reshape(Vt(:,t-i),m,m);
        f = Vtt + Qt;
        inv_f = inv(f);
        cfe = bf - btt;
        bmean = btt + Vtt*inv_f*cfe;
        bvar = Vtt - Vtt*inv_f*Vtt;
        bdraw(t-i,:) = mvnrnd(bmean,bvar,1); %bmean' + randn(1,m)*chol(bvar);
    end
    bdraw = bdraw';
    % Accept draw
    Btdraw = bdraw;
    % Check for stationarity (polynomial roots of VAR)
    for i = 1:t
        BBtempor = reshape(Btdraw(:,i),1+M*p,M);
        ctemp1=[BBtempor(1:end-1,:)';eye(M*(p-1)) zeros(M*(p-1),M)];
        AutVal(i)=max(abs(eig(ctemp1)));
    end
    MaxRoot=max(AutVal);
end

    BTDRAW=[repmat(Btdraw(:,1),[1,p+1]) Btdraw];

end

