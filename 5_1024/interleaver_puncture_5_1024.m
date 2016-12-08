function L_M_a=interleaver_puncture_5_1024(L_D_e,QAMInterleaver)
%Give out L_M_a, using QAM interleaver and puncture

[n,k]=size(L_D_e);
%Rearrange to 1 dimension matrix
oneDimension=[];
for i=1:1:k
    for j=1:1:n
        oneDimension=[oneDimension,L_D_e(j,i)];
    end
end
%Add 0
l=mod(n*k,length(QAMInterleaver));
if l~=0
    pp=zeros(1,length(QAMInterleaver)-l);
    oneDimension=[oneDimension,pp];
end
%Reshape
matrixReshape=[];
for i=1:length(QAMInterleaver):length(oneDimension)
    ppp=oneDimension(1,i:(i+length(QAMInterleaver)-1));
    matrixReshape=[matrixReshape;ppp];
end
%Apply interleaver and puncture
tempL=[];
for i=1:1:(length(oneDimension)/length(QAMInterleaver))
    temp=matrixReshape(i,:);
    tempInt=temp(QAMInterleaver);
    tempIntPunc=tempInt(1,1:10);
    tempL=[tempL,tempIntPunc];
end

L_M_a=tempL;


end

