function new_Gdata = current_divide2(Gdata,Idata)

Imap = Idata.map;
zero_energy = find(Gdata.e == 0);
zero_energy = 1;
%current_offset = mean(mean(Imap(:,:,zero_energy)));
current_offset = 0;
for i = 1:length(Gdata.e)
 %   Imap(:,:,i) = Imap(:,:,i) - Imap(:,:,zero_energy);
    new_map(:,:,i) = Gdata.map(:,:,i)./Imap(:,:,1);
end
new_Gdata = Gdata;
new_Gdata.map = new_map;
new_Gdata.ave = squeeze(squeeze(mean(mean(new_Gdata.map))));
end