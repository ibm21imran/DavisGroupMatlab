%% Load Data, both the dI/dV and the topo
clear all
close all
STM_View_v2;

%% Mark all vortices

h=img_plot3(obj_30527A00_G.map(:,:,21));
datacursormode on
%% Get the vortices position
dcm_obj=datacursormode(h);
info_struct = getCursorInfo(dcm_obj);
xpos=zeros(length(info_struct),1);
ypos=xpos;

%% Write x and y coordinates in xpos and ypos
for i=1:length(info_struct)
    xpos(i)=info_struct(1,i).Position(1,1);
    ypos(i)=info_struct(1,i).Position(1,2);
end
datacursormode off

%% Find the x- and y-coordinate for the L-shape

h=img_plot3(obj_30527A00_T.map);
datacursormode on
%% write to Lx and Ly
dcm_obj=datacursormode(h);
info_struct = getCursorInfo(dcm_obj);
Lxall=zeros(length(info_struct),1);
Lyall=Lxall;
for i=1:length(info_struct)
    Lxall(i)=info_struct(1,i).Position(1,1);
    Lyall(i)=info_struct(1,i).Position(1,2);
end
Lx=mean(Lxall);
Ly=mean(Lyall);

%% Get the number of pixels and the actual size of the map
load C:\Users\Peter\Desktop\Cornell_PhD\Data\NaFeCoAs_data\May_2013\05_27_13\Vortex_052713.mat

datacursormode off
xypix=obj_30527A00_G.info.irows;
xydim=obj_30527A00_G.info.x_distmax;
xyunit=obj_30527A00_G.info.xyunit;

testfornm=regexp(xyunit,'nm');

if testfornm == 1
    xydim=xydim*10;
end

%% Write everything into the struct "vortex"


vortex.xpos=xpos;
vortex.ypos=ypos;
vortex.Lxall=Lxall;
vortex.Lyall=Lyall;
vortex.Lx=Lx;
vortex.Ly=Ly;
vortex.xypix=xypix;
vortex.xydim=xydim;

% save('C:\Users\Peter\Desktop\Cornell_PhD\Data\NaFeCoAs_data\May_2013\05_0
% 4_13\Vortex_050413.mat','vortex')
% close all

%% Fit the vortices to two-dimensional Gaussians

fitresults=cell(1,length(vortex.xpos));
fitx=zeros(1,length(vortex.xpos));
fity=fitx;
absx=fitx;
absy=absx;
hresx=absx;
hresy=absy;

for i=1:length(vortex.xpos)
    if vortex.xpos(i)-1 >= 15
        xmin=vortex.xpos(i)-15;
    else
        xmin=1;
    end
    if vortex.xypix-vortex.xpos(i) >=15
        xmax=vortex.xpos(i)+15;
    else
        xmax=vortex.xypix;
    end
    if vortex.ypos(i)-1 >= 15
        ymin=vortex.ypos(i)-15;
    else
        ymin=1;
    end
    if vortex.xypix-vortex.ypos(i) >=15
        ymax=vortex.ypos(i)+15;
    else
        ymax=vortex.xypix;
    end
    % change the layer of the map so the zero bias level is used
    data=obj_30527A00_G.map(ymin:ymax,xmin:xmax,2);
    % plots the data (zero bias part of map)
    img_plot3(data);
    % fit the data
    [x,resnorm,residual]=complete_fit_2d_gaussian(data);
    % collect the fitresults and the corner coordinates of the box around
    % the vortex in the cell fitresults
    fitresults{i}=[x;xmin;xmax;ymin;ymax];
    % calculate the x and y position with respect to the map
    fitx(i)=round(x(2))-1+xmin;
    fity(i)=round(x(4))-1+ymin;
    % calculate the x and y position with respect to the L shape and other
    % two landmarks on its own map
    absx(i)=(fitx(i)-vortex.Lx)*xydim/xypix;
    absy(i)=(fity(i)-vortex.Ly)*xydim/xypix;
    % calculate the x and y position with respect to the L shape and other
    % two landmarks on the atomic resolution map
    hresx(i)=round((62+103+186)/3)+round(absx(i)*512/750);
    hresy(i)=round((322+217+270)/3)+round(absy(i)*512/750);
    % empty data
    data=[];
end

%% Save the fit x- and y-coordinates
vortex.fitx=fitx;
vortex.fity=fity;
vortex.absx=absx;
vortex.absy=absy;
vortex.hresx=hresx;
vortex.hresy=hresy;
vortex.fitresults=fitresults;

save('C:\Users\Peter\Desktop\Cornell_PhD\Data\NaFeCoAs_data\May_2013\05_27_13\Vortex_052713.mat','vortex')
% close all
%% Plot the three landmarks and their center of gravity on the currebtly
%% used map
% load C:\Users\Peter\Desktop\Cornell_PhD\Data\NaFeCoAs_data\May_2013\05_04_13\Vortex_050413.mat
h1=img_plot3(obj_30527A00_T.map);
line([vortex.Lxall(1),vortex.Lxall(1)],[vortex.Lyall(1)-1,vortex.Lyall(1)+1],'Linewidth',10,'Color','y');
line([vortex.Lxall(1)-1,vortex.Lxall(1)+1],[vortex.Lyall(1),vortex.Lyall(1)],'Linewidth',10, 'Color','y');
line([vortex.Lxall(2),vortex.Lxall(2)],[vortex.Lyall(2)-1,vortex.Lyall(2)+1],'Linewidth',10,'Color','y');
line([vortex.Lxall(2)-1,vortex.Lxall(2)+1],[vortex.Lyall(2),vortex.Lyall(2)],'Linewidth',10, 'Color','y');
line([vortex.Lxall(3),vortex.Lxall(3)],[vortex.Lyall(3)-1,vortex.Lyall(3)+1],'Linewidth',10,'Color','y');
line([vortex.Lxall(3)-1,vortex.Lxall(3)+1],[vortex.Lyall(3),vortex.Lyall(3)],'Linewidth',10, 'Color','y');
% test1=(vortex.Lxall(1)+vortex.Lxall(2)+vortex.Lxall(3))/3;
% test2=(vortex.Lyall(1)+vortex.Lyall(2)+vortex.Lyall(3))/3;
line([vortex.Lx,vortex.Lx],[vortex.Ly-1,vortex.Ly+1],'Linewidth',10,'Color','c');
line([vortex.Lx-1,vortex.Lx+1],[vortex.Ly,vortex.Ly],'Linewidth',10, 'Color','c');
% saves the figure as a png
saveas(h1,'C:\Users\Peter\Desktop\Cornell_PhD\Data\NaFeCoAs_data\May_2013\05_27_13\Vortex_052713_Lshape','png')
%% Plot the three landmarks, their center of gravity and all fitted vortex
%% positions on the currently used map or the corresponding topograph
load C:\Users\Peter\Desktop\Cornell_PhD\Data\NaFeCoAs_data\May_2013\05_27_13\Vortex_052713.mat
% if you used the map and not the topo you have to change the layer to the
% zero bias one
h2=img_plot3(obj_30527A00_G.map(:,:,2));
% h2=img_plot3(obj_30527A00_T.map);
line([vortex.Lxall(1),vortex.Lxall(1)],[vortex.Lyall(1)-1,vortex.Lyall(1)+1],'Linewidth',10,'Color','y');
line([vortex.Lxall(1)-1,vortex.Lxall(1)+1],[vortex.Lyall(1),vortex.Lyall(1)],'Linewidth',10, 'Color','y');
line([vortex.Lxall(2),vortex.Lxall(2)],[vortex.Lyall(2)-1,vortex.Lyall(2)+1],'Linewidth',10,'Color','y');
line([vortex.Lxall(2)-1,vortex.Lxall(2)+1],[vortex.Lyall(2),vortex.Lyall(2)],'Linewidth',10, 'Color','y');
line([vortex.Lxall(3),vortex.Lxall(3)],[vortex.Lyall(3)-1,vortex.Lyall(3)+1],'Linewidth',10,'Color','y');
line([vortex.Lxall(3)-1,vortex.Lxall(3)+1],[vortex.Lyall(3),vortex.Lyall(3)],'Linewidth',10, 'Color','y');
line([vortex.Lx,vortex.Lx],[vortex.Ly-1,vortex.Ly+1],'Linewidth',10,'Color','c');
line([vortex.Lx-1,vortex.Lx+1],[vortex.Ly,vortex.Ly],'Linewidth',10, 'Color','c');
% plots the vortex positions
for i=1:length(vortex.fitx)
    line([vortex.fitx(i),vortex.fitx(i)],[vortex.fity(i)-1,vortex.fity(i)+1],'Linewidth',10,'Color','r');
    line([vortex.fitx(i)-1,vortex.fitx(i)+1],[vortex.fity(i),vortex.fity(i)],'Linewidth',10, 'Color','r');
end
% saves the figure as a png
saveas(h2,'C:\Users\Peter\Desktop\Cornell_PhD\Data\NaFeCoAs_data\May_2013\05_27_13\Vortex_052713_positions_v','png')

%% Plot the three landmarks, their center of gravity and the vortex
%% positions on the atomic resolution map
% Plot the high-resolution topo and mark the L-shape with a cross
img_plot3(obj_30606A03_T.map);
line([62,62],[321,323],'Linewidth',10,'Color','y');
line([61,63],[322,322],'Linewidth',10, 'Color','y');
line([103,103],[216,218],'Linewidth',10,'Color','y');
line([102,104],[217,217],'Linewidth',10, 'Color','y');
line([186,186],[269,271],'Linewidth',10,'Color','y');
line([185,187],[270,270],'Linewidth',10, 'Color','y');
a=round((62+103+186)/3);
b=round((322+217+270)/3);
line([a,a],[b-1,b+1],'Linewidth',10,'Color','c');
line([a-1,a+1],[b,b],'Linewidth',10, 'Color','c');

for i=1:length(vortex.hresx)
    line([vortex.hresx(i),vortex.hresx(i)],[vortex.hresy(i)-1,vortex.hresy(i)+1],'Linewidth',10,'Color','r');
    line([vortex.hresx(i)-1,vortex.hresx(i)+1],[vortex.hresy(i),vortex.hresy(i)],'Linewidth',10, 'Color','r');
end

%% All 3 Tesla maps, load the vortex positions and combine them all in two
%% arrays ThreeTx (x coord.) and ThreeTy (y coord.)
load C:\Users\Peter\Desktop\Cornell_PhD\Data\NaFeCoAs_data\May_2013\05_04_13\Vortex_050413.mat

ThreeTx=vortex.hresx;
ThreeTy=vortex.hresy;
clear vortex;

load C:\Users\Peter\Desktop\Cornell_PhD\Data\NaFeCoAs_data\May_2013\05_06_13\Vortex_050613.mat

ThreeTx=[ThreeTx vortex.hresx];
ThreeTy=[ThreeTy vortex.hresy];
clear vortex;

load C:\Users\Peter\Desktop\Cornell_PhD\Data\NaFeCoAs_data\May_2013\05_08_13\Vortex_050813.mat

ThreeTx=[ThreeTx vortex.hresx];
ThreeTy=[ThreeTy vortex.hresy];
clear vortex;

load C:\Users\Peter\Desktop\Cornell_PhD\Data\NaFeCoAs_data\May_2013\05_15_13\Vortex_051513.mat

ThreeTx=[ThreeTx vortex.hresx];
ThreeTy=[ThreeTy vortex.hresy];
clear vortex;

load C:\Users\Peter\Desktop\Cornell_PhD\Data\NaFeCoAs_data\May_2013\05_23_13\Vortex_052313.mat

ThreeTx=[ThreeTx vortex.hresx];
ThreeTy=[ThreeTy vortex.hresy];
clear vortex;

load C:\Users\Peter\Desktop\Cornell_PhD\Data\NaFeCoAs_data\May_2013\05_27_13\Vortex_052713.mat

ThreeTx=[ThreeTx vortex.hresx];
ThreeTy=[ThreeTy vortex.hresy];
clear vortex;

%% All 1 T maps, load the vortex positions and combine them all in two
%% arrays OneTx (x coord.) and OneTy (y coord.)
load C:\Users\Peter\Desktop\Cornell_PhD\Data\NaFeCoAs_data\June_2013\06_02_13\Vortex_060213.mat

OneTx=vortex.hresx;
OneTy=vortex.hresy;
clear vortex;

%% All 6 T maps, load the vortex positions and combine them all in two
%% arrays SixTx (x coord.) and SixTy (y coord.)
load C:\Users\Peter\Desktop\Cornell_PhD\Data\NaFeCoAs_data\June_2013\06_12_13\Vortex_061213.mat

SixTx=vortex.hresx;
SixTy=vortex.hresy;
clear vortex;

load C:\Users\Peter\Desktop\Cornell_PhD\Data\NaFeCoAs_data\June_2013\06_13_13\Vortex_061313.mat

SixTx=[SixTx vortex.hresx];
SixTy=[SixTy vortex.hresy];
clear vortex;

%% All 8 T maps, load the vortex positions and combine them all in two
%% arrays EightTx (x coord.) and EightTy (y coord.)
load C:\Users\Peter\Desktop\Cornell_PhD\Data\NaFeCoAs_data\June_2013\06_14_13\Vortex_061413.mat

EightTx=vortex.hresx;
EightTy=vortex.hresy;
clear vortex;

%% All 4 T maps, load the vortex positions and combine them all in two
%% arrays FourTx (x coord.) and FourTy (y coord.)
load C:\Users\Peter\Desktop\Cornell_PhD\Data\NaFeCoAs_data\June_2013\06_17_13\Vortex_061713.mat

FourTx=vortex.hresx;
FourTy=vortex.hresy;
clear vortex;

%% Plot the vortices on the atomic resolution map

% changed contrast of the atomic resolution map
a=obj_30606A03_T.map;
% for i=1:512
%     for j=1:512
%         if i>=186 && i<=199
%             if a(i,j) <= 0.35 && a(i,j) >= 0.29
%                 b(i,j)=a(i,j);
%             else
%                 if a(i,j) > 0.35
%                     b(i,j)=0.35;
%                 else
%                     b(i,j)=0.29;
%                 end
%             end
%         elseif i==200
%             if j<=380
%                 if a(i,j) <= 0.35 && a(i,j) >= 0.29
%                 b(i,j)=a(i,j);
%                 else
%                     if a(i,j) > 0.35
%                         b(i,j)=0.35;
%                     else
%                         b(i,j)=0.29;
%                     end
%                 end
%             else
%                if a(i,j) <= 0.12 && a(i,j) >= -0.15
%                 b(i,j)=a(i,j);
%                else
%                     if a(i,j) > 0
%                         b(i,j)=0.15;
%                     else
%                         b(i,j)=-0.15;
%                     end
%                 end 
%             end
%         else
%             if a(i,j) <= 0.12 && a(i,j) >= -0.15
%                 b(i,j)=a(i,j);
%             else
%                 if a(i,j) > 0
%                     b(i,j)=0.15;
%                 else
%                     b(i,j)=-0.15;
%                 end
%             end
%         end
%     end
% end

for i=1:512
    for j=1:512
            if a(i,j) <= 0 
                b(i,j)=0;
            elseif a(i,j) >=0.1
                b(i,j)=0;
            else
                b(i,j)=a(i,j);
                
%                 if a(i,j) > 0
%                     b(i,j)=0.12;
%                 else
%                     b(i,j)=-0.1;
%                 end
            end
%                 if a(i,j) <= 0.37 && a(i,j) >= 0.27
%                     b(i,j)=a(i,j);
%                 else
%                         if a(i,j) > 0.37
%                         b(i,j)=0.37;
%                         else
%                         b(i,j)=0.27;
%                         end
%                 end
    end
end

img_plot3(b);
% imagesc(b);
% colormap(gray);

for i=1:length(OneTx)
    if OneTx(i) <=0 || OneTx(i) > 512 || OneTy(i) <=0 || OneTy(i) >512
    else
        line([OneTx(i),OneTx(i)],[OneTy(i)-1,OneTy(i)+1],'Linewidth',10,'Color','blue');
        line([OneTx(i)-1,OneTx(i)+1],[OneTy(i),OneTy(i)],'Linewidth',10, 'Color','blue');
    end
end

for i=1:length(ThreeTx)
    if ThreeTx(i) <=0 || ThreeTx(i) > 512 || ThreeTy(i) <=0 || ThreeTy(i) >512
    else
        line([ThreeTx(i),ThreeTx(i)],[ThreeTy(i)-1,ThreeTy(i)+1],'Linewidth',10,'Color','red');
        line([ThreeTx(i)-1,ThreeTx(i)+1],[ThreeTy(i),ThreeTy(i)],'Linewidth',10, 'Color','red');
    end
end

for i=1:length(FourTx)
    if FourTx(i) <=0 || FourTx(i) > 512 || FourTy(i) <=0 || FourTy(i) >512
    else
        line([FourTx(i),FourTx(i)],[FourTy(i)-1,FourTy(i)+1],'Linewidth',10,'Color','cyan');
        line([FourTx(i)-1,FourTx(i)+1],[FourTy(i),FourTy(i)],'Linewidth',10, 'Color','cyan');
    end
end

for i=1:length(SixTx)
    if SixTx(i) <=0 || SixTx(i) > 512 || SixTy(i) <=0 || SixTy(i) >512
    else
        line([SixTx(i),SixTx(i)],[SixTy(i)-1,SixTy(i)+1],'Linewidth',10,'Color','yellow');
        line([SixTx(i)-1,SixTx(i)+1],[SixTy(i),SixTy(i)],'Linewidth',10, 'Color','yellow');
    end
end

for i=1:length(EightTx)
    if EightTx(i) <=0 || EightTx(i) > 512 || EightTy(i) <=0 || EightTy(i) >512
    else
        line([EightTx(i),EightTx(i)],[EightTy(i)-1,EightTy(i)+1],'Linewidth',10,'Color',[1 0.5 0]);
        line([EightTx(i)-1,EightTx(i)+1],[EightTy(i),EightTy(i)],'Linewidth',10, 'Color',[1 0.5 0]);
    end
end

%% Gap map, repeat the same as for the atomic resolution topograph (gapx
%% and gapy contain the vortex positions with respect to the L shape and
%% other two landmarks on the gap map)


load C:\Users\Peter\Desktop\Cornell_PhD\Data\NaFeCoAs_data\May_2013\05_04_13\Vortex_050413.mat


for i=1:length(vortex.absx)
    gapx(i)=round((16+23+39)/3)+round(vortex.absx(i)*100/750);
    gapy(i)=round((58+38+48)/3)+round(vortex.absy(i)*100/750);
end
ThreeTx=gapx;
ThreeTy=gapy;
clear vortex;
clear gapx;
clear gapy;

load C:\Users\Peter\Desktop\Cornell_PhD\Data\NaFeCoAs_data\May_2013\05_06_13\Vortex_050613.mat

for i=1:length(vortex.absx)
    gapx(i)=round((16+23+39)/3)+round(vortex.absx(i)*100/750);
    gapy(i)=round((58+38+48)/3)+round(vortex.absy(i)*100/750);
end
ThreeTx=[ThreeTx gapx];
ThreeTy=[ThreeTy gapy];
clear vortex;
clear gapx;
clear gapy;

load C:\Users\Peter\Desktop\Cornell_PhD\Data\NaFeCoAs_data\May_2013\05_08_13\Vortex_050813.mat

for i=1:length(vortex.absx)
    gapx(i)=round((16+23+39)/3)+round(vortex.absx(i)*100/750);
    gapy(i)=round((58+38+48)/3)+round(vortex.absy(i)*100/750);
end
ThreeTx=[ThreeTx gapx];
ThreeTy=[ThreeTy gapy];
clear vortex;
clear gapx;
clear gapy;

load C:\Users\Peter\Desktop\Cornell_PhD\Data\NaFeCoAs_data\May_2013\05_15_13\Vortex_051513.mat

for i=1:length(vortex.absx)
    gapx(i)=round((16+23+39)/3)+round(vortex.absx(i)*100/750);
    gapy(i)=round((58+38+48)/3)+round(vortex.absy(i)*100/750);
end
ThreeTx=[ThreeTx gapx];
ThreeTy=[ThreeTy gapy];
clear vortex;
clear gapx;
clear gapy;

load C:\Users\Peter\Desktop\Cornell_PhD\Data\NaFeCoAs_data\May_2013\05_23_13\Vortex_052313.mat

for i=1:length(vortex.absx)
    gapx(i)=round((16+23+39)/3)+round(vortex.absx(i)*100/750);
    gapy(i)=round((58+38+48)/3)+round(vortex.absy(i)*100/750);
end
ThreeTx=[ThreeTx gapx];
ThreeTy=[ThreeTy gapy];
clear vortex;
clear gapx;
clear gapy;

load C:\Users\Peter\Desktop\Cornell_PhD\Data\NaFeCoAs_data\May_2013\05_27_13\Vortex_052713.mat

for i=1:length(vortex.absx)
    gapx(i)=round((16+23+39)/3)+round(vortex.absx(i)*100/750);
    gapy(i)=round((58+38+48)/3)+round(vortex.absy(i)*100/750);
end
ThreeTx=[ThreeTx gapx];
ThreeTy=[ThreeTy gapy];
clear vortex;
clear gapx;
clear gapy;

%% All 1 T maps
load C:\Users\Peter\Desktop\Cornell_PhD\Data\NaFeCoAs_data\June_2013\06_02_13\Vortex_060213.mat

for i=1:length(vortex.absx)
    gapx(i)=round((16+23+39)/3)+round(vortex.absx(i)*100/750);
    gapy(i)=round((58+38+48)/3)+round(vortex.absy(i)*100/750);
end
OneTx=gapx;
OneTy=gapy;
clear vortex;
clear gapx;
clear gapy;


%% All 6 T maps
load C:\Users\Peter\Desktop\Cornell_PhD\Data\NaFeCoAs_data\June_2013\06_12_13\Vortex_061213.mat

for i=1:length(vortex.absx)
    gapx(i)=round((16+23+39)/3)+round(vortex.absx(i)*100/750);
    gapy(i)=round((58+38+48)/3)+round(vortex.absy(i)*100/750);
end

SixTx=gapx;
SixTy=gapy;
clear vortex;
clear gapx;
clear gapy;


load C:\Users\Peter\Desktop\Cornell_PhD\Data\NaFeCoAs_data\June_2013\06_13_13\Vortex_061313.mat

for i=1:length(vortex.absx)
    gapx(i)=round((16+23+39)/3)+round(vortex.absx(i)*100/750);
    gapy(i)=round((58+38+48)/3)+round(vortex.absy(i)*100/750);
end
SixTx=[SixTx gapx];
SixTy=[SixTy gapy];
clear vortex;
clear gapx;
clear gapy;


%% All 8 T maps
load C:\Users\Peter\Desktop\Cornell_PhD\Data\NaFeCoAs_data\June_2013\06_14_13\Vortex_061413.mat

for i=1:length(vortex.absx)
    gapx(i)=round((16+23+39)/3)+round(vortex.absx(i)*100/750);
    gapy(i)=round((58+38+48)/3)+round(vortex.absy(i)*100/750);
end

EightTx=gapx;
EightTy=gapy;
clear vortex;
clear gapx;
clear gapy;

%% All 4 T maps
load C:\Users\Peter\Desktop\Cornell_PhD\Data\NaFeCoAs_data\June_2013\06_17_13\Vortex_061713.mat

for i=1:length(vortex.absx)
    gapx(i)=round((16+23+39)/3)+round(vortex.absx(i)*100/750);
    gapy(i)=round((58+38+48)/3)+round(vortex.absy(i)*100/750);
end

FourTx=gapx;
FourTy=gapy;
clear vortex;
clear gapx;
clear gapy;

%% Plot the vortices on the gap map (include the for loop if you want to
%% have all 41 layers of the gap map) or the corresponding topograph
% for i=1:41
% h=img_plot3(obj_30611A00_G.map(:,:,i));
% img_obj_viewer2(obj_30611A00_G)
img_plot3(obj_30611A00_T.map);
count=1;

for i=1:length(OneTx)
    if OneTx(i) <=0 || OneTx(i) > 100 || OneTy(i) <=0 || OneTy(i) >100
    else
        line([OneTx(i),OneTx(i)],[OneTy(i)-1,OneTy(i)+1],'Linewidth',4,'Color','blue');
        line([OneTx(i)-1,OneTx(i)+1],[OneTy(i),OneTy(i)],'Linewidth',4, 'Color','blue');
        AllTx(count)=OneTx(i);
        AllTy(count)=OneTy(i);
        count=count+1;
    end
end

for i=1:length(ThreeTx)
    if ThreeTx(i) <=0 || ThreeTx(i) > 100 || ThreeTy(i) <=0 || ThreeTy(i) >100
    else
        line([ThreeTx(i),ThreeTx(i)],[ThreeTy(i)-1,ThreeTy(i)+1],'Linewidth',4,'Color','red');
        line([ThreeTx(i)-1,ThreeTx(i)+1],[ThreeTy(i),ThreeTy(i)],'Linewidth',4, 'Color','red');
        AllTx(count)=ThreeTx(i);
        AllTy(count)=ThreeTy(i);
        count=count+1;
    end
end

for i=1:length(FourTx)
    if FourTx(i) <=0 || FourTx(i) > 100 || FourTy(i) <=0 || FourTy(i) >100
    else
        line([FourTx(i),FourTx(i)],[FourTy(i)-1,FourTy(i)+1],'Linewidth',4,'Color','cyan');
        line([FourTx(i)-1,FourTx(i)+1],[FourTy(i),FourTy(i)],'Linewidth',4, 'Color','cyan');
        AllTx(count)=FourTx(i);
        AllTy(count)=FourTy(i);
        count=count+1;
    end
end

for i=1:length(SixTx)
    if SixTx(i) <=0 || SixTx(i) > 100 || SixTy(i) <=0 || SixTy(i) >100
    else
        line([SixTx(i),SixTx(i)],[SixTy(i)-1,SixTy(i)+1],'Linewidth',4,'Color','magenta');
        line([SixTx(i)-1,SixTx(i)+1],[SixTy(i),SixTy(i)],'Linewidth',4, 'Color','magenta');
        AllTx(count)=SixTx(i);
        AllTy(count)=SixTy(i);
        count=count+1;
    end
end

for i=1:length(EightTx)
    if EightTx(i) <=0 || EightTx(i) > 100 || EightTy(i) <=0 || EightTy(i) >100
    else
        line([EightTx(i),EightTx(i)],[EightTy(i)-1,EightTy(i)+1],'Linewidth',4,'Color',[1 0.5 0]);
        line([EightTx(i)-1,EightTx(i)+1],[EightTy(i),EightTy(i)],'Linewidth',4, 'Color',[1 0.5 0]);
        AllTx(count)=EightTx(i);
        AllTy(count)=EightTy(i);
        count=count+1;
    end
end


% end

%% calculate the mean spectrum of all vortex positions


xyvect=[AllTx; AllTy];

meanspec=local_average_average(obj_30611A00_G,obj_30611A00_T,0,xyvect);


