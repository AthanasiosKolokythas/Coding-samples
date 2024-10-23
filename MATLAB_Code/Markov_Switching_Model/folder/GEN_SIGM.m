function SIGMA=GEN_SIGM(Y,phi,S,alpha,L)

T=size(Y,1);

X=[];   % take lags
for j=1:L
X=[X lag0(Y(:,:),j) ];
end
X=[X ones(size(Y,1),1)];
Y=Y(L+1:end,:);
X=X(L+1:end,:);

for i=1:size(Y,1)
e(i,:)=Y(i,:)-X(i,:)*(squeeze(phi(:,:,i)))';
end

scale1=e'*e+S;
SIGMA=iwpQ(T+alpha,inv(scale1));
            
end
