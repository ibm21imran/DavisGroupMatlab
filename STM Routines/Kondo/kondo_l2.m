function y = kondo_l2(x,a,b,e0,l,V)

% l = 0.7414;
% V = 1;
% a= 1;
% b = 0.5;
% e0 = -1;

n = 4;
y = (a^2*(x-b).^n + e0 + l)/2 - (((a^2*(x-b).^n + e0 - l).^2 + V^2).^0.5)/2;
end

%a=10, V=5 looks good
 %-95.5076   10.3015    0.7414    4.0082