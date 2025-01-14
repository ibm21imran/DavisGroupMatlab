function read_map(file,s,name,dist,type)
dir='';
% type:
% 0=didv
% 1 =current: he does not do the LI-factor
%2 = topo+ no factor, and he does differtn names.

% get data
fid=fopen([dir file],'r')
a=fread(fid,'uint16');
a=a(1057:length(a)); 
h=(length(a)-1300)/s^2;
map=zeros(s,s,h);
for j=1:h;
    
    for i=1:s;
       map(:,i,j)=a( ((i-1)*s+1)+(j-1)*s^2 :i*s+(j-1)*s^2);
    end
    
end

fclose(fid);

%transpose data
[sy, sx,sz]=size(map);
for j=1:sz
    map(:,:,j)=flipud(map(:,:,j)');
end



% get additiaonal params
hs=read_map_extra([dir file]);

%file to volt
% standart values: w_zero=-10; w_factor= 3.0518e-04;
map=map*hs.w_factor+hs.w_zero;


%volt to nS : fsensitivity/10 / (ddriveAmp/100)* corrfactor* gainfactro
%no factor for current
if type==0
    hs.factor=((hs.li_sens/10)/(hs.li_amp/100)*1.495*11);
    map=map*hs.factor;
elseif type==1 || type==2
    hs.factor=1;
end


[sy, sx,sz]=size(map);

if type==0 || type ++1
    
    assignin('base',[name '_map' ],map);

    ave=squeeze(sum(sum(map)))/s/s;
    assignin('base',[name '_ave' ],ave);

    dist=linspace(0,dist,s)';
    assignin('base',[name '_r' ],dist);

    assignin('base',[name '_e' ],0);

    assignin('base',[ name '_info'],hs);

elseif type == 2
    
    dist=linspace(0,dist,s)';
    assignin('base',[name '_r' ],dist);

    assignin('base',[name '_t' ],map);
    
    assignin('base',[ name '_info'],hs);
end



