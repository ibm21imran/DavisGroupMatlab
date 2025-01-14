%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CODE DESCRIPTION: Using the locations of Cu atoms and the associated Ox
% and Oy atoms, the parameter INR is calculated.  This quantity describes the
% imbalance of charge (current at each bias) in between the x and y 
% direction for each copper atom.  The number px_avg defined number of pixels 
% around each Ox and Oy site to be averaged. px_avg = 0 means no averaging.
% Patch size defines the number of pixels around each Cu atoms to assign
% the value of INR(i).  I_map should be the shear corrected and offset
% corrected simultaneous current map.
%
% ALGORITHM: INR(i) = (abs(I(Ox(i))) - abs(I(Oy(i))))/sqrt(sum_i(Ix^2) +
% sum_i(Ix^2))
%
% CODE HISTORY
%
% 100914 MHH Created

function new_map = INR(Cu_index,Ox_index, Oy_index,I_map,px_avg,patch_size)
[nr nc nz] = size(I_map.map);
new_map = I_map;
new_map.map = zeros(nr,nc,nz);
if px_avg > 1
    px_avg = 1;
end
p = patch_size;
for n = 1:nz
    normalization = 0;      
    for i = 1:size(Cu_index,1)
        p = patch_size;
        if (Oy_index(i,1) ~= 0 && Oy_index(i,2) ~= 0 && Ox_index(i,1) ~= 0 && Ox_index(i,2) ~= 0)
            Ix = mean(mean(I_map.map(Ox_index(i,1)-px_avg:Ox_index(i,1)+px_avg,...
                Ox_index(i,2)-px_avg:Ox_index(i,2)+px_avg,n))); 
            Iy = mean(mean(I_map.map(Oy_index(i,1)-px_avg:Oy_index(i,1)+px_avg,...
                Oy_index(i,2)-px_avg:Oy_index(i,2)+px_avg,n)));                        
        
            normalization = normalization + (Ix^2 + Iy^2); %add up intensities at all O sites
            while (Cu_index(i,1) <= p  || Cu_index(i,2) <= p || Cu_index(i,1) > nr-p || Cu_index(i,2) > nr-p)
                p = p-1;
            end
            new_map.map(Cu_index(i,1)-p:Cu_index(i,1)+p,Cu_index(i,2)-p:Cu_index(i,2)+p,n) =...
                (abs(Ix) - abs(Iy));
        end            
    end        
    new_map.map(:,:,n) = new_map.map(:,:,n)/sqrt(normalization);
end
end

