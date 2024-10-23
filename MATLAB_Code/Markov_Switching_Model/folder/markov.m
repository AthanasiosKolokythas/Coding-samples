
function s=markov(a,b,ss0,n)

s=zeros(n,1);
s(1,1)=ss0;

i=2;

while i<n
    
    if s(i-1,1)==0
        u=rand(1,1);
        if u<=a 
            s(i,1)=1;
        else
            s(i,1)=0;
        end
    elseif s(i-1,1)==1
        u=rand(1,1);
        if u<=(1-b)
            s(i,1)=1;
        else
            s(i,1)=0;
        end
    end
    
i=i+1;

end

end
