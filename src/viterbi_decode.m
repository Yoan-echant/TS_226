function u=viterbi_decode(y,trellis,s_i,closed)

numInputSymbols=trellis.numInputSymbols;
numOutputSymbols=trellis.numOutputSymbols;
numStates=trellis.numStates;
nextStates=trellis.nextStates;
outputs=trellis.outputs;

ns=log2(numOutputSymbols);
K=length(u);
L=log2(numStates)+1;
nb=log2(numInputSymbols);

u=zeros(K,1);
len=numStates*(L+1);


viterbie_rec(numstates,0,nextStates,outputs,1,len,y)

%{
metrique=zeros(1,numStates*(L+1));
u=zeros(1,L+1);
for i=2:L+1
    for j=1:numStates
        val=output(s_i+1,1);
        if (metrique(i+state)+<metrique(i+state));
        
        state=outputs(s_i+1,2);
        metrique(i+state)=metrique(i-1+j);
        end
    end
end
%}
end