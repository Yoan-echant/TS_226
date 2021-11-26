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


end