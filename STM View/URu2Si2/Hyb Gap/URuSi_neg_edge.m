%%%%%%%
% CODE DESCRIPTION: Find the left edge of hybridization gap in
% URu2Si2(Th-doped).  Enter spectra in through x (energy), y (DOS), and the
% index for the dip peak near chemical potential.  Variable input allows for
% smoothing of spectra befire fitting and edge finding.  
%   
% CODE HISTORY
%
% 110313 MHH  Created
% 
%
%%%%%%%
function n_edge = URuSi_neg_edge(x,y,top_ind,varargin)
n = size(y);
res = 0.001;
if nargin <=3
    ysm = y;
else    
    w = (varargin{1});
    ysm = boxcar_avg(y,w);  
end

if isempty(ysm) 
    n_edge = [];
    return;
end

lag = 3; % how far away from peak to take end of spectra
flag = 0;
count = 0;
while flag == 0

    pt1 = 1+count ; pt2 =  max(top_ind - lag,2);
    [p,S]= polyfit(x(pt1:pt2),ysm(pt1:pt2)',5);                
    xfine = x(pt1):res:x(pt2);
    y2 = polyval(p,xfine);        
    [dy2 x2] = num_der2b(2,y2,xfine);                
    %figure; plot(x2,dy2);
    [pks1 loc1] = findpeaks(abs(dy2));
    [pks2 loc2] = findpeaks(dy2);
    if ~isempty(loc1) && ~isempty(loc2)       
        loc = min([loc1(:); loc2(:)]);
    elseif isempty(loc1) && ~isempty(loc2)
        loc = min(loc2);
    elseif isempty(loc2) && ~isempty(loc1)
        loc = min(loc1);
    else
        loc = top_ind;
    end      
    x0 = x2(loc);
    n_edge  = x0(1);
    if sum(n_edge == xfine(pt1:pt1+(count+1)*600));
        count = count + 1;
    else
        flag = 1;
    end
    if count == 6
        flag = 1;
    end
end
%count
%plot_stuff(n_edge,x,dy2,x2,ysm,y,xfine,y2,top_ind,pt1,pt2);
end
function plot_stuff(n_edge,x,dy2,x2,ysm,y,xfine,y2,top_ind,pt1,pt2)
figure; plot(x2,dy2);
 hold on; plot([n_edge n_edge],get(gca,'ylim'));
% 
 figure; plot(x,y,'kx'); hold on; plot(x(pt1:pt2),y(pt1:pt2),'rx');
 hold on; plot(x,ysm);
 hold on; plot(xfine,y2,'g');
 hold on; plot([n_edge n_edge],get(gca,'ylim'));
 hold on; plot([x(top_ind) x(top_ind)],get(gca,'ylim'));
end
