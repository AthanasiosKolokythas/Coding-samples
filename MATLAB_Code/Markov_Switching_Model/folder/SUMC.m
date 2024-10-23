
function B=SUMC(A)
[m,n]=size(A);
B=[];
for i=1:n
    B=[B;sum(A(:,i))];
end