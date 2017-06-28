function [ssf] = SSF_function(ppg)
n = length(ppg);
ssf = 0;
    for i=n:-1:2
        delta = ppg(i-1)-ppg(i);
        if delta>0    
                ssf = ssf+delta;
        end
    end

end

