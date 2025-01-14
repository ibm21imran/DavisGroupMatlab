function [cap1,cap2,cap1s]=find_the_boxes(topo)

% from small cut of topo
% Angle=atan(15/21);

% average from FT of lower right (201:512,201:512)
Angle=(atan((156-92)/(268-156))+atan((156-86)/(156-43))+atan((222-156)/(156-46))+...
    atan((228-156)/(272-156)))/4;




[nx ny nz]=size(topo);

t=1;

for i=10:nx
    for j=10:ny
        tangle(j-9)=atan((i-1)/(j-1));
    end
    for k=1:nx
        vangle(k)=atan((i-k)/(ny-1));
    end
    tangle=(tangle-Angle).^2;
    vangle=(vangle-Angle).^2;
    if min(tangle)-min(vangle)<0
        [minval,minind]=min(tangle);
        [l_cut,posi] = line_cut_correl(topo,[1 i],[minind+9 1]);
    else
        [minval,minind]=min(vangle);
        [l_cut,posi] = line_cut_correl(topo,[1 i],[ny minind]);
    end
    
    close all;
%     test=1;
    cap1{t}=l_cut;
    cap2{t}=posi;
    
    x(:,1)=1:1:length(cap1{t});
    x(:,2)=cap1{t};
    data=ftsmooth(x,'n',0.9,10);
    cap1s{t}=data(:,2);
    
    clear x;
    t=t+1;        
end
    oldind=minind;
    
    
    
    
    
for i=2:ny-1
    for j=oldind:nx
        tangle(j-oldind+1)=atan((nx-j)/(ny-i));
    end
    tangle=(tangle-Angle).^2;
    
    [minval,minindh]=min(tangle);
    [l_cut,posi] = line_cut_correl(topo,[i ny],[nx minindh+oldind-1]);
%     test=1;
    cap1{t}=l_cut;
    cap2{t}=posi;
    
    x(:,1)=1:1:length(cap1{t});
    x(:,2)=cap1{t};
    data=ftsmooth(x,'n',0.9,10);
    cap1s{t}=data(:,2);
    
    clear x;
    t=t+1;
        
    close all;

end










end




