function output = rsc_encoder(G,input,terminated)
%RSC Encoder
%Encodes a block of data x (0/1)with a recursive systematic.
%Convolutional code with generator vectors in g, and returns the 
%output in y (0/1).
%If terminated >0 (1), the trellis is perfectly terminated.
%If terminated <0 (-1), it is left unterminated.

%Dependence: --|<--encode_bit.m

%Constraint length K, memory m, information bits
[n,K]=size(G);
m=K-1;
if terminated>0
    infoLen=length(input);
    blockLen=infoLen+m;
else
    blockLen=length(input);
    infoLen=blockLen-m;
end

%Initialize the state vector
state=zeros(1,m);

%Generate codeword
for i=1:blockLen
    if terminated<0 || (terminated>0 && i<=infoLen)
        d_k=input(1,i);
    elseif terminated>0 && i>infoLen
        %Terminate the trellis
        d_k=rem(G(1,2:K)*state',2);
    end
    
    a_k=rem(G(1,:)*[d_k state]',2);
    [output_bits,state]=encode_bit(G,a_k,state);
    %Systematic, then first output is input bit.
    output_bits(1,1)=d_k;
    output(n*(i-1)+1:n*i)=output_bits;
end

end

