function co2=get_start_coord(co)



%create stuff
fh=figure('Color',[1 1 1],'units','centimeter', ...
    'Position',[2,2,10,10]);


            


main_axis = axes('Parent',fh,'units','normalized',...
                'units','normalized',...
                'Position',[.05 .05 .9 .9]);

axes(main_axis)   
tri = delaunay(co(:,2),co(:,1));



plot(co(:,2),co(:,1),'bo')            
hold on


 
[xi,yi,but] = ginput(1);
   

plot(xi,yi,'rx')

poi=dsearch(co(:,2),co(:,1),tri,xi,yi);
plot(co(poi,2),co(poi,1),'r.')

co2=co;
co2(1,:)=co(poi,:);
co2(poi,:)=co(1,:);