function copy_wrkspc_data_dialogue(current_obj_handle)
fh = figure('Name','Copy Workspace Items to Data Object',...
              'NumberTitle', 'off',...                            
              'Position',[150,150,350,400],...
              'MenuBar', 'none',...
              'Resize','off');    

data_names = evalin('base','who');         
count = 0;
for i = 1:length(data_names)
    if evalin('base',['isstruct(' data_names{i} ')' ])
        count = count + 1;
        struct_names{count} = data_names{i};
    end
end
                         

current_obj = guidata(current_obj_handle);
fields_current_obj = fieldnames(current_obj);

          
copy_variables = uicontrol('Parent',fh,'units','normalized',...
                       'Style','popupmenu',...
                       'String',['Variables to Copy'; data_names],...
                       'Value', 1,...
                       'Position',[0.05 0.86,0.4 0.08],...
                       'Callback',@change_obj_Callback);

copy_variables_fields = uicontrol('Parent',fh,'units','normalized',...
                      'Style','listbox',...
                      'Position',[0.05 0.15 0.4 0.7],...
                      'String','',...
                      'Min',1,'Max',1000);

current_struct = uicontrol('Parent',fh,'units','normalized',...
                       'Style','text',...
                       'String',['Copy to ' get(current_obj_handle,'Name')],...
                       'Position',[0.55 0.86,0.4 0.04]);
                  
current_struct_fields = uicontrol('Parent',fh,'units','normalized',...
                      'Style','listbox',...
                      'Position',[0.55 0.15 0.4 0.7],...
                      'String',fields_current_obj,...
                      'Min',1,'Max',1000);

copy_but = uicontrol('Parent',fh,'units','normalized',...
                   'Style','pushbutton',...
                   'String','Copy',...
                   'Position',[0.33 0.05 0.15 0.05],...
                   'Callback',@copy_Callback);
close_but = uicontrol('Parent',fh,'units','normalized',...
                   'Style','pushbutton',...
                   'String','Close',...
                   'Position',[0.52 0.05 0.15 0.05],...
                   'Callback',@close_Callback);

%%%%%%%%%%%%%%%%%%%%%%%%CALLBACK FUNCTIONS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
function copy_Callback(hObject,eventdata)
     n_var = get(copy_variables,'Value');
     
     % if title  position do nothing
     if n_var == 1
         return;
     else
         % check to see if chosen variable is a structure - if so see which
         % fields are chosen and only copy fields
         var_name = get(copy_variables,'String');
         if evalin('base',['isstruct(' var_name{n_var} ')']);
             field_name = get(copy_variables_fields,'String');
             n_field = get(copy_variables_fields,'Value');
             tmp_struct = guidata(current_obj_handle);
             for i = 1:length(n_field)
                 field_copy = evalin('base',[var_name{n_var} '.' field_name{n_field(i)}]);
                 eval(['tmp_struct.' field_name{n_field(i)} ' = field_copy']);                 
             end
         else
             tmp_struct = guidata(current_obj_handle);
             field_copy = evalin('base',var_name{n_var});
             eval(['tmp_struct.' var_name{n_var} ' = field_copy']);
         end
     end
     guidata(current_obj_handle,tmp_struct);
     current_obj = guidata(current_obj_handle);
     fields_current_obj = fieldnames(current_obj);
     set(current_struct_fields,'String',fields_current_obj);
end

function change_obj_Callback(hObject,eventdata)
    n = get(copy_variables,'Value');
    n = n - 1;
    if n == 0
        set(copy_variables_fields,'String','');    
    else
        var_name = get(copy_variables,'String')
        var_name{n}
        if evalin('base',['isstruct(' var_name{n+1} ')'])            
            var_fields = evalin('base',['fieldnames(' var_name{n+1} ')'])
            set(copy_variables_fields,'String',var_fields);
        else
            set(copy_variables_fields,'String','');
        end
    end
end
function close_Callback(hObject,eventdata)
    close(fh);
end

end