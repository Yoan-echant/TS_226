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

compteur=1;

while (compteur<=longc/ns)
    
    val=outputs(s_i+1,u(compteur)+1);
    
    for i=1:ns
        c((compteur-1)*ns+i)=floor(val/(2^(ns-i)));
        
        val=val-c((compteur-1)*ns+i)*2^(ns-i);
    end
    
    s_i=nextStates(s_i+1,u(compteur)+1);
    compteur=compteur+1;
end

s_f=s_i;

end