function [c,s_f]=cc_encode(u,trellis,s_i,closed)

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
    disp(c(compteur*ns+ns))
    c(compteur*ns+1:compteur*ns+ns)=outputs(s_i(:),u(compteur*nb+1:compteur*nb+nb));
    s_i=nextStates(s_i,u(compteur*nb+1:compteur*nb+nb));
    compteur=compteur+1;
end

s_f=s_i;
end