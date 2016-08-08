function L_D_a=deinterleaver_depuncture_16_1024(L_M_e,QAMInterleaver,turboL)
%Give out the L_D_a
%QAM depuncture and deinterleaver
tempL=[];
for i=1:16:length(L_M_e)
    tempFifteen=L_M_e(1,i:(i+15));
    %Add zeros
    pp=zeros(1,length(QAMInterleaver)-16);
    tempT21=[tempFifteen,pp];
    %QAM deinterleaver
    temp21(QAMInterleaver)=tempT21;
    tempL=[tempL,temp21];
end

tempL=tempL(1,1:turboL*3);
%L_D_a structure: L_D_a(1,:) for systematic bits, L_D_a(2,:) for 1st parity
%bits, L_D_a(3,:) for 2nd parity bits
L_D_a=zeros(3,length(tempL)/3);
for i=1:1:length(tempL)/3
    L_D_a(1,i)=tempL((i-1)*3+1);
    L_D_a(2,i)=tempL((i-1)*3+2);
    L_D_a(3,i)=tempL((i-1)*3+3);
end


end

