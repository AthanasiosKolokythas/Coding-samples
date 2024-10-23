% Function to store the transitions of states i,j=0,1

function switchh=switchg(s,g)

n=size(s,1);
m=size(g,1);

     switchh=zeros(m,m);     % matrix to store the transitions 
     t=2;
     while t<=n
        st1=s(t-1);
        st=s(t);
        switchh(st1,st)=switchh(st1,st)+1;
        t=t+1;
     end

end
