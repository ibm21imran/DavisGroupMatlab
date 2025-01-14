function FFT=load_map_qpi(location,nmethod,fmethod,smethod,cmethod,lx,ly,rx,ry)
% location = path where the conductance, current and topograph are stored
% nmethod = choose a normalization method: 'first' <=> divide every layer of
% the conductance map by the first layer of the current map
% 'feenstra' <=> divide every layer of the conductance map by the
% corresponding layer of the current map;
% '' <=> don't normalize
% fmethod = filter data: 'core' <=> Gauss filter map before FFT, 
% 'smooth' <=> Gauss filter aftr FFT
% '' <=> do not filter
% smethod = symmetrize data: string can contain three letters v (vertical),
% h (horizontal), d (diagonal), so 'v', 'vh', 'vhd' and so on; if '' no
% symmetrization is applied
% cmethod = correct for drift, if '' do nothing, else use coordinates of
% two Bragg peaks lx,ly,rx,ry to correct.
%% load maps
% load C:\Users\Peter\Desktop\Cornell_PhD\Data\NaFeCoAs_data\May_2013\05_01_13\NaFeAs30501A00.mat
qpi_data = importdata(location);
names = fieldnames(qpi_data);

%% Assign the conductance map to G, the current map to I, and the topograph
%% to T
G = getfield(qpi_data,names{1,1});
I = getfield(qpi_data,names{2,1});
T = getfield(qpi_data,names{3,1});

%% Two ways of normalization to accommodate for the set-up effect
if strcmp(nmethod,'first')==1
    %% 1.) Divide every layer in the conductance map by the first layer of the
    %% current map
    g=current_divide2(G,I);
    % subtract the constant background
    g = polyn_subtract2(g,0);
    % Gauss filter on conductance map <=> core subtraction

elseif strcmp(nmethod,'feenstra')==1
    %% 2.) Feenstra, divide every layer in the conductance map by the
    %% corresponding layer in the current map
    g=G;
    Imap = I.map;
    % zero_energy = find(g.e == 0);
    % zero_energy = 1;
    %current_offset = mean(mean(Imap(:,:,zero_energy)));
    current_offset = 0;
    for i = 1:length(g.e)
     %   Imap(:,:,i) = Imap(:,:,i) - Imap(:,:,zero_energy);
        g.map(:,:,i) = g.map(:,:,i)./Imap(:,:,1);
    end

    % subtract the constant background
    g = polyn_subtract2(g,0);
    
else
    g=G;
    g = polyn_subtract2(g,0);
end

%% Filter data before or after Fourier-Transform
if strcmp(fmethod,'core')==1
% Gauss filter on conductance map <=> core subtraction

    Gfilt = gauss_filter_image(g,9,3);

    FFT = fourier_transform2d(Gfilt,'none','amplitude', 'ft');
    
elseif strcmp(fmethod,'smooth')==1
        FFT = fourier_transform2d(g,'none','amplitude', 'ft');
    % Gauss filter of Fourier transform

        Ffilt = gauss_filter_image(F,9,3);
        
else
    FFT = fourier_transform2d(g,'none','amplitude', 'ft');
end

%% Correct for possible drift and symmetrize the Fourier Transform
if strcmp(cmethod,'')==1
else
    map = linear2D_image_correct([lx ly],[rx ry],FFT.map);
    FFT.map = map;
end


if strcmp(smethod,'')==1
    img_obj_viewer2(FFT);
else
    FFT=symmetrize_image_v2(FFT,smethod);
    img_obj_viewer2(FFT);
end

% clear  mapfilt mapfiltF map


end