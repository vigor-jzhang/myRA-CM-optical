function [sentQAM,QAMInterleaver,X,pX] = mapper_4_256(turboCode,SNR)
%Mapper for uniform 256-QAM, l_max is 8 (each dimension is 6)

[blockNumber,codeLength]=size(turboCode);
%7 bits per channel use
%Way of puncture and interleave:
% 1    2   3   4    5   6    7   8   9   10  11   12  13   14  15  16  17
%[a1] u11 u12 [a2] u21 u22 [a3] u31 u32 [a4] u41 u42 [a5] u51 u52 [a6] u61
%18   19  20  27
%u62 [a7] u71 u72
% 16   10   1    13   4    19   7    14     2   3   5   6  8    9  12  11
%[a6] [a4] [a1] [a5] [a2] [a7] [a3] u51  | u11 u12 u21 u22 u31 u32 u42 u41
%15  17   18  20  21
%u52 u61 u62 u71 u72
QAMInterleaver=[16 10 1 13 4 19 7 14 2 3 5 6 8 9 11 12 15 17 18 20 21];
X=[15 13 11 9 7 5 3 1 -1 -3 -5 -7 -9 -11 -13 -15];
pX=[1/16 1/16 1/16 1/16 1/16 1/16 1/16 1/16 1/16 1/16 1/16 1/16 1/16 1/16 1/16 1/16];
%Calculate P
P=10.^(SNR./10);
%Calculate average power
X=X/sqrt(sum(abs(X).^2.*pX))*sqrt(P);

bitTable=[1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0;
          0 0 0 0 1 1 1 1 1 1 1 1 0 0 0 0;
          0 0 1 1 1 1 0 0 0 0 1 1 1 1 0 0;
          0 1 1 0 0 1 1 0 0 1 1 0 0 1 1 0];

sentQAM=[];
for label=1:blockNumber
    tempTurboCode=turboCode(label,:);
    %Add 0 to turbo code
    templ=mod(length(tempTurboCode),length(QAMInterleaver));
    if templ~=0
        pp=zeros(1,length(QAMInterleaver)-templ);
        tempTurboCode=[tempTurboCode,pp];
    end
    %Reshape
    tempBinQAM=[];
    for i=1:length(QAMInterleaver):length(tempTurboCode)
        ppp=tempTurboCode(1,i:(i+length(QAMInterleaver)-1));
        tempBinQAM=[tempBinQAM;ppp];
    end
    binQAM=[];
    %Apply interleaver and puncture
    for i=1:1:(length(tempTurboCode)/length(QAMInterleaver))
        temp=tempBinQAM(i,:);
        tempInt=temp(QAMInterleaver);
        tempIntPunc=tempInt(1,1:8);
        binQAM=[binQAM;tempIntPunc];
    end
    %Map
    tempSentQAM=[];
    for i=1:1:(length(tempTurboCode)/length(QAMInterleaver))
        tempBinQAM1=binQAM(i,1:4);
        tempBinQAM2=binQAM(i,5:8);
        QAMSymbol1=qam_mapper(tempBinQAM1,X,bitTable);
        QAMSymbol2=qam_mapper(tempBinQAM2,X,bitTable);
        tempSentQAM=[tempSentQAM,QAMSymbol1,QAMSymbol2];
    end
    sentQAM=[sentQAM;tempSentQAM];
end

%Mapper
    function QAMSymbol=qam_mapper(binQAM,X,bitTable)
        if length(binQAM)~=4
            error('Binary QAM length is not equal to 4.(l_max=8,256-QAM)');
        end
        num=0;
        for k=1:1:16
            flag=0;
            for p=1:1:4
                if (bitTable(p,k)~=binQAM(p))
                    flag=1;
                end
            end
            if flag==0
                QAMSymbol=X(k);
                num=num+1;
            end
        end
        if num==0
            error('Mapper, mapping is failed.');
        end
        if num>1
            error('Mapper, more than one mapping decesion.');
        end
    end

end

