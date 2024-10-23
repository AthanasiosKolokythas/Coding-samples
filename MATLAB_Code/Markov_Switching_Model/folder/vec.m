function x=vec(y)
x=[];
for i=1:size(y,2)
    x=[x;y(:,i)];
end

end

