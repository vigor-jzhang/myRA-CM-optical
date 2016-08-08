function y = limit_number(x)
%Set a limitation on a matrix
numb=128;
[n,k]=size(x);
for i=1:n
    for k=1:k
        if x(i,k)<-numb
            x(i,k)=-numb;
        end
        if x(i,k)>numb
            x(i,k)=numb;
        end
    end
end
y=x;


end

