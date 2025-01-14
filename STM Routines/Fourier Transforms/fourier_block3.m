%%%%%%%
% CODE DESCRIPTION: Take fourier transform of map with given scaling.  The
% output is an absolute fourier transform map and a conjugate space scaling.
%   
% CODE HISTORY
%
% 080101 MA  Created
% 080131 MHH Minor revision to variable assignments
% 080204 MHH Added windowing option
%
%%%%%%%
function F = fourier_block3(data,window,type,direction)
% type gives full(f) real(r), imaginary(i), amplitude(a), or phase(p) of FT
%direction gives FT(ft) or iFT (ift)
[nr,nc,nz]=size(data.map);

switch window
    case 'none'   
        z = 1;
    case 'sine'
        x = linspace(0,pi,nc);
        y = linspace(0,pi,nr);
        z = sin(x)'*sin(y);
    case 'kaiser'
        w = kaiser(nc,6);
        z = w*w';
    case 'gauss'
        w = gausswin(nc);
        z = w*w';
    case 'blackmanharris'
        w = blackmanharris(nc);
        z = w*w';
    otherwise
        z = 1;
end
%apply filter
filt = zeros(nr,nc,nz); %windowed data
ff = zeros(nr,nc,nz); % fourier transformed data (real and imaginary)
f = zeros(nr,nc,nz); % one of real/imaginary/amplitude/phase of FT
for k=1:nz
    filt(:,:,k) = data.map(:,:,k).*z;
end
switch direction
    case 'ft'
        for k=1:nz 
            ff(:,:,k) = fftshift(fft2(filt(:,:,k)));              
        end
    case 'ift'
        for k=1:nz 
            ff(:,:,k) = ifft2(filt(:,:,k));      
        end
    otherwise
        for k=1:nz 
            ff(:,:,k) = fftshift(fft2(filt(:,:,k)));  
        end
end

switch type
    case 'full'
            f = ff;
    case 'real'
            f = real(ff(:,:,k));
    case 'imaginary'
            f = imag(ff);
    case 'amplitude'
            f = abs(ff);
    case 'phase'
            f = angle(ff);
    otherwise
            f = abs(ff);
            display('Default: Amplitude')
end

%f = fftshift(f);               
k0=2*pi/(max(data.r)-min(data.r));
k=linspace(-k0*nc/2,k0*nc/2,nc);
F = data;
F.map = f;
F.r = k;
end