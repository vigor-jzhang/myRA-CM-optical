function error = main_function(blockSize,blockNumber,G,l_max,numDemapIteration,numDecodeIteration,SNR)
%The main body for the simulation of turbo code BICM system

%% Turbo Coded BICM Transmitter
%Turbo Code Generate, unpuncturing, Rate=1/3
[info,turboCode,turboInterleaver]=code_generator(blockSize,blockNumber,G);

%Mapper
switch l_max
    case 4
        [sentQAM,QAMInterleaver,X,pX]=mapper_4_256(turboCode,SNR);
    case 5
        [sentQAM,QAMInterleaver,X,pX]=mapper_5_1024(turboCode,SNR);
    case 10
        [sentQAM,QAMInterleaver,X,pX]=mapper_10_256(turboCode,SNR);
    case 12
        [sentQAM,QAMInterleaver,X,pX]=mapper_12_256(turboCode,SNR);
    case 14
        [sentQAM,QAMInterleaver,X,pX]=mapper_14_1024(turboCode,SNR);
    case 16
        [sentQAM,QAMInterleaver,X,pX]=mapper_16_1024(turboCode,SNR);
    otherwise
        display('Mapper switch error!\n');
end

%% AWGN Channel

%Generate white noise
[sentM,sentN]=size(sentQAM);
whiteNoise=randn(sentM,sentN);
%Pass the AWGN Channel
receivedQAM=sentQAM+whiteNoise;

%% AWGN Auxiliary Channel Verify
tempSent=[];
tempRec=[];
for i=1:blockNumber
    tempSent=[tempSent sentQAM(i,:)];
    tempRec=[tempRec receivedQAM(i,:)];
end
estimationH=(tempSent*tempRec')/(tempSent*tempSent');
estimationSigma=(tempRec*tempRec'-(abs(estimationH))^2*(tempSent*tempSent'))/(length(tempSent));
sentPower=10*log10(mean(abs(receivedQAM(:)).^2));
display(estimationH);
display(estimationSigma);
display(sentPower);
clear tempSent tempRec estimationH estimationSigma sentPower;

%% Turbo Coded BICM Receiver

%Demapper and decoder
error=0;
for i=1:1:blockNumber
    testInfo=info(i,:);
    recQAMSet=receivedQAM(i,:);
    switch l_max
        case 4
            estimateInfo=demap_decode_4_256(recQAMSet,G,turboInterleaver,QAMInterleaver,X,pX,numDemapIteration,numDecodeIteration);
        case 5
            estimateInfo=demap_decode_5_1024(recQAMSet,G,turboInterleaver,QAMInterleaver,X,pX,numDemapIteration,numDecodeIteration);
        case 10
            estimateInfo=demap_decode_10_256(recQAMSet,G,turboInterleaver,QAMInterleaver,X,pX,numDemapIteration,numDecodeIteration);
        case 12
            estimateInfo=demap_decode_12_256(recQAMSet,G,turboInterleaver,QAMInterleaver,X,pX,numDemapIteration,numDecodeIteration);
        case 14
            estimateInfo=demap_decode_14_1024(recQAMSet,G,turboInterleaver,QAMInterleaver,X,pX,numDemapIteration,numDecodeIteration);
        case 16
            estimateInfo=demap_decode_16_1024(recQAMSet,G,turboInterleaver,QAMInterleaver,X,pX,numDemapIteration,numDecodeIteration);
        otherwise
            display('Demapper and decoder error!\n');
    end
    errorSet=length(find(estimateInfo~=testInfo));
    display(errorSet);
    error=error+errorSet;
end


end

