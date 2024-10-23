
function s=bingen(p0,p1,m)

pr0=p0/(p0+p1);      % prob(s=0)
u=rand(m,1);
s=(u>=pr0);

end
