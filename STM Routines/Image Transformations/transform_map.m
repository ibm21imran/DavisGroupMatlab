function transform = transform_map(map,coord,A1,B1,A0,B0)

M = [A1(1) A1(2)    0     0
       0      0    A1(1) A1(2) 
     B1(1) B1(2)    0     0
       0      0    B1(1) B1(2)];

b = [A0(1); A0(2); B0(1); B0(2)];

X = inv(M)*b;

xform2 = [X(1)   X(2)   0
          X(3)   X(4)   0
           0      0     1];
%  det(xform2)
%xform = xform2;
     
shearing = maketform('affine',xform2');
%[G xdata ydata]= imtransform(G4KMap(:,:,11),shearing);
transform = imtransform(map, shearing,... 
                        'UData',[coord(1) coord(end)],...
                        'VData', [coord(1) coord(end)],...
                        'XData',[coord(1) coord(end)],...
                        'YData', [coord(1) coord(end)],...
                        'size',size(map));
[xm,ym] = tformfwd(shearing, [A1(1) B1(1)], [A1(2) B1(2)]);
% tform = maketform('projective',[ A1(1) A1(2);  B1(1)  B1(2)],...
%                                [A0(1) A0(2); B0(1) B0(2)]);
% [transform,xdata,ydata] = imtransform(map, tform, 'bicubic', ...
%                               'UData',[coord(1) coord(end)],...
%                          'VData', [coord(1) coord(end)],...
%                          'XData',[coord(1) coord(end)],...
%                          'YData', [coord(1) coord(end)]);
                    
end
%pcolor(G); shading interp;
%G = G(1:256,1:256);