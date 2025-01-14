%% find the gap minimum
b1 = 19; b2= 36; %09227A13
%b1 = 43; b2 = 56; %090430A02
xtmp = G.e(b1:b2)*1000;
[nr nc nz] = size(G.map);
bottom = zeros(nr,nc);
for i = 1:nr    
    for j = 1:nc
         ytmp = squeeze(squeeze(G.map(i,j,b1:b2)));
         tmp = xtmp(ytmp == min(ytmp));
         bottom(i,j) = tmp(1);                  
    end
end

% if the values for the gap minimum are too far from the mean, then revisit
% them and employ a peak finding algorithm to revise the estimate

bottom2 = bottom;
std_bottom = std(reshape(bottom,nr*nc,1));
mean_bottom = mean(mean(bottom));
[r_bot c_bot] = find(bottom <= mean_bottom - 2*std_bottom);
ind = length(c_bot);
count = 0;
for n = 1:ind        
    ytmp = squeeze(squeeze(G.map(r_bot(n),c_bot(n),b1:b2)));
    new_peak = findpeaks(xtmp,max(ytmp) - ytmp, 0.014,1,1,3);
    if new_peak(1,2) ~= bottom(r_bot(n),c_bot(n))
        count = count + 1;
    end
    bottom2(r_bot(n),c_bot(n)) = new_peak(1,2);
end
%%
img_plot2(bottom2,Cmap.Defect1,'gap minimum: inter 2');
clear new_peak ind mean_bottom std_bottom tmp xtmp ytmp n nr nc nz b1 b2 i j r_bot c_bot bottom count
%% find bottom index

% by looking to the left of the gap minimum find the first real peak

[nr nc nz] = size(G.map);
xtmp = G.e*1000;
bottom_index = zeros(nr,nc);
for i = 1:nr
    for j = 1:nc
        bottom_index(i,j) = find(bottom2(i,j) == xtmp);
    end
end
clear xtmpi j
%% find right edge
G_data = G;
[nr nc nz] = size(G_data.map);
%pt1 = 27; pt2 = 50;
%nr = 1; nc = 1;
%load_color;
xtmp = G_data.e*1000;
res = 0.001;
%xfine = x(pt1):res:x(pt2);
%xfine = x;
right_edge = zeros(nr, nc);
for i = 1:nr
    i
    for j = 1:nc
        pt1 = bottom_index(i,j) + 4 ; pt2 =  min(pt1 + 23,nz);
        %pt1 = bottom_index(i,j) ; pt2 =  min(pt1 + 23,nz);
        ytmp =  squeeze(squeeze(G_data.map(i,j,:))); ytmp = ytmp';   
        %y = G_data.ave; y = y';
        %y = squeeze(squeeze(G_data.map(1,200,:))); y = y';
        [p,S]= polyfit(xtmp(pt1:pt2),ytmp(pt1:pt2),5);                
        xfine = xtmp(pt1):res:xtmp(pt2);
        y2 = polyval(p,xfine);        
        [dy2 x2] = num_der2b(2,y2,xfine);                
        
        x0 = x2(dy2 == min(dy2(1000:5000)));
        
        right_edge(i,j) = x0(1);
        %figure; plot(x,y); hold on; plot(xfine,y2,'r'); hold on; plot([x0 x0],get(gca,'ylim'));% xlim([2 8]);
        %figure; plot(x2,dy2,'g'); hold on; plot([x0 x0], get(gca,'ylim'));
        
    end
end
%%
img_plot2(right_edge_a,Cmap.Defect1,'right_edge');
caxis([2 7]);
%%
%% gap correlation with conductance map
[nr nc nz] = size(G.map);
gap_min_corr = zeros(nz,1);
for k = 1:nz
    gap_min_corr(k) = corr2(right_edge,G.map(:,:,k));
end
figure; plot(G.e*1000,abs(gap_min_corr));
clear nr nc nz k;

%%
fano2 = gauss_filter_image(right_edge_a(1:150,1:150),20,20);
FT_right = fourier_transform2d(fano2 - mean(mean(fano2)),'sine','','');
img_plot2(FT_right,Cmap.Defect1,['right edge - pt1 = ' num2str(pt1) ' pt2 = ' num2str(pt2)])
caxis([20 220]);
%%
FT_sym_gap = symmetrize_image(linear2D_image_correct([1.93 -2.16],[-2.01 -1.97],FT_right,FT_T.r),'d','v');
%FT_sym_right = symmetrize_image(linear2D_image_correct([1.93 -2.16],[-2.01 -1.97],FT_right,FT_T.r),'d','v');
img_plot2(symmetrize_image(linear2D_image_correct([1.93 -2.16],[-2.01 -1.97],FT_right,FT_T.r),'d','v'),Cmap.Defect1,['right edge - pt1 = ' num2str(pt1) ' pt2 = ' num2str(pt2)]);
caxis([30 150])
%%
Bragg_x = [232 25 26 234];
Bragg_y = [24 27 234 234];

%Bragg_x = [228 25 30 233]; %09227A13
%Bragg_y = [241 231 17 27];
hold on; plot(Bragg_x,Bragg_y,'ro','MarkerFaceColor',[1 0 0],...
                'MarkerSize',7); axis equal; 
%%
x = -6:0.1:10;
q = -0.4;
w = 0.25;
e = 1;
a = 25;
b = 0.6;
c= -0.04;
d = 0.01;
z = 8;
g = 2;
y = z*(q + (x-e)/g).^2./(w + ((x-e)/g).^2) + a + b*x + c*x.^2 + d*x.^3;
figure; plot(x,y);
x = G.e*1000; y = G.ave;
x = x(1:end); y = y(1:end);
hold on; plot(x,y,'r');
%%
fano_line = 'z*((x - e)/g + q)^2/(w + ((x - e)/g)^2) + d*x^3 + c*x^2 + b*x + a';

    s = fitoptions('Method','NonlinearLeastSquares',...
        'Startpoint',[25 0.6 -0.05 0.01 1 5 -0.4 0.25 8],...
        'Algorithm','Levenberg-Marquardt',...
        'TolX',1e-7,...
        'MaxIter',5000,...
        'MaxFunEvals', 5000);

f = fittype(fano_line,'options',s);
[p,gof] = fit(x',y,f);
param = p;
%%
a = p.a; b = p.b; c = p.c; d = p.d; e = p.e; g = p.g; q = p.q; w = p.w; z =p.z;
%%
f = z*((x - e)/g + q).^2./(w + ((x - e)/g).^2) + d*x.^3 + c*x.^2 + b*x + a;
figure; plot(x,f); hold on; plot(x,y,'r');
figure; plot(x, d*x.^3 + c*x.^2 + b*x + a);
figure; plot(x,z*((x - e)/g + q).^2./(w + ((x - e)/g).^2));
%%
bkg = polyval(fit19K.coeff,x);
figure;plot(x,bkg - (mean(bkg)-mean(y)));
%hold; plot(x,y,'r')
figure; plot(x,y'- (bkg - (mean(bkg)-mean(y))))
%%
%figure; plot(ac_g(128,100:156));
figure;  plot(y_ac);
%ys = 5000*sin(1.15*(xs + 4)).*exp(-0.05*(xs-29)) + 6000;
ys = 5000*abs(sin(0.526*(xs + 3.85))) + 3200;
hold on; plot(xs,ys,'r');
ylim([0 20018]); xlim([0,59]);
%%
yb = besselj(0,xs);
figure; plot(xs,yb);