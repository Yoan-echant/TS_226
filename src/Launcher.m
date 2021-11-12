clear; 
clc;
close all;
N=10;
u=randi([0,1],1,N);
trellis=poly2trellis(3,[5,7]);
s_i=0;
closed=1; %1 is TRUE
[c,s_f]=cc_encode(u,trellis,s_i,closed);


figure
plot(c)
title('signal encodé')
figure
plot(u)
title('plot original')