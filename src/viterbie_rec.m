function [m,tabchem]=viterbie_rec(numstates,compteur,tabstates,valstates,pos,len,y)
metrique=zeros(1,4);    
if compteur==len
    tabchem=zeros(1,len);
    if pos==0
        m=0;
        tabchem(1)=0;
    else
        m=1e8;
        tabchem(1)=0;
    end
else
    for i=1:numstates
        if (tabstates(i,1)==pos && tabstates(i,2)==pos)
            [metrique(i),tabchem]=viterbie_rec(numstates,compteur+1,tabstates,valstates,tabstates(i),len,y);
            metrique(i)=metrique(i)+min(multiplie_y(y,len-compteur,numstates,valstates(tabstates(i),1)),multiplie_y(y,len-com,numstates,valstates(tabstates(i),2)));
        elseif (tabstates(i,1)==pos)
            [metrique(i),tabchem]=viterbie_rec(numstates,compteur+1,tabstates,valstates,tabstates(i),len,y);
            metrique(i)=metrique(i)+multiplie_y(y,len-compeur,numstates,valstates(tabstates(i),1));
        elseif (tabstates(i,2)==pos)
            [metrique(i),tabchem]=viterbie_rec(numstates,compteur+1,tabstates,valstates,tabstates(i),len,y);
            metrique(i)=metrique(i)+multiplie_y(y,len-compteur,numstates,valstates(tabstates(i),2));
        else
            metrique(i)=1e8;   
        end
    end
    m=min(metrique);
    tabchem(len-compteur+1)=pos;
end
end