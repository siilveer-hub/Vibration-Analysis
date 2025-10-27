function [noise, a_low]=low_comp(idx, a, n, m)
a_low = zeros;
noise = zeros;
if length(unique(idx)) == 1
    if idx(1)==1
        finded=1;
    else
        finded=0;
    end
else 
    if idx(1,1)==1
        finded=1;
    else 
        if  idx(1,1)==2
            finded=2;
        else 
            finded=0;
        end
    end
end

for j = 1:n-m+1
    if idx(j)==finded
        a_low = a_low + a(:,j);
    else 
        noise = noise + a(:,j);
    end
end

% s =  10*log10(sum(a_low.^2) ./ sum(noise.^2));
% s = snr(a_low,noise);
end
