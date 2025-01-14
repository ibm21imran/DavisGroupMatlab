function  shostat = gapmap_shoulder_initialize(spec,ev,minidd,extdd,specdd,evdd,shoind,shostatold)
%gapmap_shoulder_select - takes the maxima determined by
%gapmap_maxima_minima for the first derivative, and uses them to find the
%shoulders in a spectrum that seem significant based on the following
%criteria: the difference between the slopes before and after the possible
%shoulder position. The slope is determined using y = mx, m = (y2-y1)/(x2-x1)
%, where the y2, y1, x2, x1 values are determined using the maximum and the closest
%minimum in the first derivative, with the value halfway between them is
%the possible shoulder location. Fruthermore it is used whether the
%spectrum at the possible shoulder location is a kink in or outwards, only
%outward ones will be chosen as shoulders / if the function is concave vs convex.
%For that two empirical values were chosen as threshold; if both are above
%threshold the shoulder is deemed significant.
% sigsho - array with energy values of significant shoulders
% spec - spectrum
% ev - energy values of spectrum

% minidd - energy values of minima in second derivative, position of
% possible shoulders
% extdd - energy values of minima and maxima in second derivative, the two
% closest extrema to a minimum mark the limits in which the properties of
% the shoulder are tested
% dum# - dummy variables that are used

% number of shoulders to be tested
lsho = length(shoind);

% counter variables
tc = 1;
if isempty(shostatold)
    t2c = 1;
else
    t2c = length(shostatold.angle)+1;
    shostat.angle = shostatold.angle;
    shostat.area = shostatold.area;
end


% sort the possible shoulder locations so that search for significant 
% maxima gets started at the values closest to chemical pot.
if mean(ev) < 0
    shoind = sort(shoind,'descend');
else
    shoind = sort(shoind,'ascend');
end

% figure, plot(ev,spec,'k.-',evdd,specdd,'m.-')


    
for i=1:lsho
    %% find indices, energy values and values of the maximum that is
    %% tested and the closest minimum at lower energies
    
    % find the index of the position of the shoulder to be tested
    dum0ind = find(shoind(i) == ev);
%     dum0indd = find(minidd(i) == evdd);
    
    % find the value of the current minimum in the second derivative
    minsl(tc) = specdd( dum0ind );
    
    % find all extrema to the left / lower energies
    dum1 = extdd - shoind(i);
    dum2 = find(dum1 < 0 );
    
    % find the extremum that is closest in energy to the minimum, but at
    % lower energies; determine indices and energyvalues, if there is no
    % extremum to the left, take the first value of the second derivative
    if isempty(dum2)==1
        extsl(tc) = specdd(1);
%         dum4 = evdd(1);
        dum4 = ev(1);
        dum4ind = 1;
    else
        [dum3, clexts(tc)] = min(abs(extdd(dum2(1):dum2(end)) - shoind(i)));
    
        dum4 = extdd(clexts(tc));
    
%         dum4ind = find(dum4 == evdd);
        dum4ind = find(dum4 == ev);
        extsl(tc) = specdd(dum4ind);
    end
        
    %% find indices, energy values and values of the maximum that is
    %% tested and the closest minimum at higher energies
    % find all minima to the right / higher energies
    dum5 = extdd - shoind(i);
    dum6 = find(dum5 > 0 );
    
    % find the extremum that is closest in energy to the minimum, but at
    % higher energies; determine indices and energyvalues, if there is no
    % extremum to the right, take the last value of the second derivative
    if isempty(dum6)==1
        extsl2(tc) = specdd(end);
%         dum8 = evdd(end);
%         dum8ind = length(evdd);
        dum8 = ev(end);
        dum8ind = length(ev);
    else
        [dum7, clexts2(tc)] = min(abs(extdd(dum6(1):dum6(end)) - shoind(i)));
    
        dum8 = extdd(dum6(1)-1+clexts2(tc));
    
%         dum8ind = find(dum8 == evdd);
        dum8ind = find(dum8 == ev);
        extsl2(tc) = specdd(dum8ind);
    end
    
   %%
%     figure, plot(ev,spec,'k.-',evdd,specdd,'m.-')
%     line([shoind(i) shoind(i)],[-1 1],'LineWidth',2,'Color','g');
%     line([dum4 dum4],[-1 1],'LineWidth',2,'Color','b');
%     line([dum8 dum8],[-1 1],'LineWidth',2,'Color','r');
    
    %% Caluclate the values for the criteria used to determine whether a
    %% shoulder is significant
    
    % dum13 and dum14 are the slopes that are generated by taking the
    % shoulder position, and the position of the two closest extrema in the
    % second derivative as start and ending points for a linear equation 
    % y = mx+b; if the shoulder is significant there should be a big change
    % in the slope m.
    dum13 = (spec(dum0ind) - spec(dum4ind))* max(abs(ev(dum4ind:dum0ind))) / (((ev(dum0ind) - ev(dum4ind))) * max(abs(spec(dum4ind:dum0ind))) );
    gamma1 = atan((spec(dum0ind) - spec(dum4ind))* max(abs(ev(dum4ind:dum0ind))) / (((ev(dum0ind) - ev(dum4ind))) * max(abs(spec(dum4ind:dum0ind))) )) * 180 /pi;
    dum14 = (spec(dum8ind) - spec(dum0ind))* max(abs(ev(dum0ind:dum8ind))) / (((ev(dum8ind) - ev(dum0ind))) * max(abs(spec(dum0ind:dum8ind))) );
    gamma2 = atan((spec(dum8ind) - spec(dum0ind))* max(abs(ev(dum0ind:dum8ind))) / (((ev(dum8ind) - ev(dum0ind))) * max(abs(spec(dum0ind:dum8ind))) )) * 180/pi;
%     line([dum4 shoind(i)],[spec(dum4ind) spec(dum0ind)],'LineWidth',2,'Color','y');
%     line([shoind(i) dum8],[spec(dum0ind) spec(dum8ind)],'LineWidth',2,'Color','c');
    
    
    vecsl1 = [(ev(dum0ind) - ev(dum4ind))/ max(abs(ev(dum4ind:dum0ind))), (spec(dum0ind) - spec(dum4ind)) / max(abs(spec(dum4ind:dum0ind)))];
    vecsl1 = vecsl1 / sqrt(vecsl1 * vecsl1');
    vecsl2 = [(ev(dum8ind) - ev(dum0ind))/ max(abs(ev(dum0ind:dum8ind))), (spec(dum8ind) - spec(dum0ind)) / max(abs(spec(dum0ind:dum8ind)))];
    vecsl2 = vecsl2 / sqrt(vecsl2 * vecsl2');
    
%     figure, compass(vecsl1(1),vecsl1(2),'y');
%     hold on
%     compass(vecsl2(1),vecsl2(2),'c');
%     hold off
    
    alpha(tc) = acos( vecsl1 * vecsl2');
    alpha(tc) = alpha(tc) * 180 / pi;

    test = 1;
    
    % calculate the area under the curve for the linearized approximation
    % y=mx+b (start and endpoint are now the two closest extrema to the minima
    % in the second derivative) and the spectrum; if the
    % shoulder is a big shoulder the area under the actual data will be considerably
    % bigger than for the linearized approximation 
    Q1 = trapz([ev(dum4ind), ev(dum8ind)],[spec(dum4ind), spec(dum8ind)]);
    Q2 = trapz(ev(dum4ind:dum8ind),spec(dum4ind:dum8ind));
    
    % sha - shoulder area
    sha(tc) = (Q2 - Q1)/Q2;    
    
    % slc - slope comparison 
    aslc(tc) = (max([abs(dum13), abs(dum14)])-min([abs(dum13), abs(dum14)]))...
        /max([abs(dum13), abs(dum14)]);
    slc(tc) = dum13 - dum14;
    
    %% Determine if at least two of the three criteria are above threshold,
    %% the threshold values were chosen empirically, based on testing the
    %% function on spectra
    
    
    if sha(tc) > 0 
        shostat.angle(t2c) = alpha(tc);
        shostat.area(t2c) = sha(tc);
        t2c = t2c+1;
    end
    
    
    tc = tc+1;
end

test = 1;

end