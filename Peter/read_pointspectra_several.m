function speccell =  read_pointspectra_several
    % NOTE: will have to make modification if only one of fwd/bkwd data
    % exists
    
    % conversion to volt
    %w_factor = 8.89233e-5;    
    %w_zero =-2.75;
    w_zero = -10;
    w_factor = 20/2^16; 
    %w_zero = -10;
    %prompt for file selection - current(DI1) or conductance(DI2) - STM2
%     [filename,pathname] = uigetfile({'*.DI1;*.DI2','MATLAB Files (*.DI1,*.DI2)'},...
%                                      'Select Spectra Data File(*.DI1, *DI2)');%,...
%                                      %'C:\Data\stm data\');
    %prompt for file selection - current(DIC) or conductance(DI1) - STM1
    qstring = 1;
    cc = 1;
    
    while qstring == 1
    
        [filename,pathname] = uigetfile({'*.DIC;*.DI1','MATLAB Files (*.DIC,*.DI1)'},...
                                         'Select Spectra Data File(*.DIC, *DI1)');%,...
                                         %'C:\Data\stm data\');

        cd (pathname);
        fid = fopen(filename,'r');
        raw_data = fread(fid,'float');
        a = raw_data;
        %length(raw_data)
        fclose(fid);    
        % parse out energy information in mV
        v = raw_data(1:2:end);
        v = v(265:end); 
        energy = v(1:length(v)/2);
        energy = energy*1000;
        
        %% 07/27/2016 P.O.S. add offset in mV - has to be always manually 
        %% changed, set it to 0 by deafult
        
        offset = 0.0;
        energy = energy + offset;
        
        %%

        %parse out current/conductance data
        data=raw_data(2:2:end);
        data=data(265:end);


    %%  060213 Changed by Peter Sprau (no multiplication with w_factor and
    %%  addition of w_zero
        %data taken in the forward(fwd), backward(bkwd) directions
        fwd = data(1:length(data)/2);   
    %     fwd = fwd*w_factor + w_zero;
        bkwd = data(length(data)/2+1:end); 
    %     bkwd = bkwd*w_factor + w_zero;
    %%        
        %always write data variables with the first elements always being at the most
        %negative energies
    %     if energy(1) < energy(end)
    %         tmp = fwd(end:-1:1); fwd = tmp;
    %         tmp = bkwd(end:-1:1); bkwd = tmp;
    %     else
    %         tmp = energy(end:-1:1); energy = tmp;
    %     end
        avg = (fwd + bkwd)/2; % average of directional spectra    
        
        %% 07/27/2016 P.O.S. - normalize to maximum of spectrum in order 
        %% to clarify comparison, comment out if not needed
        
%         avg = avg / max(avg);

        %%
        
        data_out.fwd = fwd; 
        data_out.bkwd = bkwd; 
        data_out.avg = avg; 
        data_out.energy = energy;
        data_out.name = filename(1:end-4);
%         assignin('base','S',data_out);
    
        speccell{cc} = data_out;
        cc = cc+1;
        clear data_out
        
        
        
        button = questdlg('Add another spectrum? ',...
        'Your reply','Yes','No','Cancel','No');

        if strcmp(button,'Yes')==1
            qstring = 1;
        else
            qstring = 0;
        end
    
        
        
    end
    
    data_out = speccell{1};
    energy = data_out.energy;
    avg = data_out.avg;
    
    ev = energy;
    av = avg;
    
    name = data_out.name;
    lstring{1} = name;
    
    figure;
    plot(energy,avg,'Color','b','LineStyle','-','Marker','.','linewidth',2);
    xlabel('V [mV]','fontsize',16,'fontweight','b')
    if strcmp(filename(end-2:end),'DI1')==1
        ylabel('dI/dV [nS]','fontsize',16,'fontweight','b')
    elseif strcmp(filename(end-2:end),'DIC')==1
        ylabel('I [nA]','fontsize',16,'fontweight','b')
    end
    hold on
    for i=2:length(speccell)
        data_out = speccell{i};
        name = data_out.name;
        energy = data_out.energy;
        avg = data_out.avg;
        ev = [ev;energy];
        av = [av;avg]; 
        lstring{i} = name;
        cstring = {'k','r','c','m','y','g'};
        dum0 = mod(i-1,6);
        if dum0 == 0
            cs = cstring{6};
        else
            cs = cstring{dum0};
        end
        
        plot(energy,avg,'Color',cs,'LineStyle','-','Marker','.','linewidth',2);
    end
    hold off
    axis([min(ev) max(ev) min(av) max(av)])
    legend(lstring);

end

