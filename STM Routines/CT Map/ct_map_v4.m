%%%%%%
%For STM1 data set 60119A00
%%%%%%

function [ctmap1 ctmap2 avg_map new_map stat_map] = ct_map_v4(map,energy, flag)
load_color;
[sx sy sz] = size(map);
new_map = map;
%sx =20;
%sy=20;
ctmap1 = zeros(sx,sy);
ctmap2 = zeros(sx,sy);
avg_map = zeros(sx,sy);
stat_map = zeros(sx,sy);
x = energy;
for i = 1:sx
    i
    for j=1:sy
        if flag ==1    
            y = squeeze(squeeze(new_map(i,j,:)));        
            [p,S] = polyfit(x',y,9);
            f = polyval(p,x,S);
            residual = [(y(1:6)'-f(1:6)) (y(end-6:end)' - f(end-6:end))];
            %residual = 0;
            r = norm(residual);         
            stat_map(i,j) = r;
            new_map(i,j,:) = f;
        end
      
        f = squeeze(squeeze(new_map(i,j,:)));
        Y1 = diff(f',1)./diff(energy,1);
        avg1 = Y1(4);
        avg2 = Y1(end-3);
        avg3 = mean(f(30:50)); 
        b1 = f(4) - avg1*energy(4); %f(6) for 80913
        b2 = f(end-3) - avg2*energy(end-3);
        avg3 = 0;
        r1 = ((avg3-b1)/avg1);
        r2 = ((avg3-b2)/avg2);
        %ctmap(i,j) = r1-r2; %ct value
        avg_map(i,j) = avg3;
        ctmap1(i,j) = r1; %pband value
        ctmap2(i,j) = r2; % upper hubbard band values
        %figure; plot(new_data.e,f,'r',new_data.e,0,'b');
        %hold on; plot(r1,0,'ro',r2,0,'bo');
    end
end
img_plot2(ctmap1,Cmap.Defect1,'ctmap1');
img_plot2(ctmap2,Cmap.Defect1,'ctmap2');
%img_plot2(avg_map,Cmap.Defect1,'avgmap');
%figure; pcolor((ctmap)); shading flat;
stat_map = stat_map/(max(max(stat_map)));

end

        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
%        % y = squeeze(squeeze(data.map(i,j,:)));
%        % [p,S] = polyfit(x',y,7);
%         %f = polyval(p,x);        
%         %new_data.map(i,j,:) = f;
%         f = squeeze(squeeze(new_data.map(i,j,:)));
%         Y1 = diff(f,1);
%         Y2 = diff(f,2);
%         for i=2:floor(80/2)-1
%             if (Y1(i-1) < 0 && Y1(i+1) > 0)
%                 C1 = f(i); I1 = i;              
%                 break;
%             end
%         end
%         for i=79:-1:ceil(80/2)+1
%             if (Y1(i+1) > 0 && Y1(i-1) < 0)
%                 C2 = f(i); I2 = i;
%                 break;
%             end
%         end
%         figure; subplot(3,1,1); plot(data.e,f,'r',data.e(I1),0,'bo',data.e(I2),0,'ko');
%         subplot(3,1,2); plot(1:80,Y1,'r',(I1),0,'bo',(I2),0,'ko');
%         subplot(3,1,3): plot(1:79,Y2,1:79,0,'r');
%         ctmap(i,j) = data.e(I1) - data.e(I2);
%     end
% end
% figure; pcolor(ctmap); shading flat;
% end