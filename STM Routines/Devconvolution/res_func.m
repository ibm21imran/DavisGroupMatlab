function y = res_func(x,VA,x0)

%y = real((VA^2 - (x0 - x).^2).^0.5);
%y = zeros(1,length(x));
y = double(x > -VA+x0 & x < VA+x0);

end
