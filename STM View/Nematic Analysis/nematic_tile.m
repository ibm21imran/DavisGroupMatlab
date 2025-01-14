function new_img = nematic_tile(img,pixels)
n = pixels;
[nr nc nz] = size(img);
new_img = zeros(nr,nc,nz);

for k = 1:nz
    [r c] = find(img(:,:,k) ~= 0);
    for i = 1:length(r)
        if (r(i) - n >=1 && r(i) + n <= nr && c(i) - n >= 1 && c(i)+n <= nc)
            new_img(r(i)-n:r(i)+n,c(i)-n:c(i)+n,k) = img(r(i),c(i),k);
        end
    end
end
    

