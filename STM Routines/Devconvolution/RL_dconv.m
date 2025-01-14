%%%%%%%
% CODE DESCRIPTION: Deconvolution algorithm based on the Richardson-Lucy
% Method.  
%   
% CODE HISTORY
%
% 090921 MHH Created
%
%%%%%%%

function dconv_data = RL_dconv(energy,spectra,VA)
k =10;
n = length(energy);

a = zeros(k,n);
a(1,:) = spectra;

er_tol = zeros(k-1,1);

top = LIA_conv(energy,spectra,VA,-1);

for i=2:k       
    bot_1 = LIA_conv(energy,squeeze(a(i-1,:)),VA,1);
    bot_2 = LIA_conv(energy,bot_1,VA,-1);
    a(i,:) = squeeze(a(i-1,:)).*(top./bot_2);
    er_tol(i-1) = RMS_er(energy,spectra,squeeze(a(i,:)),VA);
end
dconv_data = a;
er_tol
figure;
subplot(1,3,1); plot((-diff(er_tol(1:end))),'gx-');
title('error diff')
subplot(1,3,2); plot(energy,spectra,'r'); hold on; plot(energy,dconv_data(end,:));
title('deconvolved spectra vs original in red')
subplot(1,3,3);plot(energy,spectra,'r');hold on; plot(energy,LIA_conv(energy,dconv_data(end,:),VA,1));
title('reconvolvution of processed spectra vs original in red')

end
function err_est = RMS_er(x,y,y2,LIA_amp)
N = length(x);
err_est = sqrt(1/N*sum((y - LIA_conv(x,y2,LIA_amp)).^2));
end