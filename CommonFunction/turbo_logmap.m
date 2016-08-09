function L_D_p = turbo_logmap(L_D_a,turboInterleaver,G,numDecodeIteration)
%Using Log-MAP Algorithm to decode.
%Turbo decoder, give out the L_D_p
[n,K]=size(G);
m=K-1;
%Get the standard form of deMUXRecCode
[nL,kL]=size(L_D_a);
deMUXRecCode=zeros(2,2*kL);
for i=1:1:kL
    deMUXRecCode(1,2*(i-1)+1)=L_D_a(1,i);
    deMUXRecCode(2,2*(i-1)+1)=L_D_a(1,turboInterleaver(i));
    deMUXRecCode(1,2*i)=L_D_a(2,i);
    deMUXRecCode(2,2*i)=L_D_a(3,i);
end

%Turbo Decoder
L_e=zeros(1,kL);
for iter=1:numDecodeIteration
%Decoder 1
    L_a(turboInterleaver)=L_e; %A priori info
    L_all=logmapo(deMUXRecCode(1,:),G,L_a,1); %complete info.
    L_all=limit_number(L_all);
    L_e=L_all-2*deMUXRecCode(1,1:2:2*kL)-L_a; %extrinsic info
    L_e=limit_number(L_e);
    L_e1=L_e;
    
%Decoder 2
    L_a=L_e(turboInterleaver); %A priori info
    L_all=logmapo(deMUXRecCode(2,:),G,L_a,2); %complete info.
    L_all=limit_number(L_all);
    L_e=L_all-2*deMUXRecCode(2,1:2:2*kL)-L_a; %extrinsic info
    L_e=limit_number(L_e);
    L_e2=L_e;
end
L_D_p=zeros(3,kL);
tempL(turboInterleaver)=L_all;
L_D_p(1,:)=tempL;
L_D_p(2,:)=L_e1;
tempLe(turboInterleaver)=L_e2;
L_D_p(3,:)=tempLe;

end

