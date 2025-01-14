function [O,R,lambda]=vortex_coherence_length(data,angle,ave,radius,posx,posy,isize,pxl)
%% Inspired by Andrey's polar_average function this takes the polar average
%% of the conductance map around a vortex (center specified by posx and
%% posy). "Angle" is the start value, e.g. 0, and "ave" is the average
%% value for the angle (how far it goes, e.g. 360 is all the way around).
%% Data is the map and radius determines the radius of the polar average in
%% pxl."isize" is the image size (75nm e.g., 750 Angstroem, etc) and "pxl" is
%% the image size in pxl. It is used to calculate "lambda" the coherence
%% length from the fit.

load_color;

if isstruct(data)==1
    map = data.map;
else
    map = data;
end

[nx ny nz] = size(map);

N = radius;
theta = linspace(2*pi*(angle-ave/2)/360,2*pi*(angle+ave/2)/360,100);
% R = 1:N;
R = 0:N;
% O = zeros(N,nz);
O = zeros(N+1,nz);

for i=1:nz
    for j=1:length(R)
        sum = 0;
        count = 0;
        for k=1:length(theta)
            x = posx+round(R(j)*cos(theta(k)));
            y = posy-round(R(j)*sin(theta(k)));
            if((x>=1)&&(x<=nx)&&(y<=ny)&&(y>=1))
              sum=sum+map(y,x,i);
              count = count + 1;
            end
        end
        O(j,i)=sum/count;
    end
end

% figure
% hold on
% 
% for i=1:nz
% plot(R,O(:,i),'.')
% end
% 
% hold off
% 
%zlayer = zero energy layer
for j = 1:length(data.e)
    if data.e(j) == 0
        zlayer = j;
    end
end
% figure;
% semilogy(R,O(:,zlayer),'.')


%% Fit with exponential to get the coherence length
guess=[1, 5, 0.01,O(end,zlayer)];

[y_new, p]=coherence_fit(O(:,zlayer),R,guess,0)
coeffvals = coeffvalues(p)
ci = confint(p)
lambda=p.b*isize/pxl;

% figure;
img_plot2(map(:,:,zlayer),Cmap.Blue2)
hold on
rectangle('Position',[posx-N,posy-N,2*N,2*N],'Curvature',[1,1],'Linewidth',2,'Edgecolor','r')


end