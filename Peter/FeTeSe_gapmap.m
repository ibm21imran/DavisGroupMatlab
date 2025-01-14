function [gmap, gmapinp, valarra]=FeTeSe_gapmap(data, offset)
%% Extract the gap (in various ways) from a spectroscopic map for each 
%% individual pixel.


%% From Matlab, different methods for interpolation: PCHIP vs SPLINE
        % pchip is local. The behavior of pchip on a particular subinterval
        % is determined by only four points, the two data points on either
        % side of that interval. pchip is unaware of the data farther away.
        % spline is global. The behavior of spline on a particular sub-
        % interval is determined by all of the data, although the sensiti-
        % vity to data far away is less than to nearby data. Both behaviors
        % have their advantages and disadvantages.
%% 
        
% "map" is the spectroscopic map
map = data.map;
% "en" is the vector containing the energies of the spectra
en = data.e';
% correct for an offset if necessary
if isempty(offset)==1
else
    en = en + offset;
end
% "asp" is the average spectrum of the map
asp = data.ave';
% get the dimensions of the map: "nx" and "ny" being the spatial size in
% pixel; "nz" the number of energy layers
[nx ny nz]=size(map);
% "gmap" is an empty matrix which will be filled consecutively
gmap=zeros(nx,ny,1);
gmapinp=zeros(nx,ny,1);
% "enstr" is the energy vector converted to an array of characters
enstr=num2str(en');
% "eninp" is an energy vector with finer intervals (created artificially)
eninp = linspace(en(1),en(nz),nz*10);
% "aspi" is the interpolated average spectrum with the finer energy
% intervals of "eninp"
aspi = interp1(en,asp,eninp,'pchip');

avegapvalues=FeTeSe_gapvalues(asp, en);
avegapvaluesinp=FeTeSe_gapvalues(aspi, eninp);

agw = trapz(asp(avegapvalues.ssbind+1:avegapvalues.ssaind+1))/trapz(asp(1:end))*100;
agwinp = trapz(aspi(avegapvaluesinp.ssbind+1:avegapvaluesinp.ssaind+1))/trapz(aspi(1:end))*100;


% figure, plot(en,asp,'k.',en(avegapvalues.cpbind),asp(avegapvalues.cpbind),'ro',...
%     en(avegapvalues.cpaind),asp(avegapvalues.cpaind),'ro',...
%     en(avegapvalues.ssbind+1),asp(avegapvalues.ssbind+1),'bo',...
%     en(avegapvalues.ssaind+1),asp(avegapvalues.ssaind+1),'bo',...
%     en(avegapvalues.cmind),asp(avegapvalues.cmind),'go','LineWidth',2,'MarkerSize',12)
% 
% figure, plot(eninp,aspi,'k.',eninp(avegapvaluesinp.cpbind),aspi(avegapvaluesinp.cpbind),'ro',...
%     eninp(avegapvaluesinp.cpaind),aspi(avegapvaluesinp.cpaind),'ro',...
%     eninp(avegapvaluesinp.ssbind+1),aspi(avegapvaluesinp.ssbind+1),'bo',...
%     eninp(avegapvaluesinp.ssaind+1),aspi(avegapvaluesinp.ssaind+1),'bo',...
%     eninp(avegapvaluesinp.cmind),aspi(avegapvaluesinp.cmind),'go','LineWidth',2,'MarkerSize',12)

close all;
%% Iniate arrays to store all computed gapmap values
c = 1;
valarra.cmspec = zeros(nx * ny,1);
valarra.cpb = zeros(nx * ny,1);
valarra.cpa = zeros(nx * ny,1);
valarra.cpmean = zeros(nx * ny,1);
valarra.ssb = zeros(nx * ny,1);
valarra.ssa = zeros(nx * ny,1);
valarra.ssmean = zeros(nx * ny,1);
valarra.cohdiff = zeros(nx * ny,1);
valarra.gapweight = zeros(nx * ny,1);
valarra.cmspecinp = zeros(nx * ny,1);
valarra.cpbinp = zeros(nx * ny,1);
valarra.cpainp = zeros(nx * ny,1);
valarra.cpmeaninp =zeros(nx * ny,1);
valarra.ssbinp = zeros(nx * ny,1);
valarra.ssainp = zeros(nx * ny,1);
valarra.ssmeaninp = zeros(nx * ny,1);
valarra.cohdiffinp = zeros(nx * ny,1);
valarra.gapweightinp = zeros(nx * ny,1);

testlayer = zeros(nx,ny,1);
%% Two for loops to go through the map, pixel by pixel
for i=1:nx
    for j=1:ny
        % load the spectrum of the coordinate (i,j)
        sp(1:nz) = map(i,j,:);
        testlayer(i,j,1) = map(i,j,1);
        % calculate the interpolated spectrum using a spline
        spi = interp1(en,sp,eninp,'pchip');
        % calculate the gapvalues for the raw and the interpolated spectrum
        rawgapvalues=FeTeSe_gapvalues(sp, en);
        inpgapvalues=FeTeSe_gapvalues(spi, eninp);
             
        valarra.cohdiff(c) = sp(rawgapvalues.cpaind) - mean(sp(end-2 : end)) - sp(rawgapvalues.cpbind) + mean(sp(1:3));
        valarra.cohdiffinp(c) = spi(inpgapvalues.cpaind) - mean(spi(end-29 : end)) - spi(inpgapvalues.cpbind) + mean(spi(1:30));
        
        gmap(i,j,1) = ( rawgapvalues.cpb );
        gmap(i,j,2) = ( rawgapvalues.cpa );
        gmap(i,j,3) = mean( [abs(gmap(i,j,1)), abs(gmap(i,j,2))] );
        gmap(i,j,4) = ( rawgapvalues.ssb );
        gmap(i,j,5) = ( rawgapvalues.ssa );
        gmap(i,j,6) = mean( [abs(gmap(i,j,4)), abs(gmap(i,j,5))] );
        gmap(i,j,7) = valarra.cohdiff(c);
        % plus 1 in the indices because of smaller energy vectors after taking the
        % derivative
        gmap(i,j,8) = trapz(sp(rawgapvalues.ssbind+1:rawgapvalues.ssaind+1))/trapz(sp(1:end))*100 - agw;
        
        valarra.cmspec(c) = rawgapvalues.cmspec;
        valarra.cpb(c) = gmap(i,j,1);
        valarra.cpa(c) = gmap(i,j,2);
        valarra.cpmean(c) = gmap(i,j,3);
        valarra.ssb(c) = gmap(i,j,4);
        valarra.ssa(c) = gmap(i,j,5);
        valarra.ssmean(c) = gmap(i,j,6);
        valarra.gapweight(c) = gmap(i,j,8);
        
        gmapinp(i,j,1) = ( inpgapvalues.cpb );
        gmapinp(i,j,2) = ( inpgapvalues.cpa );
        gmapinp(i,j,3) = mean( [abs(gmapinp(i,j,1)), abs(gmapinp(i,j,2))] );
        gmapinp(i,j,4) = ( inpgapvalues.ssb );
        gmapinp(i,j,5) = ( inpgapvalues.ssa );
        gmapinp(i,j,6) = mean( [abs(gmapinp(i,j,4)), abs(gmapinp(i,j,5))] );
        gmapinp(i,j,7) = valarra.cohdiffinp(c);
        % plus 1 in the indices because of smaller energy vectors after taking the
        % derivative
        gmapinp(i,j,8) = trapz(spi(inpgapvalues.ssbind+1:inpgapvalues.ssaind+1))/trapz(spi(1:end))*100 - agwinp;
        
        valarra.cmspecinp(c) = inpgapvalues.cmspec;
        valarra.cpbinp(c) = gmapinp(i,j,1);
        valarra.cpainp(c) = gmapinp(i,j,2);
        valarra.cpmeaninp(c) = gmapinp(i,j,3);
        valarra.ssbinp(c) = gmapinp(i,j,4);
        valarra.ssainp(c) = gmapinp(i,j,5);
        valarra.ssmeaninp(c) = gmapinp(i,j,6);
        valarra.gapweightinp(c) = gmapinp(i,j,8);
        
%         figure, plot(en,sp,'k.',en(rawgapvalues.cpbind),sp(rawgapvalues.cpbind),'ro',...
%         en(rawgapvalues.cpaind),sp(rawgapvalues.cpaind),'ro',...
%         en(rawgapvalues.ssbind+1),sp(rawgapvalues.ssbind+1),'bo',...
%         en(rawgapvalues.ssaind+1),sp(rawgapvalues.ssaind+1),'bo',...
%         en(rawgapvalues.cmind),sp(rawgapvalues.cmind),'go','LineWidth',2,'MarkerSize',12)
% 
%         figure, plot(eninp,spi,'k.',eninp(inpgapvalues.cpbind),spi(inpgapvalues.cpbind),'ro',...
%         eninp(inpgapvalues.cpaind),spi(inpgapvalues.cpaind),'ro',...
%         eninp(inpgapvalues.ssbind+1),spi(inpgapvalues.ssbind+1),'bo',...
%         eninp(inpgapvalues.ssaind+1),spi(inpgapvalues.ssaind+1),'bo',...
%         eninp(inpgapvalues.cmind),spi(inpgapvalues.cmind),'go','LineWidth',2,'MarkerSize',12)
        
        close all;
        c = c+1;
        i
        j
    end
end

figure, imagesc(testlayer), axis image
% figure, imagesc(gmap)









end







%% If I ever want to fit anything: Rough estimates for 1st guess, upper and
%% lower bounds
% aspl=asp(1:round(nz/2));
% enl=en(1:round(nz/2));
% [Cl,Il]=max(aspl);
% guessl=[Cl abs(enl(Il)-enl(end)) enl(Il) 0 aspl(1)];
% lowl = [0 abs(enl(1)-enl(2)) enl(1) 0 0];
% uppl = [max(max(max(map(:,:,1:round(nz/2)))))...
%     abs(enl(Il)-enl(end)) enl(end) aspl(1)-aspl(end)...
%     max(max(max(map(:,:,1:round(nz/2)))))];
% 
% aspr=asp(round(nz/2):end);
% enr=en(round(nz/2):end);
% [Cr,Ir]=max(aspr);
% guessr=[Cr abs(enr(Ir)-enr(1)) enr(Ir) 0 aspr(end)];
% lowr = [0 abs(enr(1)-enr(2)) enr(1) 0 0];
% uppr = [max(max(max(map(:,:,round(nz/2):end))))...
%     abs(enr(Ir)-enr(1)) enr(end) aspr(end)-aspr(1)...
%     max(max(max(map(:,:,round(nz/2):end))))];
%         
%%
%         imspectrum=spectrum(1:round(nz/2));
%         imen=en(1:round(nz/2));
%         
%         [C,I]=max(imspectrum);
%         guess=[C abs(imen(1)-imen(3)) imen(I) imspectrum(1)];
%         low = [0 0 imen(1) 0];
%         upp = [guess(1)*1.5 abs(imen(I)-imen(end)) imen(end) C];
%         [y_new1, p1,gof1]=FeTeSe_gapmap_fit(imspectrum,imen,guessl,lowl,uppl);
        
%         imspectrum=yi(1:round(length(eninp)/2));
%         imen=eninp(1:round(length(eninp)/2));
        
%         [C,I]=max(imspectrum);
%         guess=[C abs(imen(1)-imen(7)) imen(I) imspectrum(1)];
%         low = [0 0 imen(1) 0];
%         upp = [guess(1)*1.5 abs(imen(I)-imen(end)) imen(end) C];
%         [y_new2, p2,gof2]=FeTeSe_gapmap_fit(imspectrum,imen,guess,low,upp);
%         
%         imspectrum=spectrum(round(nz/2):end);
%         imen=en(round(nz/2):end);
%         
%         [C,I]=max(imspectrum);
%         guess=[C abs(imen(1)-imen(3)) imen(I) imspectrum(end)];
%         low = [0 0 imen(1) 0];
%         upp = [guess(1)*1.5 abs(imen(I)-imen(1)) imen(end) C];
%         [y_new3, p3,gof3]=FeTeSe_gapmap_fit(imspectrum,imen,guessr,lowr,uppr);
        
%         imspectrum=yi(round(length(eninp)/2):end);
%         imen=eninp(round(length(eninp)/2):end);
%         
%         [C,I]=max(imspectrum);
%         guess=[C abs(imen(1)-imen(7)) imen(I) imspectrum(end)];
%         low = [0 0 imen(1) 0];
%         upp = [guess(1)*1.5 abs(imen(I)-imen(1)) imen(end) C];
%         [y_new4,
%         p4,gof4]=FeTeSe_gapmap_fit(imspectrum,imen,guess,low,upp);