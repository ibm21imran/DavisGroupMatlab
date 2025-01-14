function movie1 = exp_movie(map,energy,rx,ry,directory,filename,clmap,clbnd,frps,quality)
% XXX arpes movie maker
% XXX makes movie from one matrix block

f1=figure('Position',[100,100,450,450]);
set(f1,'Color',[0 0 0])

%main_axis = axes('Parent',f1,'Position',[.05 .05 .8 .8]);
%pp =  2.017;
%xx = [pp pp -pp -pp];
%yy = [pp -pp pp -pp];

%qpx =[NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;0.828547728235057;0.820093159579597;0.803184022268677;0.786274884957758;0.777820316302298;0.760911178991378;0.744002041680459;0.727092904369539;0.701729198403160;0.693274629747700;NaN;NaN;NaN;NaN;1.43478787878788;1.41087474747475;1.38696161616162;1.35109191919192;1.32717878787879;1.29130909090909;1.25543939393939;1.24348282828283;1.23152626262626;1.20761313131313;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN];
%qpy = [NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;0.828547728235056;0.820093159579597;0.803184022268677;0.786274884957758;0.777820316302298;0.760911178991378;0.744002041680459;0.727092904369539;0.701729198403160;0.693274629747700;NaN;NaN;NaN;NaN;0;0;0;0;0;0;0;0;0;0;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN];
[sy,sx,sz]=size(map);
colormap(clmap)
path = strcat(directory,filename);

    for i=1:sz
        plane=map(:,:,i);
         
%        plot(qpx(i),qpy(i),'yx','MarkerEdgeColor','y','MarkerFaceColor','r',...
%               'LineWidth',2,'MarkerSize',10);
%        hold on;       
         set(gca,'Position',[0 0 1 1]);         
         axis equal; axis off; 
         
      %   plot(xx,yy,'ro','MarkerFaceColor','r','MarkerEdgeColor','r',...
      %       'MarkerSize',5);  
       %  hold on;
        % pcolor(rx,ry,squeeze(plane)); shading flat ; axis off; axis equal 
         imagesc(rx,ry,squeeze(plane)); axis off; axis equal 
         hold on;
         text(0.4,0.1,[num2str(energy(i)*1000,'%6.2f'),' meV'],'Units','normalized',...
                'Fontsize',18,'Color',[1 1 1]);
        
        %[mini,maxi]=get_colormap_limits(plane,clbnd(1)/100,clbnd(2)/100,'h');
        mini = clbnd(i,1); maxi = clbnd(i,2);
        caxis([mini maxi]);
        movie1(:,i)=getframe(gcf);
        set(gca, 'NextPlot', 'replace');
        hold off;
    end
    movie2avi(movie1, path,'compression','None','fps',frps,'quality',quality);
end