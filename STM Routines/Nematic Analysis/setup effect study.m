%% checking for setup effect by looking for pixels which are different
% across the chemical potential

INR_pos = INR3.map(:,:,21);
INR_neg = INR3.map(:,:,36);
img_plot2(INR_pos, Cmap.PurBlaCop,'INR Pos');
img_plot2(INR_neg, Cmap.PurBlaCop,'INR Neg');
%%
INR_pos_sgn = sign(INR_pos);
INR_neg_sgn = sign(INR_neg);
img_plot2(-1*INR_pos_sgn, Cmap.PurBlaCop,'INR Pos sign');
img_plot2(-1*INR_neg_sgn, Cmap.PurBlaCop,'INR Neg sign');
%%
count = 1;
for i = 1:360
    for j= 1:360;
        if (INR_pos_sgn(i,j) ~= INR_neg_sgn(i,j))            
            r(count) = i; c(count)= j;
            INR_pos_values(count) = INR_pos(i,j);
            INR_neg_values(count) = INR_neg(i,j);
            count = count + 1;
        end
    end
end