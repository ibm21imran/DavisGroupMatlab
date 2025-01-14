function [brpc,dapc]=RhorCo(topo,resf,x,y,topon)

% momentum coordinates 30820A02_T
% ftl1=[0.82 -1.41];
% ftl2=[-1.57 -1.00];
% ftl3=[-0.82 1.41];
% ftl4=[1.57 1.00];

% momentum coordinates 30820A03_T
ftl1=[0.94 -1.66];
ftl2=[-1.55 -1.04];
ftl3=[-0.82 1.46];
ftl4=[1.55 1.04];

% real space coordinates LL, LR
rsl1=[ftl2(2) -ftl2(1)];
rsl2=[-ftl1(2) ftl1(1)];
nl=2*pi/(rsl1(1)*rsl2(2)-rsl1(2)*rsl2(2));
% conversion into pixel 30820A02_T
% rsl1=rsl1*nl*512/200*resf;
% rsl2=rsl2*nl*512/200*resf;
% conversion into pixel 30820A03_T
% rsl1=rsl1*nl*1024/400*resf;
% rsl2=rsl2*nl*1024/400*resf;

% calculate without FT and only topo
rsl1 = [262.76-259.63, 222.87-220.92];
rsl2 = [262.76-264.71, 222.87-219.35];
rsl1=rsl1*1024/400*resf;
rsl2=rsl2*1024/400*resf;

figure, imagesc(topo), colormap(gray)
% Command to mark a dot
% line(x,y,'Color','r','Marker','.','MarkerSize',5)

[nx ny nz] = size(topo);

k=1;
l=1;

for i=-nx:nx
    for j=-nx:nx
        newx1=(x+i*rsl1(1)+j*rsl2(1)); 
        newy1=(y+i*rsl1(2)+j*rsl2(2));
        if newx1 <= nx && newx1 >= 1 && newy1 <= nx && newy1 >= 1
            line(newx1,newy1,'Color','r','Marker','.','MarkerSize',5);
            xcor1(k)=newx1;
            ycor1(k)=newy1;
            k=k+1;
        end    
        
%         
%         if newx2 <= nx && newx2 >= 1 && newy2 <= nx && newy2 >= 1
%             tbt=(topon(ceil(newy2),ceil(newx2))+topon(floor(newy2),floor(newx2)))/2;
%             if tbt > 0
%                 xcor1(k)=newx2;
%                 ycor1(k)=newy2;
%                 k=k+1;
%             end
%             line(newx2,newy2,'Color','b','Marker','.','MarkerSize',5);
%             Cocounter1=Cocounter1+1;
%         end        
  
        
    end
end

bright=0;
dark=0;
k=1;
l=1;
for i=1:length(xcor1)
    if topo(round(ycor1(i)),round(xcor1(i))) >= -0.03
        bright=bright+1;
        xcor2(k)=xcor1(i);
        ycor2(k)=ycor1(i);
        k=k+1;
    else
        dark=dark+1;
        xcor3(l)=xcor1(i);
        ycor3(l)=ycor1(i);
        l=l+1;
    end
end

total=dark+bright;
brpc=bright/total*100;
dapc=dark/total*100;

figure, imagesc(topo), colormap(gray)
axis image;
for i=1:length(xcor2)
    line(xcor2(i),ycor2(i),'Color','b','Marker','.','MarkerSize',5);
end
for i=1:length(xcor3)
    line(xcor3(i),ycor3(i),'Color','r','Marker','.','MarkerSize',5);
end


end