function test_exp_movie_multipanel_dialogue

%to simplify stuff we get rid
% - rows and column choice (fix to 1 Row 2 Columns)

export_path = 'C:\Users\chong\Documents\MATLAB\STMdata\MoTeSe';

h1 = figure(...
'Units','characters',...
'Color',[0.7 0.7 0.7],...
'MenuBar','none',...
'Name','MultiPanel Movie Set Up',...
'NumberTitle','off',...
'Position',[50 10 114 35],...
'Resize','off',...
'Visible','on');


panel_sel_title = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Position',[23 33 15 1.2],...
'String',{'Choose Panel' },...
'Style','text',...
'FontWeight','Bold');

panel_sel = uicontrol(...
    'Parent',h1,...
    'Units','characters',...
    'BackgroundColor',[1 1 1],...
    'Position',[27 30.5 5 2],...
    'Style','popupmenu',...
    'String','1',...
    'Value',1);
r=1;c=2;
panels = 1:(r*c); panels = panels';
set(panel_sel,'String',num2str(panels));

obj_sel_title = uicontrol(...
    'Parent',h1,...
    'Units','characters',...
    'BackgroundColor',[1 1 1],...
    'Position',[39 33 31 1.2],...
    'String',{'Choose Data Object for Panel' },...
    'Style','text',...
    'FontWeight','Bold');


obj_sel = uicontrol(...
    'Parent',h1,...
    'Units','characters',...
    'BackgroundColor',[1 1 1],...
    'Position',[43 30.5 20 2],...
    'String',{'Data Object'},...
    'Style','popupmenu',...
    'Value',1,...
    'Callback',@load_img_Callback);

img1_title = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Position',[81 33 20 1.2],...
'String',{ 'Data Object'},...
'Style','text',...
'FontWeight','Bold');

img1_axes = axes(...
'Parent',h1,...
'Units','characters',...
'Position',[74 20 35 12]);
axis off

img1_lyrs = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Position',[85 16 14 1.5],...
'String',{  '' },...
'Style','popupmenu',...
'Value',1,...
'Callback',@plot_img1_Callback);

 uicontrol(...
'Parent',h1,...
'Units','characters',...
'Position',[83 18 18 1],...
'String','Layer Energy',...
'Style','text');

uicontrol(...
    'Parent',h1,...
    'Units','characters',...
    'BackgroundColor',[1 1 1],...
    'Position',[79 13 25 1],...
    'String','Selected Data for Panels',...
    'Style','text',...
    'FontWeight','Bold');

panel_choices = uicontrol(...
    'Parent',h1,...
    'Unit','characters',...
    'BackgroundColor',[1 1 1],...
    'Position',[75 4 33 8],...
    'String',{'1';'2';'3';'4';'5';'6';'7';'8';'9'},...
    'Style','text');

uicontrol(...
    'Parent',h1,...
    'Units','characters',...
    'BackgroundColor',[1 1 1],...
    'Position',[43 25 25 1],...
    'String','Accept Data For Panel',...
    'Style','text',...
    'FontWeight','Bold');

sel_but = uicontrol(...
    'Parent',h1,...
    'Unit','characters',...
    'Position',[50 22 10 2],...
    'String','Select',...
    'Callback',@sel_data_Callback);

export_but = uicontrol(...
    'Parent',h1,...
    'Units','characters',...
    'Position',[44.5714285714286 0.6 9.85714285714285 1.7],...
    'String','EXPORT',...
    'Callback',@export_Callback);

done_but = uicontrol(...
    'Parent',h1,...
    'Units','characters',...
    'Position',[59.2857142857143 0.6 9.85714285714285 1.7],...
    'String','Done',...
    'Callback',@done_Callback);


uipanel(...
    'Parent',h1,...
    'Title','Export Options',...
    'BackgroundColor',[1 1 1],...
    'Units','characters',...
    'Position',[2 4 65 10]);

filename_entry_text = uicontrol(...
    'Parent',h1,...
    'Style','text',...
    'String','Filename',...
    'BackgroundColor',[1 1 1],...
    'units','characters',...
    'Position',[5 11.5 10 1.2],...
    'FontWeight','Bold');
            
filename_entry = uicontrol(...
    'Parent',h1,...
    'Style','Edit',...
    'units','characters',...
    'Position',[5 10 30 1.5],...    
    'String','filename');

dir_entry_text = uicontrol(...
    'Parent',h1,...
    'Style','text',...
    'BackgroundColor',[1 1 1],...
    'String','Directory',...
    'units','characters',...
    'Position',[5,8.5,10,1.2],...
    'FontWeight','Bold');

dir_entry = uicontrol(...
    'Parent',h1,...
    'Style','Edit',...
    'String',export_path,...
    'units','characters',...
    'Position',[5,7,38,1.5]);

dir_choose = uicontrol(...
    'Parent',h1,...
    'Style','pushbutton',...
    'String','Choose Directory',...
    'units','characters',...
    'Position',[45 7 20 1.5],...
    'FontWeight','Bold',...
    'Callback',(@open_dir_Callback));


% %%%%%%%%%%%%%%%%%%%%%%%% MAIN - Initialize %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%initialize a data structure capable of storing 9 separate data sets
fdata = [];
for i = 1:9
    eval(['fdata.map' num2str(i) ' = [];']);
    eval(['fdata.e' num2str(i) ' = [];']);
    eval(['fdata.clmap' num2str(i) ' = [];']);
    eval(['fdata.clbnd' num2str(i) ' = [];']);
end

%load  handles for all open figures into obj_sel guidata - this is the reference 
load_gui_data_Callback

%load the first data object into the into UserData for figure
handles = get(obj_sel,'UserData');
data_init = guidata(handles(1));
colors_init.bnd = get(handles(1),'UserData');
colors_init.cmap = colormap(handles(1));
set(img1_lyrs,'String',data_init.e*1000)

%load image data into img_lyrs guidata and load color specs into UserData
set(h1,'UserData', data_init);
set(img1_lyrs,'UserData',colors_init);
plot_img1_Callback

% %%%%%%%%%%%%%%%%%%%%%% CALLBACK FUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     function update_panel_sel_Callback(hObject,eventdata)
%         r = get(row_sel,'Value');
%         c = get(col_sel,'Value');
%         panels = 1:(r*c); panels = panels';
%         set(panel_sel,'String',num2str(panels));        
%     end

    function open_dir_Callback(hObject, evendata)
        exp_directory = uigetdir('C:\Users\chong\Documents\MATLAB\STMdata\MoTeSe');
        set(dir_entry,'String',exp_directory);
    end

    function load_gui_data_Callback(hObject,eventdata)
        obj_handles = find_obj_gui(h1);
        if isempty(obj_handles)
            set(obj_sel,'String','[empty]')
            set(obj_sel,'Value',1);
            axes(img1_axes);
            imagesc([0 0 ; 0 0]);
            axis off; axis equal;
            return;
        end
        for j = 1:length(obj_handles)
            struct_names{j} = get(obj_handles(j),'Name');
        end
        %assign the the handles of the open GUIs to the obj_sel object
        set(obj_sel,'UserData',obj_handles);  
        set(obj_sel,'String',struct_names);
        set(obj_sel,'Value',1);                
    end

    function plot_img1_Callback(hObject,eventdata)
        %colormap(Cmap);
        data = get(h1,'UserData')
        colors = get(img1_lyrs,'UserData');
        layer = get(img1_lyrs,'Value');
        axes(img1_axes);
        imagesc((data.map(:,:,layer)));
        colormap(colors.cmap);
        caxis(colors.bnd(layer,:));
        axis off; axis equal; shading flat;
        
    end

    function load_img_Callback(hObject,eventdata)
        %get the new handle for the selected image object
        selection = get(obj_sel,'Value');
        obj_handles = get(obj_sel,'UserData');
        sel_obj_handle = obj_handles(selection);
        %retrieve data and color information from image object
        data = guidata(sel_obj_handle);
        colors.bnd = get(sel_obj_handle,'UserData');
        colors.cmap = colormap(sel_obj_handle);
        %load it into the img1_lyrs guidata and UserData
        set(h1,'UserData',data);
        set(img1_lyrs,'UserData',colors);
        
        set(img1_lyrs,'String',data.e*1000);
        set(img1_lyrs,'Value',1);
        axes(img1_axes);
        imagesc(data.map(:,:,1));
        colormap(colors.cmap);
        caxis(colors.bnd(1,:));
        axis off, axis equal; shading flat;
        
    end

    function sel_data_Callback(hObject,eventdata)
        panel_n = get(panel_sel,'Value');
        data = get(h1,'UserData')
        colors = get(img1_lyrs,'UserData');
        data_name = [data.name '-' data.var];
        str = get(panel_choices,'String');
        str{panel_n} = data_name;
        set(panel_choices,'String',str);
        fdata;
        eval(['fdata.map' num2str(panel_n) '= data.map']);
        eval(['fdata.e' num2str(panel_n) '= data.e*1000']);
        eval(['fdata.e' num2str(panel_n) '= data.e*1000']);
        eval(['fdata.clmap' num2str(panel_n) '= colors.cmap']);
        eval(['fdata.clbnd' num2str(panel_n) '= colors.bnd']);        
    end

    function done_Callback(hObject,eventdata)
        delete(h1)
    end

    function export_Callback(hObject,eventdata)
        %                 frps = str2num(get(fps_set,'String'));
        %         directory = get(dir_entry,'String');
        %         filename = get(filename_entry,'String');
        %         quality = str2num(get(quality_set,'String'));
        %         n_row = get(row_sel,'Value');
        %         n_col = get(col_sel,'Value');
        frps = 10;
        directory = get(dir_entry,'String');
        filename = 'autotest';
        quality = 75;
        n_row = 1;
        n_col = 2;
        if directory(end) ~= '\'
            directory =  strcat(directory,'\');
        end
        if isempty(filename)
            set(filename_entry,'String','Please Enter a File Name')
            return;
        else                       
            exp_movie_multipanel(fdata,n_row,n_col,directory,filename,frps,quality);
        end
    end


end
