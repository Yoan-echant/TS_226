function [m,chem]=viterbie_rec(numstates,compteur,tabstates,valstates,pos,len,y)
metrique=zeros(1,numstates);
tabchem=zeros(len,numstates);
%disp(numstates);
if compteur==len
    chem=zeros(len,1);
    if pos==1
        m=0;
        chem(1)=0;
    else
        m=1e8;
        chem(1)=0;
    end
else
    for i=1:numstates
        if (tabstates(i,1)==pos && tabstates(i,2)==pos)
           if (mulitplie_y(y,len-compteur,numstates,valstates(i,1))< multiplie_y(y,len-compteur,numstates,valstates(i,2)))
                [metrique(i),tabchem(:,i)]=viterbie_rec(numstates,compteur+1,tabstates,valstates,i,len,y);
                metrique(i)=metrique(i)+multiplie_y(y,len-commpteur,numstates,valstates(i,1));
                tabchem(len-compteur,i)=0;
                disp([pos "a" i "comme antécedant pour 0 et 1 mais est plus court pour 0 avec un chemin de" metrique(i)])
           else
                [metrique(i),tabchem(:,i)]=viterbie_rec(numstates,compteur+1,tabstates,valstates,i,len,y);
                metrique(i)=metrique(i)+multiplie_y(y,len-compteur,numstates,valstates(i,2));
                tabchem(len-compteur,i)=1;
                disp([pos "a" i "comme antécedant pour 0 et 1 mais est plus court pour 1 avec un chemin de" metrique(i)])
           end
        elseif (tabstates(i,1)==pos)
            [metrique(i),tabchem(:,i)]=viterbie_rec(numstates,compteur+1,tabstates,valstates,i,len,y);
            metrique(i)=metrique(i)+multiplie_y(y,len-compteur,numstates,valstates(i,1));
            tabchem(len-compteur,i)=0;
            disp([pos "a" i "comme antécedant pour 0 avec un chemin de" metrique(i)])
        elseif (tabstates(i,2)==pos)
            [metrique(i),tabchem(:,i)]=viterbie_rec(numstates,compteur+1,tabstates,valstates,tabstates(i),len,y);
            metrique(i)=metrique(i)+multiplie_y(y,len-compteur,numstates,valstates(i,2));
            tabchem(len-compteur,i)=1;
            disp([pos "a" i "comme antécedant pour 1 avec un chemin de" metrique(i)])
        else
            disp([pos " n'a pas " i "comme antécedant par 0" tabstates(i,1) "ni par 1" tabstates(i,2)])
            metrique(i)=1e8;   
        end
    end
    [m,index]=min(metrique);
    %disp(index)
    %disp(size(tabchem))
    %disp(metrique)
    chem=tabchem(:,index);
    %disp(chem)
end
end