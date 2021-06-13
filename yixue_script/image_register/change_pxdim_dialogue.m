% 2020/4/24 YXC
% in use with register_lattice_gui

function [newdimleft,newdimright]= change_pxdim_dialogue(dimleft,dimright)

col = [0.8 0.8 0.8];

fh = figure('Name', 'Change Pixel Dimensions',...
    'units','normalized', ...
    'Position',[0.3,0.3,0.2,0.1],...
    'Color',col,...
    'MenuBar', 'none',...
    'NumberTitle', 'off',...
    'Resize','off');

uicontrol(fh,'Style', 'text',...
    'units','normalized',...
    'String', 'Original Dimensions:',...
    'BackgroundColor',col,...
    'Position', [0.1 0.7 0.5 0.2]);

uicontrol(fh,'Style', 'text',...
    'units','normalized',...
    'String', strcat('left: ',num2str(dimleft)),...
    'Position', [0.1 0.4 0.2 0.2]);
uicontrol(fh,'Style', 'text',...
    'units','normalized',...
    'String', strcat('right: ',num2str(dimright)),...
    'Position', [0.4 0.4 0.2 0.2]);

uicontrol(fh,'Style', 'text',...
    'units','normalized',...
    'String', 'New Dimensions:',...
    'BackgroundColor',col,...
    'Position', [0.1 0.25 0.5 0.2]);

editleft= uicontrol(fh,'Style', 'edit',...
    'units','normalized',...
    'String', num2str(dimleft),...
    'Position', [0.1 0.1 0.2 0.2]);
editright= uicontrol(fh,'Style', 'edit',...
    'units','normalized',...
    'String', num2str(dimright),...
    'Position', [0.4 0.1 0.2 0.2]);

    
   
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
   newdimleft = round(str2double(get(editleft,'String')));
   newdimright = round(str2double(get(editright,'String')));
   close(fh);
end
    function cancel_Callback(hObject,eventdata)
        newdimleft = dimleft;
        newdimright = dimright;
        close(fh);
    end
end

    