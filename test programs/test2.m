% matr = zeros(100,100);
% for j = 1:50
%     matr(j,:) =1;
% end
% figure; pcolor(matr); shading interp;
% 
% % for k = 1:sz
% %     avg_power(:,:,k) = (avg_power(:,:,k) + avg_power(:,:,k)')/2;
% % end
% % 
% 
% matr = (matr + matr')/2;
% figure; pcolor(matr'); shading interp;
%  for i=1:50
%       matr(i,:) = (matr(i,:) + matr(100 + 1 - i,:))/2;
%       matr(100 + 1 -i,:) = matr(i,:);
%   end
% figure; pcolor(matr); shading interp;
gridpt = linspace(-3,3,256);
[x,y] = meshgrid(gridpt);
sig = 0.004;
% x1 = 2.1525; y1 = 2.2128;
% x2 = -1.9917; y2 = 2.1666;
% x3 = -2.0863; y3 = -2.2128;
% x4 = 2.0485; y4 = -2.1666;
x1 = 0.5; y1=0.5;
x2 = -0.5; y2 = 0.5;
x3 = -0.5; y3 = -0.5;
x4 = 0.5; y4 = -0.5;
%norm = 1 / (sqrt(2*pi*sig))^2;
zz = 0.5*(exp(-(x-x1).^2/sig - (y-y1).^2/sig))+ exp(-(x-x2).^2/sig - (y-y2).^2/sig) +...
0.5*(exp(-(x-x3).^2/sig - (y-y3).^2/sig)) + exp(-(x-x4).^2/sig - (y-y4).^2/sig);
figure;mesh(x,y,zz);

%ideal = exp(-(x-A0(1)).^2/sig - (y-A0(2)).^2/sig) + exp(-(x-B0(1)).^2/sig - (y-B0(2)).^2/sig) +...
%exp(-(x+A0(1)).^2/sig - (y+A0(2)).^2/sig) + exp(-(x+B0(1)).^2/sig - (y+B0(2)).^2/sig);

ideal = 0.75*(exp(-(x-0.5).^2/sig - (y-0.5).^2/sig) + exp(-(x+0.5).^2/sig - (y-0.5).^2/sig) +...
exp(-(x+0.5).^2/sig - (y+0.5).^2/sig) + exp(-(x-0.5).^2/sig - (y+0.5).^2/sig));
% xoned = -3:0.03:3;
% oned = exp(-(xoned-0.5).^2/sig);
% figure;plot(xoned,oned);
