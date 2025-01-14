function histogram_dialogue(map_lin,caxis_min,caxis_max,axis_handle)

fh=figure('Name', 'Histogram',...
        'units','normalized', ...
        'Position',[0.3,0.3,0.35,0.45],...
        'Color',[0.6 0.6 0.6],...
        'MenuBar', 'none');
  
 axis off;
%%%%%%%%%%%%%%%%%%%%%%%%%%%GUI Controls%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
mini_edit = uicontrol(fh,'Style','Edit',...
                'String',num2str(caxis_min),...
                'units','centimeter',...
                'Position',[1 1 2 1]);
            
maxi_edit = uicontrol(fh,'Style','Edit',...
                'String',num2str(caxis_max),...
                'units','centimeter',...
                'Position',[3.5 1 2 1]);
            
min_label = uicontrol(fh,'Style','text',...
                        'String','Minimum',...
                        'units','centimeter',...
                        'Position',[1 0.3 2 0.4]);

max_label = uicontrol(fh,'Style','text',...
                         'String','Maximum',...
                         'units','centimeter',...
                         'Position',[3.5 0.3 2 0.4]);

hist_axis = axes('Parent',fh,...
                 'units','normalized',...
                 'Position',[0.15 0.27 0.7 0.65]);
             
                  set(get(hist_axis,'XLabel'),'String','Value');
                  set(get(hist_axis,'YLabel'),'String','% Occurrence');
                 
            
            
zoom_but = uicontrol(fh,'Style','pushbutton',...
                          'String','Zoom Selection',...
                          'units','centimeter',...
                          'Position',[6 1 2.5 1],...
                          'Callback',(@zoom_Callback));
                        
                      
revert_but = uicontrol(fh,'Style','pushbutton',...
                          'String','Revert',...
                          'units','centimeter',...
                          'Position',[9 1 2.5 1],...
                          'Callback',{@revert_Callback,caxis_min,caxis_max});
                      
accept_but = uicontrol(fh,'Style','pushbutton',...
                          'String','Accept',...
                          'units','centimeter',...
                          'Position',[12 1 2.5 1],...
                          'Callback',(@accept_Callback));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nbins = 1000;
[n x] = hist(map_lin,nbins);
bar(x,n./sum(n),1);
xlim([caxis_min caxis_max]);
          set(get(hist_axis,'XLabel'),'String','Value');
                  set(get(hist_axis,'YLabel'),'String','% Occurrence');
            
%%%%%%%%%%%%%%%%%%%%%%%%%Callback Functions%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function revert_Callback(hObject,evendata,caxis_min,caxis_max)
        set(hist_axis,'XLim',[caxis_min caxis_max]);
        set(mini_edit,'String',num2str(caxis_min));
        set(maxi_edit,'String',num2str(caxis_max));
        set(axis_handle,'CLim',[caxis_min caxis_max]);
    end

    function zoom_Callback(hObject,evendata)
        a = str2double(get(mini_edit,'String'));
        b = str2double(get(maxi_edit,'String'));
        set(hist_axis,'XLim',[a b]);
    end

    function accept_Callback(hObject,evendata)
        a = str2double(get(mini_edit,'String'));
        b = str2double(get(maxi_edit,'String'));
        set(axis_handle,'CLim',[a b]);
    end
end