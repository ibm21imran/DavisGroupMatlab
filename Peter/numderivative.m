function [yprime, xprime]=numderivative(y,x)

% c = 1;
% for i=2:length(y)-1
%     
%     yprime(c) = ( y(i+1) - y(i-1)) / ( x(i+1) - x(i-1) ); 
%     xprime(c) = x(i);
%     c = c+1;
%     
% end
% 
% figure, plot(xprime, yprime)

yplus = [0 0 y];
yminus = [y 0 0];
yprime = (yminus - yplus)/(2*(x(2)-x(1)));
yprime = yprime(3:end-2);
xprime = x(2:length(y)-1);



end