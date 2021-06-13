% 2020/4/24 YXC
% in use with register_lattice_gui

function Cropchoice= alternate_crop_dialogue(nx1,nx2)

col = [0.8 0.8 0.8];
Cropchoice = zeros(2,4);


fh = figure('Name', 'Change Pixel Dimensions',...
    'units','normalized', ...
    'Position',[0.3,0.3,0.3,0.2],...
    'Color',col,...
    'MenuBar', 'none',...
    'NumberTitle', 'off',...
    'Resize','off');

%%

uicontrol(fh,'Style','text','String','Left Map Corners',...
    'units','normalized','BackgroundColor',col,...
    'Position', [0.1 0.75 0.3 0.1]);


%% map1 point1
uicontrol(fh,'Style','text','String','x1','units','normalized',...
    'BackgroundColor',col,'Position', [0.1 0.6 0.1 0.1]);
uicontrol(fh,'Style','text','String','y1',...
    'units','normalized','BackgroundColor',col,...
    'Position', [0.1 0.5 0.1 0.1]);
map1x1 = uicontrol(fh,'Style','edit','String','1',...
    'units','normalized','BackgroundColor',col,...
    'Position', [0.17 0.6 0.08 0.1]);
map1y1 = uicontrol(fh,'Style','edit',...
    'String','1','units','normalized',...
    'BackgroundColor',col,'Position', [0.17 0.5 0.08 0.1]);

%% map1 point2
uicontrol(fh,'Style','text',...
    'String','x2',...
    'units','normalized',...
    'BackgroundColor',col,...
    'Position', [0.2 0.4 0.1 0.1]);
uicontrol(fh,'Style','text',...
    'String','y2',...
    'units','normalized',...
    'BackgroundColor',col,...
    'Position', [0.2 0.3 0.1 0.1]);
map1x2 = uicontrol(fh,'Style','edit',...
    'String',num2str(nx1),...
    'units','normalized',...
    'BackgroundColor',col,...
    'Position', [0.27 0.4 0.08 0.1]);
map1y2 = uicontrol(fh,'Style','edit',...
    'String',num2str(nx1),...
    'units','normalized',...
    'BackgroundColor',col,...
    'Position', [0.27 0.3 0.08 0.1]);
%%
uicontrol(fh,'Style','text',...
    'String','Right Map Corners',...
    'units','normalized',...
    'BackgroundColor',col,...
    'Position', [0.4 0.75 0.3 0.1]);

%% map2point1


uicontrol(fh,'Style','text','String','x1','units','normalized',...
    'BackgroundColor',col,'Position', [0.1 0.6 0.1 0.1]);
uicontrol(fh,'Style','text','String','y1',...
    'units','normalized','BackgroundColor',col,...
    'Position', [0.5 0.5 0.1 0.1]);
map2x1 = uicontrol(fh,'Style','edit','String','1',...
    'units','normalized','BackgroundColor',col,...
    'Position', [0.57 0.6 0.08 0.1]);
map2y1 = uicontrol(fh,'Style','edit',...
    'String','1','units','normalized',...
    'BackgroundColor',col,'Position', [0.57 0.5 0.08 0.1]);

%%  map2 point2
uicontrol(fh,'Style','text',...
    'String','x2',...
    'units','normalized',...
    'BackgroundColor',col,...
    'Position', [0.6 0.4 0.1 0.1]);
uicontrol(fh,'Style','text',...
    'String','y2',...
    'units','normalized',...
    'BackgroundColor',col,...
    'Position', [0.6 0.3 0.1 0.1]);
map2x2 = uicontrol(fh,'Style','edit',...
    'String',num2str(nx2),...
    'units','normalized',...
    'BackgroundColor',col,...
    'Position', [0.67 0.4 0.08 0.1]);
map2y2 = uicontrol(fh,'Style','edit',...
    'String',num2str(nx2),...
    'units','normalized',...
    'BackgroundColor',col,...
    'Position', [0.67 0.3 0.08 0.1]);

uicontrol(fh,'Style','text',...
    'String','Right Map Corners',...
    'units','normalized',...
    'BackgroundColor',col,...
    'Position', [0.4 0.75 0.3 0.1]);



%%
    
   
OK_but = uicontrol(fh,'Style','pushbutton',...
                          'String','OK',...
                          'units','normalized',...
                          'Position',[0.8 0.5 0.14 0.3],...
                          'Callback',(@OK_Callback));
cancel_but = uicontrol(fh,'Style','pushbutton',...
                          'String','Cancel',...
                          'units','normalized',...
                          'Position',[0.8 0.1 0.14 0.3],...
                          'Callback',(@cancel_Callback));
%%%%%%%%%%%CALLBACK FUNCTIONS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
uiwait(gcf); 
%halt execution of STM_View until this function returns a file to open

function OK_Callback(hObject,eventdata)
   Cropchoice(1,1)= str2double(get(map1x1,'String'));
   Cropchoice(1,2)= str2double(get(map1y1,'String'));
   Cropchoice(1,3)= str2double(get(map1x2,'String'));
   Cropchoice(1,4)= str2double(get(map1y2,'String'));
   Cropchoice(2,1)= str2double(get(map2x1,'String'));
   Cropchoice(2,2)= str2double(get(map2y1,'String'));
   Cropchoice(2,3)= str2double(get(map2x2,'String'));
   Cropchoice(2,4)= str2double(get(map2y2,'String'));
   close(fh);
end
    function cancel_Callback(hObject,eventdata)

        close(fh);
    end
end

    