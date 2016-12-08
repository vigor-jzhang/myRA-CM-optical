function Y = jac_log(X)
%Jacobian logarithm, can be implemented by using look up table.
if isempty(X)
    Y=0;
else
    tempY=X(1);
    for i=2:1:length(X)
        tempY=jacobian(tempY,X(i));
    end
    Y=tempY;
end

    function y=jacobian(a,b)
        if(a==-inf && a==-inf)
            y = -inf;
        else
            %y=max(a,b)+log(1+exp(-abs(a-b)));
            difference=abs(a-b);
            if difference >= 4.5
                y = max(a,b);
            elseif difference >= 2.252
                y = max(a,b) + 0.05;
            elseif difference >= 1.508
                y = max(a,b) + 0.15;
            elseif difference >= 1.05
                y = max(a,b) + 0.25;
            elseif difference >= 0.71
                y = max(a,b) + 0.35;
            elseif difference >= 0.433
                y = max(a,b) + 0.45;
            elseif difference >= 0.196
                y = max(a,b) + 0.55;
            else % difference >= 0
                y = max(a,b) + 0.65;
            end
        end
    end

end

