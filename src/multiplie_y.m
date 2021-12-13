function [metrique]= multiplie_y(y,index,ns,valoutput)
    
    valoutputbin= zeros(1,ns);
     for k=1:ns    
            valoutputbin(k)=floor(valoutput/(2^(ns-k+1)));
            valoutput=valoutput-valoutputbin(k)*2^(ns-k+1);
     end
     metrique=0;
        for j=1:ns
            metrique = metrique +y(ns*(index-1) +j)*valoutputbin(j);
        end
        
end

    
    
        
    
    