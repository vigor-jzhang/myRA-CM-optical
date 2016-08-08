function outputTurboCode=turbo_encoder(tempInfo,G,turboInterleaver)
%Turbo code generator.
%Use interleaver from code_generator.
%Unpuncturing, Rate=1/3;

%Constraint length K, memory m, info length and block size
[n,K]=size(G);
m=K-1;
infoLen=length(tempInfo);
blockSize=infoLen+m;

%Generate the codeword corresponding to the 1st RSC coder
%end=1, perfectly terminated
input=tempInfo;
output1=rsc_encoder(G,input,1);

%Make a matrix with first row corresponing to info sequence,
%second row corresponsing to RSC #1's check bits,
%and third row corresponsing to RSC #2's check bits.
y(1,:)=output1(1:2:2*blockSize);
y(2,:)=output1(2:2:2*blockSize);

%Interleave input to second encoder
for i=1:blockSize
    input2(1,i)=y(1,turboInterleaver(i));
end
output2=rsc_encoder(G,input2(1,1:blockSize),-1);
y(3,:)=output2(2:2:2*blockSize);

%Unpuncturing
for i=1:blockSize
    for j=1:1:3
        outputTurboCode(1,3*(i-1)+j)=y(j,i);
    end
end

end

