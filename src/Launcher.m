clear; 
clc;
close all;
N=10;
u=randi([0,1],1,N);
trellis=poly2trellis(3,[5,7]);
s_i=1;
closed=1; %1 is TRUE
%[c,s_f]=cc_encode(u,trellis,s_i,closed);


numInputSymbols=trellis.numInputSymbols;
numOutputSymbols=trellis.numOutputSymbols;
numStates=trellis.numStates;
nextStates=trellis.nextStates;
outputs=trellis.outputs;

ns=log2(numOutputSymbols);
K=length(u);
L=log2(numStates)+1;
nb=log2(numInputSymbols);

if (closed==0)
    longc=ns*L;
else
    longc=ns*K;
end
c=zeros(longc,1);

compteur=0;

while (compteur<longc/ns)
    disp(u(compteur+1)+1)
    c(compteur*ns+1:compteur*ns+ns)=outputs(s_i,u(compteur+1)+1);
    s_i=nextStates(s_i,u(compteur+1)+1);
    compteur=compteur+1;
end

s_f=s_i;




figure
plot(c)
title('signal encodé')
figure
plot(u)
title('plot original')