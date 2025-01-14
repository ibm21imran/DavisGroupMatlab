%Create Fake Lattice

function [atom,driftxx,driftyy] = create_lattice
%cmap = open('C:\MATLAB\ColorMap\IDL_Colormap2.mat');
cmap = open('C:\Analysis Code\MATLAB\ColorMap\IDL_Colormap3.mat');
%Number of atoms + Pixels
% numberx=input('Lattice Size = ');
numberx = 25;
numbery=numberx;
nrpxl=numberx*10;
delta=1/numberx;
sigma = 1/((numberx^2)*10);


%Set up Lattice
x=linspace(0,1,nrpxl);
y=x;
[xx,yy]=ndgrid(x,y);
atom.map=zeros(nrpxl);

%Create Drift Terms

driftx=1:numberx+10;
driftx=driftx.^2/((numberx+10)^2);
driftxx = zeros(numberx);

drifty=1:numberx+10;
drifty=(-drifty.^2+drifty.^4/((numberx)^2))/(((numberx)^3)/10);
driftyy = zeros(numbery);
%Create Atoms
nx = 0.2; ny = 0;
for j=-1:numberx+5
    for k=-1:numbery+5
       atom.map= atom.map+exp(-((xx-j*delta - nx*driftx(j+2)).^2+(yy-k*delta-ny*drifty(j+2)).^2)/(2*sigma));
       driftxx(j+2,k+2) = driftx(j+2);
       driftyy(j+2,k+2) = drifty(j+2);
    end
end

figure;
pcolor(atom.map)
shading flat

atom.r = (linspace(0,numberx,nrpxl))';

% f=fft2(atom.map-mean(atom.map(:)));
% f=fftshift(f);
% f=abs(f);
% figure;
% % pcolor(f);
% shading flat
% colorbar
% colormap(cmap.Defect1);
% caxis([0 1e4])

end


