function TEP=Methode_imp(K,N,R,Eb,No,treillis,s_i,closed)

d0=1;
d1=100;

v=zeros(1,K);
x=zeros(1,K);


for l=1:K
    A=d0-0.5;
    X=x;
    while (X==x && A<d1)
        A=A+1;
        y=ones(1,N);
        y(l)=A-1;
        X=viterbi_decode(y,treillis,s_i,closed);
    end
    v(l)=A;
end
D=[]
Ad=[]
for i=1:k
    if (sum(v(l)==D)==0)
        D=[D, v(l)];
        Ad=[Ad, sum(v(l)==v)]
    end
end

TEP=sum(Ad.*erfc(sqrt(D*R*Eb/No)))/2;
