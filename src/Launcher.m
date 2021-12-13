clear; 
clc;
close all;
N=10;
u=randi([0,1],1,N);
%u=[1 1 0 0];
%trellis=poly2trellis(3,[5,7]);
trellis = poly2trellis(4,[13,15]);
%trellis = poly2trellis(7,[133 171]); 
s_i=0;
%commcnv_plotoutputs(trellis.outputs, trellis.numOutputSymbols)
closed=true;
[c,s_f]=cc_encode(u,trellis,s_i,closed);

y=1-c*2;

figure
plot(y)
title('signal encodé')
figure
plot(u)
title('plot original')

m=viterbi_decode(y,trellis,s_i,closed);

figure
plot(m)
title('signal décodé')