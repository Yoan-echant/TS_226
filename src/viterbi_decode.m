function u2=viterbi_decode(y,trellis,s_i,closed)

numInputSymbols=trellis.numInputSymbols;
numOutputSymbols=trellis.numOutputSymbols;
numStates=trellis.numStates;
nextStates=trellis.nextStates+1;
outputs=trellis.outputs;

ns=log2(numOutputSymbols);
L=round(length(y)/ns);


nb=log2(numInputSymbols);



disp(L)



u=zeros(1,L);
metrique=ones(1,numStates*(L+1))*100;
chem=zeros(2,numStates*(L+1));
metrique(1,s_i+1)=0;
for index=0:L-1
    for i=1:numStates
        for j=1:numInputSymbols
            cost=outputs(i,j);
            dest=nextStates(i,j);
            if (metrique((index+1)*numStates+dest) > metrique(numStates*index+i)+multiplie_y(y,index+1,ns,cost))
                metrique((index+1)*numStates+dest) = metrique(numStates*index+i)+multiplie_y(y,index+1,ns,cost);
                chem(:,(index+1)*numStates+dest)=[i,j-1];
                %disp(["A l'étape" index+1 "On arrive a" dest "depuis" i "avec" j-1 "et metrique" metrique((index+1)*numStates+dest) "cost" cost])
            end
        end
    end
end
if (closed)
    state=1;
else
    [metr,state]=min(metrique(numStates*L:numStates*(L+1)));
end
%disp(metrique)
%disp(chem)

for i=L:-1:1
    u(i)=chem(2,i*numStates+state);
    state=chem(1,i*numStates+state);
end
if (closed)
    u2=u(1:L-ns);
else
    u2=u;
end
end