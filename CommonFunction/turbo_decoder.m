function L_D_p=turbo_decoder(L_D_a,turboInterleaver,G,numDecodeIteration)
%Using Log-MAP algorithm
L_D_p = turbo_logmap(L_D_a,turboInterleaver,G,numDecodeIteration);
%Using SOVA algorithm
%L_D_p = turbo_sova(L_D_a,turboInterleaver,G,numDecodeIteration);

end

