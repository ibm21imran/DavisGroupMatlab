function [gmaps,Rmap] = BSCCO_gap_map(data,slope_thr,fit_width,smooth_width,amp_thr,...
                                start_energy_ind,end_energy_ind,...
                                map_optn,dbl_pk_optn,dbl_pk_percent,pk_rng_optn,bad_px_optn)

gmaps = [];
Rmap = [];
[nr nc nz] = size(data.map);


x = 1000*data.e(start_energy_ind:end_energy_ind);
map = data.map(:,:,start_energy_ind:end_energy_ind);
x1 = 0; x2 = 0;
pos_optn = 0; neg_optn = 0; %switches to evaluate pos and neg maps
% map calculation options - NEGATIVE DELTA & POSITIVE DELTA
if map_optn(2) == 1 || map_optn(1) == 1 % yes to positive map
    x1 = x(x > 0);
    if ~isempty(x1)
        map1 = map(:,:,(x>0));
        pos_optn = 1;
        gap_map1 = zeros(nr,nc); %positive gap
    else
        display('No Positive Side to Find Gap in Specified Energy Range');
        return;
    end
else
    map1 = zeros(1,1,1);
    gap_map1 = 0;
end
if map_optn(3) == 1 || map_optn(1) == 1% yes to negative map
    x2 = x(x < 0);
    if ~isempty(x2)
        map2 = map(:,:,(x<0));
        neg_optn = 1;
        gap_map2 = zeros(nr,nc); %negative gap
    else
        display('No Negative Side to Find Gap in Specified Energy Range');
        return;
    end
else
    map2 = zeros(1,1,1);
    gap_map2 = 0;
end

% rearrange spectrum starting from small to big energies
if x(1) > x(end)
    x1 = x1(end:-1:1);
    map1 = map1(:,:,end:-1:1);
    x2 = x2(end:-1:1);
    map2 = map2(:,:,end:-1:1);
end

% index the location of double peaks - potentially useful
count1 = 0; count2 = 0;
dp_index1 = [0 0]; dp_index2 = [0 0];

h = waitbar(0,'Please wait...','Name','Gap Map Progress');
[nr1] = size(map1,1);
[nr2] = size(map2,1);

% matlabpool(2);
for i = 1:nr 
    map1_rdx = squeeze(map1(min(i,nr1),:,:));
    map2_rdx = squeeze(map2(min(i,nr2),:,:));
    for j = 1:nc           
        if pos_optn == 1
            %find +ve edge
            y1 = squeeze(squeeze(map1_rdx(j,1:end)))'; 
           % peaks1 = findpeaks_3(x1,y1,slope_thr,amp_thr,fit_width,smooth_width); 
%            peaks1 = findpeaks_3(x1,y1,slope_thr,amp_thr,smooth_width,fit_width);
            [peaks1,R] = findpeaks_3_edit(x1,y1,slope_thr,amp_thr,smooth_width,fit_width);
%             R=1;
            % pick out largest height peaks as the gap edge subject to other
            % contraints.  If equal height peaks are found, and dbl_peak
            % option is not selected then take the peak furthest away from 0V.          
            gap_map1(i,j) =  max(peaks1(peaks1(:,3) == max(peaks1(:,3)),2));
            Rmap(i,j) = R;
               
            % if no peak is found, then this option sets the gap value to value
            % at which the spectrum attains its maximum value
            if pk_rng_optn
                if peaks1(1,1) == 0 %no peak found
                    gap_map1(i,j) = max(x1(y1 == max(y1))); 
                    Rmap(i,j) = 0;
                end                            
            end
        
            %if the max height peaks is within 10% of the next highest peak,
            %then set the gap value to 0, the error value.

            if  dbl_pk_optn 
                if (size(peaks1,1) > 1)
                    sort_peaks = sort(peaks1(:,3),'descend');
                    if (((sort_peaks(1) - sort_peaks(2))/sort_peaks(1)) < dbl_pk_percent)
                        gap_map1(i,j) = 0;   
                        Rmap(i,j) = 0;
                       % count1 = count1 + 1;
                       % dp_index1(count1,1) = i; dp_index1(count1,2) = j;
                    end            
                end
            end
        end
        
        if neg_optn == 1        
            %find -ve edge
            y2 = squeeze(squeeze(map2_rdx(j,1:end)))';                
            [peaks2,R] = findpeaks_3_edit(x2,y2,slope_thr,amp_thr,smooth_width,fit_width); 
            
            % pick out largest height peaks as the gap edge subject to other
            % contraints.  If equal height peaks are found, and dbl_peak
            % option is not selected then take the peak furthest away from 0V.
            gap_map2(i,j) =  min(peaks2(peaks2(:,3) == max(peaks2(:,3)),2)); 
            Rmap(i,j) = R;
            % if no peak is found, then this option sets the gap value to value
            % at which the spectrum attains its maximum value
            if pk_rng_optn                          
                if peaks2(1,1) == 0 %no peak found
                    gap_map2(i,j) = max(x2(y2 == max(y2)));  
                    Rmap(i,j) = 0;
                end                
            end

            %if the max height peaks is within 10% of the next highest peak,
            %then set the gap value to 0, the error value.       
            if  dbl_pk_optn             
                if (size(peaks2,1) > 1)
                    sort_peaks = sort(peaks2(:,3),'descend');
                    if (((sort_peaks(1) - sort_peaks(2))/sort_peaks(1)) < dbl_pk_percent)
                        gap_map2(i,j) = 0;
                        Rmap(i,j) = 0;
                      %  count2 = count2 + 1;
                       % dp_index2(count2,1) = i; dp_index2(count2,2) = j;                
                    end            
                end             
            end    
        end
    end
    waitbar(i / nr,h,[num2str(i/nr*100) '%']);    
end
close(h);
% matlabpool close;

%if both +ve and -ve maps are generated make make sure the the double peak 
%rejection sets pixels in both maps to zeros where a double peak is found
%in either map
if (dbl_pk_optn && map_optn(2) && map_optn(3)) || (dbl_pk_optn && map_optn(1)) 
    for i = 1:count2
        gap_map1(dp_index2(i,1),dp_index2(i,2)) = 0;
        Rmap(i,j) = 0;
    end
    for i = 1:count1
        gap_map2(dp_index1(i,1),dp_index1(i,2)) = 0;
        Rmap(i,j) = 0;
    end
end

gmaps.pos = gap_map1; gmaps.neg = gap_map2; gmaps.avg = 0;
% average map option
if map_optn(1) == 1
    gap_map_avg = (abs(gap_map1) + abs(gap_map2))/2;  
    gmaps.avg = gap_map_avg;
   
end

 load_color
 img_plot2(gap_map1,Cmap.Defect1,'BSCCO Gap Map +ve');
% img_plot2(gap_map2,Cmap.Defect1,'BSCCO Gap Map -ve');
end
