function view6(data2)
global data; 
data = data2;
layer=1; %ceil(length(e/2));
IDL_Cmap = open('C:\Analysis Code\MATLAB\ColorMap\IDL_Colormap2.mat');

[nrow,ncol,nz] = size(data.map);
% in case the map is no longer square these two lines adjust the scales for
% plotting
disty=data.r(1:nrow);
distx=data.r(1:ncol);


%generate an array from the map to be used for caxis settings
map_lin = zeros(nrow*ncol,nz);
for k=1:nz;
    map_lin(:,k) = reshape(data.map(:,:,k),nrow*ncol,1);
end
%plane = sort(plane);

%set the colour scale for the whole map based as the min and max values
caxis_min(1:nz) = min(min(map_lin));
caxis_max(1:nz) = max(max(map_lin));

%define pointers to the min/max values of the map to be modified by the
%color histogram call and used by the plot_it function

caxis_min_p = libpointer('doublePtr',caxis_min);
caxis_max_p = libpointer('doublePtr',caxis_max);

%create main figure
fh=figure('Name', [data.name, '-',num2str(data.type)],...
        'units','centimeter', ...
        'Position',[1,4,22,22],...
        'Color',[0.5 0.5 0.5],...
        'MenuBar', 'none',...
        'Renderer','OpenGL');
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Menu Bar%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
f1 = uimenu('Label','Menu');

f2a = uimenu(f1,'Label','Export Map');

uimenu(f2a,'Label','Image Sequence','Callback',{@exportmap_Callback,data2,IDL_Cmap,1});
uimenu(f2a,'Label','Movie','Callback',{@exportmap_Callback,data2,IDL_Cmap,2});
            
uimenu(f1,'Label','Histogram','Callback',{@histogram_Callback,map_lin,caxis_min_p,caxis_max_p});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%GUI Controls%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%coordinates box
coord_tb=annotation('textbox',...
                'units','centimeter',...
                'Position',[0.75 14.5 3.75 6.5],...
                'Color',[1,1,1]);           
            
a0_edit = uicontrol(fh,'Style','Edit',...
                'String','1.0',...
                'units','centimeter',...
                'Position',[5 18.5 1 0.5]);            
            
radius_edit = uicontrol(fh,'Style','Edit',...
                'String','1',...
                'units','centimeter',...
                'Position',[6.5 5.5 2.5 0.5]);
            
mini_edit = uicontrol(fh,'Style','Edit',...
                'String','0',...
                'units','centimeter',...
                'Position',[5 17.5 1 0.5]);
            
maxi_edit = uicontrol(fh,'Style','Edit',...
                'String','0',...
                'units','centimeter',...
                'Position',[6.25 17.5 1 0.5]);

dos_axis = axes('Parent',fh,...
                'units','normalized',...
                'Position',[0.45 0.05 0.43 0.43]);            

main_axis = axes('Parent',fh,...
                'units','normalized',...
                'Position',[0.45 0.55 0.43 0.43]);%10 12 9.5 9.5
            
energy_list = uicontrol(fh,'Style','popupmenu',...
                'units','centimeter',...
                'String', num2str(1000*data.e','%10.2f'),...
                'Value',layer,...
                'Position',[5 5 2 1],...
                'Callback',{@plot_Callback,data,caxis_min_p,caxis_max_p});
            
color_pop = uicontrol(fh,'Style', 'popup',...
       'units', 'centimeter',...
       'String', 'Gray|InvGray|Copper|Hot|Bone|Blue2|Defect1|Defect4|Sailing',...
       'Position', [5 19 2 1],...
       'Callback', {@set_color_Callback,IDL_Cmap});
       
spectra_pop = uicontrol(fh,'Style', 'popup',...
       'units', 'centimeter',...
       'String', 'Spectra OFF|Spectra ON',...
       'Position', [6.5 6 2.5 1]);

redraw_butt = uicontrol(fh,'Style','pushbutton',...
                'String','Update Image',...
                'units','centimeter',...
                'Position',[5 15 2 1.4],...
                'Callback',{@redraw_map_Callback,data,map_lin,caxis_min_p,caxis_max_p}); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Main%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
%caxis_min_p.Value
pcolor(distx',disty, data.map(:,:,1));
caxis([caxis_min_p.Value(1) caxis_max_p.Value(1)]);
shading flat; axis equal; colormap(gray); 
set(gcf, 'windowbuttonmotionfcn', {@gtrack_Move,data});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Functions%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plot_Callback(hObject,eventdata,fdata,cmin_p,cmax_p)
   layer=get(energy_list,'Value'); 
   plot_it(fdata,cmin_p,cmax_p);
end

function plot_it(fdata,cmin_p,cmax_p)
    layer=get(energy_list,'Value');
    pcolor(distx',disty, fdata.map(:,:,layer));
    caxis([cmin_p.Value(layer),cmax_p.Value(layer)]);     
    shading flat; axis equal
end

function redraw_map_Callback(hObject,eventdata,fdata,lin_map,cmin_p,cmax_p)
    mini=str2double(get(mini_edit,'String'));
    maxi=str2double(get(maxi_edit,'String'));
    [nr nc nz] = size(fdata.map);
    for j=1:nz
        [mn mx] = get_colormap_limits4(lin_map(:,j),mini/100,maxi/100,'h');
        cmin_p.Value(j) = mn; cmax_p.Value(j) = mx;
    end
    plot_it(fdata,cmin_p,cmax_p);
end

function gtrack_Move(src,evnt,fdata)
    a0=str2double(get(a0_edit,'String')); 
    % get mouse position
    pt = get(gca, 'CurrentPoint');
    xInd = pt(1, 1);
    yInd = pt(1, 2);

    % check if its within axes limits
    %axes(main_axis);
    
    if xInd < min(distx) || xInd > max(distx)
		return;
    elseif yInd < min(disty) || yInd > max(disty)
        return;
    end
    % if within limits then continue
    ddx = max(distx) - min(distx);
    ddy = max(disty) - min(disty);
    
    %find value of map at mouse position
    %xLim = xlim(main_axis);
    %yLim = ylim(main_axis);
    layer=get(energy_list,'Value');
    mapval = fdata.map(floor((yInd + abs(disty(1)))/ddy*nrow)+1,...
        floor((xInd + abs(distx(1)))/ddx*ncol)+1,layer);

    str={ 'coords' ; ...
    [ '( ' num2str(xInd, '%6.3f') ' , '  num2str(yInd,'%6.3f') ' )'] ; ...
    ' ' ;...
    'pixel' ; ...
    ['( ' num2str(xInd/ddx*ncol + 1,'%6.0f') ' , '...
    num2str(yInd/ddy*nrow + 1,'%6.0f') ' )' ];...
    ' ' ; ...
    'a_0' ; ...
    ['( ' num2str(xInd/a0,'%6.2f') ' , ' num2str(yInd/a0,'%6.2f') ' )'];...
    ' '; ...
    ' 2\pi/a_0 ' ; ...
    ['( ' num2str(xInd/(2*pi/a0),'%6.2f') ' , ' num2str(yInd/(2*pi/a0),'%6.2f') ' )'];...
    ' '; ...
    ' Map Value ' ; ...
    ['( ' num2str(mapval, '%6.3f') ' )'];...
    };
    set(coord_tb,'String',str)
    if get(spectra_pop,'Value')==1        
        return;
    else
        axes(dos_axis);       
        set(gca, 'NextPlot', 'replace');
        plot(fdata.e,squeeze(fdata.map(floor((yInd+ abs(disty(1)))/ddy*nrow)+1,...
            floor((xInd+ abs(distx(1)))/ddx*ncol)+1,:)));
        grid on;
        axes(main_axis);
        return;
    end
end

function set_color_Callback(hObject, evendata, IDL_Cmap)
    val = get(color_pop,'Value');
    if val == 1
        colormap(gray)
    elseif val ==2
        colormap(IDL_Cmap.Invgray);
    elseif val == 3
        colormap(copper)
    elseif val == 4
        colormap(hot)
    elseif val == 5
        colormap(bone)
    elseif val == 6
        colormap(IDL_Cmap.Blue2)
    elseif val == 7
        colormap(IDL_Cmap.Defect1)
    elseif val == 8
        colormap(IDL_Cmap.Defect4)
    elseif val == 9
        colormap(IDL_Cmap.Sailing)
    end
end

    function exportmap_Callback(hObject,evendata,fdata,IDL_CMap,type)
        
        mini=str2double(get(mini_edit,'String'));
        maxi=str2double(get(maxi_edit,'String'));
        
        val = get(color_pop,'Value');        
        if val == 1
            c = gray;
        elseif val == 2
            c = IDL_CMap.Invgray;
        elseif val == 3
            c = copper;
        elseif val == 4
            c= hot;
        elseif val == 5
            c = bone;
        elseif val == 6
            c = IDL_CMap.Blue2;
        elseif val == 7
            c = IDL_CMap.Defect1;
        elseif val == 8
            c = IDL_CMap.Defect4;
        elseif val == 9
            c = IDL_CMap.Sailing;
        end
        if type == 1
            %export a sequence of images
            exportmap_dialogue(fdata.map,fdata.e,fdata.r,fdata.r,c,[mini maxi]);
        elseif type ==2
             exportmovie_dialogue(fdata.map,fdata.e,fdata.r,fdata.r,c,[mini maxi]);
        %export a movie.
        end         
    end

    function histogram_Callback(hObject,evendata,map_lin,c_min_p,c_max_p)
        layer=get(energy_list,'Value'); 
        [nr nc] = size(data.map(:,:,layer));
        lyr_lin = map_lin(:,layer);
        %lyr_lin = reshape(data.map(:,:,layer),nr*nc,1);
        histogram_dialogue2(layer,lyr_lin,c_min_p,c_max_p,min(min(map_lin)),max(max(map_lin)),main_axis);
    end
end