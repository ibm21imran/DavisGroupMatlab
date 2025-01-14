% shearing script
%%
T = G1;
T.map = fano.e;
T.e = 1;
%%

F1 = fourier_block3(poly_detrend2(T,0),'','full','ft');

%%
figure; pcolor(F1.r, F1.r,real(F1.map(:,:,1))); shading flat; colormap(Defect1); axis equal;
%%

F2 = rotate_map2(F1,0);
%%
transform = F2;
tform = maketform('affine',[1 -0.36 0; 0 1 0; 0 0 1]);
transform.map = imtransform(F2.map, tform,'bicubic',... 
                        'UData',[F2.r(1) F2.r(end)],...
                        'VData', [F2.r(1) F2.r(end)],...
                        'XData',[F2.r(1) F2.r(end)],...
                        'YData', [F2.r(1) F2.r(end)],...
                        'size', size(F2.map));          
F3 = transform;
figure; pcolor(F3.r, F3.r,real(F3.map(:,:,1))); shading flat; colormap(Defect1); axis equal;
clear transform tform;
%%
[nr nc nz] = size(F3.map);
filt = Gaussian(1:nr,1:nc,25,[nr/2+1 nc/2+1],1);
figure; pcolor(filt); shading flat; axis equal; colormap(Defect1)
figure; pcolor(real(filt.*F3.map)); shading flat; colormap(Defect1); axis equal;
clear nr nc nz;
%%
F4 = F3;
%filt = 1;
F4.map = ifftshift(filt.*F3.map);
%figure; pcolor(F4.r, F4.r,real(F4.map(:,:,1))); shading flat; colormap(Defect1); axis equal;
%view6(F4);
Tnew = fourier_block3(F4,'','full','ift');
%view6(Tnew)
%%
figure; pcolor(Tnew.r, Tnew.r,real(Tnew.map(:,:,1))); shading flat; colormap(Blue2); axis equal; axis off;
figure; pcolor(T.r, T.r,real(T.map(:,:,1))); shading flat; colormap(Blue2); axis equal; axis off;
%%
T2 = G1;
T2.map = z;
T2.e = 1;
transform2 = T2;
tform2 = maketform('affine',[1 0 0; 0.35 1 0; 0 0 1]);
transform2.map = imtransform(T2.map, tform2,'bicubic',... 
                        'UData',[T2.r(1) T2.r(end)],...
                        'VData', [T2.r(1) T2.r(end)],...
                        'XData',[T2.r(1) T2.r(end)],...
                        'YData', [T2.r(1) T2.r(end)],...
                        'size', size(T2.map));          
T2new = transform2;
figure; pcolor(T2new.r, T2new.r,real(T2new.map(:,:,1))); shading flat; colormap(Defect1); axis equal;
clear transform2 tform2;