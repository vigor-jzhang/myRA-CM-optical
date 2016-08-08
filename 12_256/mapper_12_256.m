function [sentQAM,QAMInterleaver,X,pX] = mapper_12_256(turboCode,SNR)
%Mapper for 256-QAM, l_max is 12 (each dimension is 6)

[blockNumber,codeLength]=size(turboCode);
%7 bits per channel use
%Way of puncture and interleave:
% 1    2   3   4    5   6    7   8   9   10  11   12  13   14  15  16  17
%[a1] u11 u12 [a2] u21 u22 [a3] u31 u32 [a4] u41 u42 [a5] u51 u52 [a6] u61
%18   19  20  27
%u62 [a7] u71 u72
% 16   10   1    13   15  2   4    19   7    9    14   18     3   5   6  8  12   11    
%[a6] [a4] [a1] [a5] u52 u11 [a2] [a7] [a3] u32  u51  u62 | u12 u21 u22 u31 u42 u41
%17  20  21
%u61 u71 u72
QAMInterleaver=[16 10 1 13 15 2 4 19 7 9 14 18 3 5 6 8 12 11 17 20 21];

%BELOW IS NOT FOR L=12, IT IS COPYED FROM L=10!!!!!
%6 bits per channel use
%Way of puncuture and interleave:
% 1    2   3   4    5   6    7   8   9   10  11   12  13   14  15  16  17
%[a1] u11 u12 [a2] u21 u22 [a3] u31 u32 [a4] u41 u42 [a5] u51 u52 [a6] u61
%18 
%u62
%13    4    10  2   9    7    16   1    14  18
%[a5] [a2] [a4] u11 u32 [a3] [a6] [a1] u51 u62 |
%QAMInterleaver=[13 4 10 2 9 7 16 1 14 18 3 5 6 8 11 12 15 17];

%4 bits per channel use
%Way of puncture and interleave:
% 1    2   3   4    5   6    7   8   9   10  11   12
%[a1] u11 u12 [a2] u21 u22 [a3] u31 u32 [a4] u41 u42
% 10   4    6   3   9   7    1    8   2   11   5    12
%[a4] [a2] u22 u12 u32 [a3] [a1] u31 u11 u41 | u21 u42
%QAMInterleaver=[10 4 6 3 9 7 1 8 2 11 5 12];

%5 bits per channel use
%Way of puncuture and interleave:
% 1    2   3   4    5   6    7   8   9   10  11   12  13   14  15
%[a1] u11 u12 [a2] u21 u22 [a3] u31 u32 [a4] u41 u42 [a5] u51 u52
% 13   7    1    5   11  4    10   15  3   9
%[a5] [a3] [a1] u21 u41 [a2] [a4] u52 u12 u32 |
%QAMInterleaver=[13 7 1 5 11 4 10 15 3 9 2 6 8 12 14];

X=[15 13 11 9 7 5 3 1 -1 -3 -5 -7 -9 -11 -13 -15];
pX=[1/64 1/64 1/32 1/16 1/16 1/16 1/8 1/8 1/8 1/8 1/16 1/16 1/16 1/32 1/64 1/64];
%Calculate P
P=10.^(SNR./10);
%Calculate average power
X=X/sqrt(sum(abs(X).^2.*pX))*sqrt(P);

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
        tempIntPunc=tempInt(1,1:12);
        binQAM=[binQAM;tempIntPunc];
    end
    %Map
    tempSentQAM=[];
    for i=1:1:(length(tempTurboCode)/length(QAMInterleaver))
        tempBinQAM1=binQAM(i,1:6);
        tempBinQAM2=binQAM(i,7:12);
        QAMSymbol1=qam_mapper(tempBinQAM1,X);
        QAMSymbol2=qam_mapper(tempBinQAM2,X);
        tempSentQAM=[tempSentQAM,QAMSymbol1,QAMSymbol2];
    end
    sentQAM=[sentQAM;tempSentQAM];
end

%Mapper
%15  000000  13 000001  11 00001X  9  0001XX  7  0011XX  5  0010XX
%3  011XXX  1  010XXX  -1 110XXX  -3  111XXX  -5  1010XX  -7  1011XX  
%-9  1001XX  -11  10001X  -13  100001  -15  100000
    function QAMSymbol=qam_mapper(binQAM,X)
        if length(binQAM)~=6
            error('Binary QAM length is not equal to 6.(l_max=12,256QAM)');
        end
        if (binQAM(1)==0 && binQAM(2)==0 && binQAM(3)==0 && binQAM(4)==0 && binQAM(5)==0 && binQAM(6)==0)
            QAMSymbol=X(1);
        end
        if (binQAM(1)==0 && binQAM(2)==0 && binQAM(3)==0 && binQAM(4)==0 && binQAM(5)==0 && binQAM(6)==1)
            QAMSymbol=X(2);
        end
        if (binQAM(1)==0 && binQAM(2)==0 && binQAM(3)==0 && binQAM(4)==0 && binQAM(5)==1)
            QAMSymbol=X(3);
        end
        if (binQAM(1)==0 && binQAM(2)==0 && binQAM(3)==0 && binQAM(4)==1)
            QAMSymbol=X(4);
        end
        if (binQAM(1)==0 && binQAM(2)==0 && binQAM(3)==1 && binQAM(4)==1)
            QAMSymbol=X(5);
        end
        if (binQAM(1)==0 && binQAM(2)==0 && binQAM(3)==1 && binQAM(4)==0)
            QAMSymbol=X(6);
        end
        if (binQAM(1)==0 && binQAM(2)==1 && binQAM(3)==1)
            QAMSymbol=X(7);
        end
        if (binQAM(1)==0 && binQAM(2)==1 && binQAM(3)==0)
            QAMSymbol=X(8);
        end
        if (binQAM(1)==1 && binQAM(2)==1 && binQAM(3)==0)
            QAMSymbol=X(9);
        end
        if (binQAM(1)==1 && binQAM(2)==1 && binQAM(3)==1)
            QAMSymbol=X(10);
        end
        if (binQAM(1)==1 && binQAM(2)==0 && binQAM(3)==1 && binQAM(4)==0)
            QAMSymbol=X(11);
        end
        if (binQAM(1)==1 && binQAM(2)==0 && binQAM(3)==1 && binQAM(4)==1)
            QAMSymbol=X(12);
        end
        if (binQAM(1)==1 && binQAM(2)==0 && binQAM(3)==0 && binQAM(4)==1)
            QAMSymbol=X(13);
        end
        if (binQAM(1)==1 && binQAM(2)==0 && binQAM(3)==0 && binQAM(4)==0 && binQAM(5)==1)
            QAMSymbol=X(14);
        end
        if (binQAM(1)==1 && binQAM(2)==0 && binQAM(3)==0 && binQAM(4)==0 && binQAM(5)==0 && binQAM(6)==1)
            QAMSymbol=X(15);
        end
        if (binQAM(1)==1 && binQAM(2)==0 && binQAM(3)==0 && binQAM(4)==0 && binQAM(5)==0 && binQAM(6)==0)
            QAMSymbol=X(16);
        end
    end

end

