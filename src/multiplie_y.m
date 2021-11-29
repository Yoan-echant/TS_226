function [metrique]= multiplie_y(y,index,numStates,valoutput)
    ns = log2(numStates);
    valoutputbin= zeros(1,ns);
     for k=1:ns    
            valoutputbin(k)=floor(valoutput/(2^(ns-k)));
            valoutput=valoutput-valoutputbin(k)*2^(ns-k);
     end
     metrique=0;
        for j=1:ns
            metrique = metrique +y(ns*(index-1) +j)*valoutputbin(j);
        end
        
end

    
    
        
    
    