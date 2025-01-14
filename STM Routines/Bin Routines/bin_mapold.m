%%%%%%%
% CODE DESCRIPTION: Given a 2-D map, bin_map creates a new 2-D image which
% replaces the full range of data values with their binned ones.  The
% function uses the maximum and minimum values of the original data as well as the
% the user input for the number of bins to generate a set of bin values.  
% The new map only contains these bine values. 
%   
% CODE HISTORY
% 080701 MHH  Created
% 
% INPUT: fdata - 2D data set; nbin - the number of bins
% OUTPUT: new_data - the binned 2D map; binval  - a list of the bin values
% contained in the map

function [new_data binval] = bin_map(fdata,nbin,clmap)
format long;
[sx sy sz] = size(fdata);
new_data = zeros(sx,sy,sz);
%maxval = high; minval = low;
maxval = max(max(max(fdata)));
minval = min(min(min(fdata)));

%from max and min values of data matrix (possibly 3D matrix) calculate bin
%size

if nbin==1
    new_data(:,:,:) = mean(mean(mean(fdata)));
    figure; pcolor(new_data); shading interp; 
    return;
else
    bin_size = ((maxval - minval)/(nbin));
    bins = minval + (0:nbin)*bin_size;
    binval = minval +((0:nbin-1) + 0.5)*bin_size;
end
    
for k = 1:sz
    % if map value is negative take close lower integer in magnitude
    for i=1:nbin-1
        tmp = (fdata(:,:,k) >= bins(i) & fdata(:,:,k) < bins(i+1));
        new_data(tmp) = binval(i);
        clear tmp;
    end
     tmp = (fdata(:,:,k) >= bins(nbin) & fdata(:,:,k) <= bins(nbin+1));
     new_data(tmp) = binval(nbin);
end
figure; 
subplot(1,2,1);pcolor(new_data); shading interp;colormap(clmap); 
subplot(1,2,2);histogram(new_data,nbin);
end