function [info,turboCode,turboInterleaver] = code_generator(blockSize,blockNumber,G)
%Info(numberBlocks,blockSize-(m=K-1)): Original binary info
%TuboCode(numberBlocks,blockSize): Output matrix of turbo code

%Number of Trellis state
[n,K]=size(G);
m=K-1;

%Random Interleaver Generate
[temp,turboInterleaver]=sort(rand(1,blockSize));
%Generate Info bits
info=round(rand(blockNumber,blockSize-m));

%Turbo Code Generation
turboCode=[];
for i=1:blockNumber
    tempInfo=info(i,:);
    tempTurboCode=turbo_encoder(tempInfo,G,turboInterleaver);
    turboCode=[turboCode;tempTurboCode];
end

end

