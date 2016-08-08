function L_M_p=soft_demapper_10_256(L_M_a,firstLLR1,firstLLR0)
%Soft demapper, using the function from
%"Iterative demapping and decoding for multilevel modulation", the author
%is Stephan ten Brink, 1998

L_M_p=zeros(1,length(L_M_a));

%Calculate the LLR, not plus the [L_M_a, btst(i,h)=1]
for i=1:1:length(L_M_p)
    label=fix((i-1)/5);
    otherLa=sum(L_M_a(1,(label*5+1):(label*5+5)))-L_M_a(i);
    tempLLR1=firstLLR1(i,:);
    tempLLR0=firstLLR0(i,:);
    LLR1=[];
    LLR0=[];
    for j=1:1:length(tempLLR1)
        if abs(tempLLR1(j))>1e-10
            LLR1=[LLR1, tempLLR1(j)+otherLa];
        end
        if abs(tempLLR0(j))>1e-10
            LLR0=[LLR0, tempLLR0(j)+otherLa];
        end
    end
    %LLR1=LLR1/P;
    %LLR0=LLR0/P;
    LLR1=jac_log(LLR1);
    LLR0=jac_log(LLR0);
    L_M_p(i)=L_M_a(i)+1*(LLR1-LLR0);
%     diff=LLR1-LLR0;
%     if abs(diff)<1e-10
%         L_M_p(i)=L_M_a(i)+1*(LLR1-LLR0);
%     else
%         L_M_p(i)=L_M_a(i)+1*(LLR1-LLR0);
%     end
end


end
