function L_M_p=soft_demapper_4_256(L_M_a,firstLLR1,firstLLR0)
%Soft demapper, using the function from
%"Iterative demapping and decoding for multilevel modulation", the author
%is Stephan ten Brink, 1998

L_M_p=zeros(1,length(L_M_a));

%Calculate the LLR, not plus the [L_M_a, btst(i,h)=1]
for i=1:1:length(L_M_p)
    label=fix((i-1)/4);
    otherLa=sum(L_M_a(1,(label*4+1):(label*4+4)))-L_M_a(i);
    tempLLR1=firstLLR1(i,:);
    tempLLR0=firstLLR0(i,:);
    LLR1=[];
    LLR0=[];
    for j=1:1:length(tempLLR1)
        if abs(tempLLR1(j))~=0
            LLR1=[LLR1, tempLLR1(j)+otherLa];
        end
        if abs(tempLLR0(j))~=0
            LLR0=[LLR0, tempLLR0(j)+otherLa];
        end
    end
    LLR1=jac_log(LLR1);
    LLR0=jac_log(LLR0);
    L_M_p(i)=L_M_a(i)+(LLR1-LLR0);
end


end

