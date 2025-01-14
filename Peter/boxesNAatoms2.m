function [xcor1,ycor1,xcor2,ycor2,Cocounter]=boxesNAatoms2(topo,resf,x,y,topon)

% momentum coordinates UL,UM,UR
ftl1=[1.54 -0.91];
ftl2=[-0.98 -1.54];
ftl3=[-1.54 0.91];
ftl4=[0.98 1.54];

% momentum coordinates LL,LR
% ftl1=[1.52 -0.89];
% ftl2=[-0.97 -1.56];
% ftl3=[-1.52 0.89];
% ftl4=[0.97 1.56];

% real space coordinates UL, UR, UM
rsl1=[-1.54 +0.98];
rsl2=[0.91 1.54];
nl=2*pi/(-1.54*1.54+0.98*(-0.91));
rsl1=rsl1*nl*512/750;
rsl2=rsl2*nl*512/750;

% real space coordinates LL, LR
% rsl1=[-1.56 0.97];
% rsl2=[0.89 1.52];
% nl=2*pi/(-1.56*1.52+0.97*(-0.89));
% rsl1=rsl1*nl*512/750*resf;
% rsl2=rsl2*nl*512/750*resf;

% Pick an x-, and y-coordinate for your origin of the atomic lattice
% x=142;
% y=164;

% Lattice vectors for Fe/Co atoms
rsl3=(rsl1+rsl2)/2;
rsl4=(rsl1-rsl2)/2;

topon=boxestoones(topo,1);
close all;

figure, imagesc(topo), colormap(gray)
% Command to mark a dot
% line(x,y,'Color','r','Marker','.','MarkerSize',5)

[nx ny nz] = size(topo);

k=1;
l=1;
Cocounter1=0;
Cocounter2=0;
for i=-nx:nx
    for j=-nx:nx
        newx1=(x+i*rsl1(1)+j*rsl2(1)); 
        newy1=(y+i*rsl1(2)+j*rsl2(2));
        if newx1 <= nx && newx1 >= 1 && newy1 <= nx && newy1 >= 1
            line(newx1,newy1,'Color','r','Marker','.','MarkerSize',5);
        end    
        
        % Fe / Co atom positions
        newx2=(x+i*rsl1(1)+j*rsl2(1)+0.5*rsl1(1)); 
        newy2=(y+i*rsl1(2)+j*rsl2(2)+0.5*rsl1(2));
        newx3=(x+i*rsl1(1)+j*rsl2(1)+0.5*rsl2(1)); 
        newy3=(y+i*rsl1(2)+j*rsl2(2)+0.5*rsl2(2));
        
        if newx2 <= nx && newx2 >= 1 && newy2 <= nx && newy2 >= 1
            tbt=(topon(ceil(newy2),ceil(newx2))+topon(floor(newy2),floor(newx2)))/2;
            if tbt > 0
                xcor1(k)=newx2;
                ycor1(k)=newy2;
                k=k+1;
            end
            line(newx2,newy2,'Color','b','Marker','.','MarkerSize',5);
            Cocounter1=Cocounter1+1;
        end        
        
        if newx3 <= nx && newx3 >= 1 && newy3 <= nx && newy3 >= 1
            tbt=(topon(ceil(newy3),ceil(newx3))+topon(floor(newy3),floor(newx3)))/2;
            if tbt > 0
                xcor2(l)=newx3;
                ycor2(l)=newy3;
                l=l+1;
            end
            line(newx3,newy3,'Color','m','Marker','.','MarkerSize',5);
            Cocounter2=Cocounter2+1;
        end      
        
    end
end

Cocounter=Cocounter1+Cocounter2;

figure, imagesc(topo), colormap(gray)
for i=1:length(xcor1)
    line(xcor1(i),ycor1(i),'Color','b','Marker','.','MarkerSize',5);
end
for i=1:length(xcor2)
    line(xcor2(i),ycor2(i),'Color','m','Marker','.','MarkerSize',5);
end


normdis=((rsl2(1))^2+(rsl2(2))^2)^0.5;

[xcor3, ycor3] = posboxreductor1(topo, xcor1, ycor1, normdis);
[xcor4, ycor4] = posboxreductor1(topo, xcor2, ycor2, normdis);


figure, imagesc(topo), colormap(gray)
for i=1:length(xcor3)
    line(xcor3(i),ycor3(i),'Color','b','Marker','.','MarkerSize',5);
end
for i=1:length(xcor4)
    line(xcor4(i),ycor4(i),'Color','m','Marker','.','MarkerSize',5);
end


[nx ny nz] = size(topo);

k=1;
for i=1:length(xcor3)
    abor = 0;
    
    x1 = round(xcor3(i)+1.5*rsl1(1)); 
    y1 = round(ycor3(i)+1.5*rsl1(2));
    if x1 < 1 || x1 > nx || y1 < 1 || y1 > nx
        abor = 1;
    end
    
    x2 = round(xcor3(i)-1.5*rsl1(1)); 
    y2 = round(ycor3(i)-1.5*rsl1(2));
    if x2 < 1 || x2 > nx || y2 < 1 || y2 > nx
        abor = 1;
    end
    
    x3 = round(xcor3(i)+1.5*rsl2(1)); 
    y3 = round(ycor3(i)+1.5*rsl2(2));
    if x3 < 1 || x3 > nx || y3 < 1 || y3 > nx
        abor = 1;
    end
    
    x4 = round(xcor3(i)-1.5*rsl2(1)); 
    y4 = round(ycor3(i)-1.5*rsl2(2));
    if x4 < 1 || x4 > nx || y4 < 1 || y4 > nx
        abor = 1;
    end
    
    if abor == 1
        xcor5(k) = xcor3(i);
        ycor5(k) = ycor3(i);
        k = k + 1;
    else
        lcut1 = line_cut_topo(topo, topo,[x1, y1],[x2, y2],0);
        lcut2 = line_cut_topo(topo, topo,[x3, y3],[x4, y4],0);
        
        if min(lcut1) < 0
            lcut1 = lcut1 - min(lcut1);
        else
            lcut1 = lcut1 + min(lcut1);
        end
        
        if min(lcut2) < 0
            lcut2 = lcut2 - min(lcut2);
        else
            lcut2 = lcut2 + min(lcut2);
        end
        
        close all;
        range1 = 1 : 1 : length(lcut1);
        range2 = 1 : 1 : length(lcut2);

        guess1 = [1, 1, min(range1), 1, 1, max(range1)];
        guess2 = [1, 1, min(range2), 1, 1, max(range2)];

        [y_new1, p1, gof1]=box_rec_fit(lcut1, range1, guess1, 0);
        [y_new2, p2, gof2]=box_rec_fit(lcut2, range2, guess2, 0);

        width_1 = p1.g - p1.c;
        width_2 = p2.g - p2.c;

        if width_1 < 1.5*normdis && width_2 < 1.5*normdis
        else
            xcor5(k) = xcor3(i);
            ycor5(k) = ycor3(i);
            k = k + 1;
        end
    end
end

k=1;
for i=1:length(xcor4)
    abor = 0;
    
    x1 = round(xcor4(i)+1.5*rsl1(1)); 
    y1 = round(ycor4(i)+1.5*rsl1(2));
    if x1 < 1 || x1 > nx || y1 < 1 || y1 > nx
        abor = 1;
    end
    
    x2 = round(xcor4(i)-1.5*rsl1(1)); 
    y2 = round(ycor4(i)-1.5*rsl1(2));
    if x2 < 1 || x2 > nx || y2 < 1 || y2 > nx
        abor = 1;
    end
    
    x3 = round(xcor4(i)+1.5*rsl2(1)); 
    y3 = round(ycor4(i)+1.5*rsl2(2));
    if x3 < 1 || x3 > nx || y3 < 1 || y3 > nx
        abor = 1;
    end
    
    x4 = round(xcor4(i)-1.5*rsl2(1)); 
    y4 = round(ycor4(i)-1.5*rsl2(2));
    if x4 < 1 || x4 > nx || y4 < 1 || y4 > nx
        abor = 1;
    end
    
    if abor == 1
        xcor6(k) = xcor4(i);
        ycor6(k) = ycor4(i);
        k = k + 1;
    else
        lcut1 = line_cut_topo(topo, topo,[x1, y1],[x2, y2],0);
        lcut2 = line_cut_topo(topo, topo,[x3, y3],[x4, y4],0);
        
        if min(lcut1) < 0
            lcut1 = lcut1 - min(lcut1);
        else
            lcut1 = lcut1 + min(lcut1);
        end
        
        if min(lcut2) < 0
            lcut2 = lcut2 - min(lcut2);
        else
            lcut2 = lcut2 + min(lcut2);
        end
        
        close all;
        range1 = 1 : 1 : length(lcut1);
        range2 = 1 : 1 : length(lcut2);

        guess1 = [1, 1, min(range1), 1, 1, max(range1)];
        guess2 = [1, 1, min(range2), 1, 1, max(range2)];

        [y_new1, p1, gof1]=box_rec_fit(lcut1, range1, guess1, 0);
        [y_new2, p2, gof2]=box_rec_fit(lcut2, range2, guess2, 0);

        width_1 = p1.g - p1.c;
        width_2 = p2.g - p2.c;

        if width_1 < 1.5*normdis && width_2 < 1.5*normdis
        else
            xcor6(k) = xcor4(i);
            ycor6(k) = ycor4(i);
            k = k + 1;
        end
    end
end

figure, imagesc(topo), colormap(gray)
for i=1:length(xcor5)
    line(xcor5(i),ycor5(i),'Color','b','Marker','.','MarkerSize',5);
end
for i=1:length(xcor6)
    line(xcor6(i),ycor6(i),'Color','m','Marker','.','MarkerSize',5);
end

end


