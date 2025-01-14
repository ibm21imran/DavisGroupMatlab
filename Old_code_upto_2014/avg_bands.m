%% DOS from bands

t = 45;
mu = 3.17*t;
s = 0.06*t;
chi0 = -0.04*t;
chi1 = 0.012*t;
ef = -0.08*t;

x =  0:0.01:10;
kx = x/pi;
%ky = kx/cos(angle);
ky = kx*tan(angle);
%figure; plot(kx,ky);

l_band = 2*t*(cos(kx) + cos(ky)) - mu;
f_band = -2*chi0*(cos(kx) + cos(ky)) - 4*chi1*cos(kx).*cos(ky) + ef;

k = sqrt(kx.^2 + ky.^2);

%figure; plot(k,l_band); hold on; plot(k,f_band,'r');

ylow = (l_band + f_band)/2 - sqrt(((l_band - f_band)/2).^2 + s^2);
yup = (l_band + f_band)/2 + sqrt(((l_band - f_band)/2).^2 + s^2);

%%
MM = [];
MM(1,1) = M(1,1); MM(1,2) = M(1,2);
count = 1;
for i=2:length(M)
    if M(i,2) ~= MM(count,2)
        count = count + 1;
        MM(count,2) = M(i,2); MM(count,1) = M(i,1);
    end
end
figure; plot(MM(:,1),MM(:,2),'x');
%%
%%
NN = [];
NN(1,1) = N(end,1); NN(end,2) = N(end,2);
count = 1;
for i=length(N)-1:-1:1
    if N(i,2) ~= NN(count,2)
        count = count + 1;
        NN(count,2) = N(i,2); NN(count,1) = N(i,1);
    end
end
figure; plot(NN(:,1),NN(:,2),'rx');
%%
N_tot = zeros(length(energy),1);
for i = 1:length(energy)
    n1 = find(energy_down == energy(i));
    n2 = find(energy_up == energy(i));
    
    if ~isempty(n1)
        N_tot(i) = N_tot(i) + N_down(n1);
    end
    if ~isempty(n2)
        N_tot(i) = N_tot(i) + N_up(n2);
    end
    
end
%%
[dN de] = num_der2b(1,N_tot,energy);
figure; plot(de,sqrt(abs(dN)));

