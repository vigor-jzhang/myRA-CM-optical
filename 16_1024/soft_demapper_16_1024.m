function L_M_p=soft_demapper_16_1024(L_M_a,firstLLR1,firstLLR0)
%Soft demapper, using the function from
%"Iterative demapping and decoding for multilevel modulation", the author
%is Stephan ten Brink, 1998

L_M_p=zeros(1,length(L_M_a));

%Calculate the LLR, not plus the [L_M_a, btst(i,h)=1]
for i=1:1:length(L_M_p)
    label=fix((i-1)/8);
    otherLa=sum(L_M_a(1,(label*8+1):(label*8+8)))-L_M_a(i);
    tempLLR1=firstLLR1(i,:);
    tempLLR0=firstLLR0(i,:);
    LLR1=[];
    LLR0=[];
    for j=1:1:length(tempLLR1)
        LLR1=[LLR1, tempLLR1(j)+otherLa];
        LLR0=[LLR0, tempLLR0(j)+otherLa];
    end
    LLR1=jac_log(LLR1);
    LLR0=jac_log(LLR0);
    L_M_p(i)=L_M_a(i)+(LLR1-LLR0);
end


end

