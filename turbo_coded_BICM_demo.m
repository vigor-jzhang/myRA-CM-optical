%This script is used for simulating the turbo coded BICM system transmitter
%and receiver, based on the paper "Rate-Adaptive". Refer the program of
%Yufei Wu, MPRG lab, Virginia Tech.

clear all;
clc;
addpath(genpath(pwd));

%% Simulation Environment Setup

%Block size
blockSize=5000;
%One test, blocks number
blockNumber=5;
%Tests number
testNumber=1;

%Code Generator
G=[1 0 0 1 1; 1 1 1 1 1];
%l_max for coded modulation
%4 for uniform 256-QAM, 5 for uniform 1024-QAM, 10 and 12 for 256-QAM, 14 and 16 for 1024-QAM
l_max=16;
%Demapping iteration
numDemapIteration=5;
%Decoding iteration
numDecodeIteration=4;
%SNR
arraySNR=25;

%% Simulation
errorRate=zeros(1,length(arraySNR));
switch l_max
    case 4
        fid=fopen('4_256.txt','a+');
    case 5
        fid=fopen('5_1024.txt','a+');
    case 10
        fid=fopen('10_256.txt','a+');
    case 12
        fid=fopen('12_256.txt','a+');
    case 14
        fid=fopen('14_1024.txt','a+');
    case 16
        fid=fopen('16_1024.txt','a+');
    otherwise
        error('The l_max is uncorrect.\n');
end
for j=1:length(arraySNR)
    SNR=arraySNR(j);
    totalError=0;
    for i=1:1:testNumber
        error = main_function(blockSize,blockNumber,G,l_max,numDemapIteration,numDecodeIteration,SNR);
        totalError=totalError+error;
        timeNow=datestr(now,0);
        fprintf(fid,'Time: %s\r\n',timeNow);
        fprintf(fid,'For SNR= %g, %d test, error number: %d for %d blocks.\r\n\r\n',SNR,i,error,blockNumber);
    end
    errorRate(j)=totalError/(blockSize*blockNumber*testNumber);
    save SNR_BER.mat arraySNR errorRate;
    fprintf(fid,'Time: %s\r\n',timeNow);
    fprintf(fid,'For SNR= %g, total error number: %d, error rate: %g.\r\n\r\n',SNR,totalError,errorRate(j));
end
fclose(fid);

