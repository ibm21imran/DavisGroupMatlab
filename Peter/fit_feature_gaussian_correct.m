function ffeatc = fit_feature_gaussian_correct(ffeat,topo1c,data1,cox,coy)
% ffeat - struct containing data about the fit
% dtmap -   map that can be used for the vortex
% search, for the pristine sample they are not needed
% topo1c - topograph
% data1 - raw data struct 
% cox, coy - pixel cutoff for x and y direction of maps


% energy vector "ev", and number of energies "nel"
ev = data1.e;
nel = length(ev);

[nx, ny, ne] = size(topo1c);
dummap = zeros(nx, ny,ne);
% apply a possible crop to map 
dummap(1+cox:end-cox,1+coy:end-coy,:) = topo1c(1+cox:end-cox,1+coy:end-coy,:);

dtmap = dummap;
% get the physical dimensions of the map
[nx, ny, ne] = size(dtmap);

% filter the map with an averaging filter to get rid of noise spikes in the
% intensity, so that when you look for maximum intensity you find better
% candidates for features interested in, but use unfiltered data for fit
% h = fspecial('average',[3,3]);
% msmap = imfilter(dtmap,h,'replicate');
msmap = dtmap;
msmapraw = msmap;

dtmap = msmap;

% plot the map used for the ffeat search
% figure, img_plot4(dtmap);
% figure, img_plot4(msmap);
img_plot3(dtmap);
img_plot3(msmap);



        

%% Save the fit x- and y-coordinates
nof = length(ffeat.perimeter);

ffeatc = ffeat;



ffeatc.sigmaall = [ffeat.sigmax,ffeat.sigmay];
% also calculate the mean and the stdev of the ffeat size

ffeatc.msigmaall = mean(ffeatc.sigmaall);

ffeatc.stdsigall = std(ffeatc.sigmaall);



for i=1:length(ffeat.fitx)

    

%% Fit the vortices to two-dimensional Gaussians


    
    dumfit = ffeat.fitresults{i};

    
    % calculate the x and y position with respect to the map
    dumfitx = ffeat.fitx(i);
    dumfity =ffeat.fity(i);   
    
    
    % subtract the finalfit from the ffeat search map to move on to the next one
    [X,Y]=meshgrid(1:1:ny,1:1:nx);
    xdata(:,:,1)=X;
    xdata(:,:,2)=Y;
    x = [dumfit(1),dumfitx,dumfit(3),dumfity,dumfit(5),dumfit(6),dumfit(7)];
    finalfit=twodgauss(x,xdata);
%     img_plot3(finalfit);
   

    msmap = msmap - finalfit;
    
    cm(:,:,i) = uint8(twodgauss(x,xdata) >= x(1)/exp(1) + x(6));
    dum0 = double(cm(:,:,i));
%             img_plot3(dum0);
    ffeatc.fmask{i} = dum0;
    ffeatc.fperimeter{i} = bwboundaries(dum0);

    
    close all;
end



img_plot3(topo1c)
hold on
for i=1:nof
    
    
    %%
    
    dum1 = ffeatc.perimeter{i};
    dum2 = dum1{1};
    xxx = dum2(:,2);
    yyy = dum2(:,1);
    plot(xxx,yyy,'-','Color','r','LineWidth',2);
    % line is needed to close the region
    line([xxx(end),xxx(1)],[yyy(end),yyy(1)],'Color','r','LineStyle','-','LineWidth',2);
    
    dum3 = ffeatc.fmask{i};
    if i == 1
        complmask = dum3;
    else
        complmask = complmask + dum3;
    end
%     line([fitx(i),fitx(i)],[fity(i)-1,fity(i)+1],'Linewidth',2,'Color','m');
%     line([fitx(i)-1,fitx(i)+1],[fity(i),fity(i)],'Linewidth',2, 'Color','m');
end
hold off

[nx, ny, ne] = size(complmask);
for i=1:nx
    for j=1:ny
        if complmask(i,j,1) > 0
            complmask(i,j,1) = 1;
        end
    end
end

ffeatc.complmask = complmask;
img_plot3(complmask);
img_plot3(msmap);
end