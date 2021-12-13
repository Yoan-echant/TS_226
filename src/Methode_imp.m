function TEP=Methode_imp(K,N,R,EbN0,trellis,s_i,closed)

d0=1;
d1=100;

v=zeros(1,K);
x=zeros(1,K);


for l=1:K
    A=d0-0.5;
    X=x;
    while (X==x & A<d1)
        A=A+1;
        y=ones(1,N);
        y(l)=A-1;
        X=viterbi_decode(y,trellis,s_i,closed);
        
    end
    v(l)=A;
    
end
D=[];
Ad=[];
for i=1:K
    if (sum(v(i)==D)==0)
        D=[D, v(i)];
        Ad=[Ad, sum(v(i)==v)];
    end
    
end

TEP=sum(Ad.*erfc(sqrt(D*R*EbN0)))/2;
