function [output,state] = encode_bit(G,input,state)
% This function takes as an input a single bit to be encoded,
% as well as the coeficients of the generator polynomials and
% the current state vector.
% It returns as output n encoded data bits, where 1/n is the
% code rate.

[n,K]=size(G);
m=K-1;

%Determine the next output bit
for i=1:n
    output(i)=G(i,1)*input;
    for j=2:K
        output(i)=xor(output(i),G(i,j)*state(j-1));
    end
end
state=[input,state(1:m-1)];

end

