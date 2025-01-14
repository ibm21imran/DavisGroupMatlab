%%%%%%%
% CODE DESCRIPTION: Calculation of the 2D normalized cross correlation of
% two equally sized maps
%   
% INPUT: The function accepts two matrices representing the data sets
% OUTPUT:
%
% CODE HISTORY
% 080618 MHH Created

function corr_data = norm_xcorr2d(data1,data2)
f1 = fft2(data1-mean(mean(data1)));
f2 = fft2(data2-mean(mean(data2)));

unnorm = fftshift(ifft2((((f2.*conj(f1))))));
norm = real(ifft2(f1.*conj(f1))).*real(ifft2(f2.*conj(f2)));

corr_data = unnorm/sqrt(norm(1,1));
%corr_data = unnorm;
%img_plot2(corr_data,'gray'); colormap(gray); 
% [x y] = find (corr_data == max(max(corr_data)))
% hold on;
% plot(y,x,'bo');
% hold on; plot(64.5,45,'rx');
% x
% y
end


