function comfeat = fetese_combine_feat(feat1,feat2,topo1c)

comfeat.pos = [feat1.pos, feat2.pos];
comfeat.fitx = [feat1.fitx, feat2.fitx];
comfeat.fity = [feat1.fity, feat2.fity];
comfeat.fitresults = {feat1.fitresults, feat2.fitresutls};
comfeat.sigmax = [feat1.sigmax, feat2.sigmax];
comfeat.sigmay = [feat1.sigmay, feat2.sigmay];
comfeat.sigmaall = [comfeat.sigmax, comfeat.sigmay];
% also calculate the mean and the stdev of the ffeat size
comfeat.msigmax = mean(comfeat.sigmax);
comfeat.msigmay = mean(comfeat.sigmay);
comfeat.msigmaall = mean(comfeat.sigmaall);
comfeat.stdsigx = std(comfeat.sigmax);
comfeat.stdsigy = std(comfeat.sigmay);
comfeat.stdsigall = std(comfeat.sigmaall);
comfeat.fmask = {feat1.fmask, feat2.fmask};
comfeat.perimeter = {feat1.fperimeter, feat2.fperimeter};




nof = length(comfeat.fitx);
img_plot3(topo1c)
hold on
for i=1:nof
    
    
    %%
    
    dum1 = comfeat.perimeter{i};
    dum2 = dum1{1};
    xxx = dum2(:,2);
    yyy = dum2(:,1);
    plot(xxx,yyy,'-','Color','r','LineWidth',2);
    % line is needed to close the region
    line([xxx(end),xxx(1)],[yyy(end),yyy(1)],'Color','r','LineStyle','-','LineWidth',2);
    
    dum3 = comfeat.fmask{i};
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

comfeat.complmask = complmask;
img_plot3(complmask);


end