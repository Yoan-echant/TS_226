function [c,s_f]=cc_encode(u,trellis,s_i,closed)


numInputSymbols=trellis.numInputSymbols;
numOutputSymbols=trellis.numOutputSymbols;
numStates=trellis.numStates;
nextStates=trellis.nextStates;
outputs=trellis.outputs;

nb=log2(numOutputSymbols);
ns=log2(numInputSymbols);
K=length(u);

nl=log2(numStates);
L=length(u)+nl;
ns=log2(numInputSymbols);

if (closed)
    longc=ns*L;
else
    longc=ns*K;
end
c=zeros(longc,1);

compteur=1;

while (compteur<=K)
    
    val=outputs(s_i+1,u(compteur)+1);
    
    for i=1:ns
        c((compteur-1)*ns+i)=floor(val/(2^(ns-i+1)));
        val=val-c((compteur-1)*ns+i)*2^(ns-i+1);
        
    end
    
    s_i=nextStates(s_i+1,u(compteur)+1);
    compteur=compteur+1;
end

%%Détermination du chemin de fermeture


          
%%Fermeture
while (compteur<=longc/ns)
    
    val=outputs(s_i+1,1);
    
    for i=1:ns
        c((compteur-1)*ns+i)=floor(val/(2^(ns-i+1)));
        
        val=val-c((compteur-1)*ns+i)*2^(ns-i+1);
    end
    
    s_i=nextStates(s_i+1,1);
    compteur=compteur+1;
end

s_f=s_i;

end