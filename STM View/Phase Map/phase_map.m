%%%%%%%
% CODE DESCRIPTION:  Generate phase information map for periodic
% structures in img input (usually topograph of (quasi_periodic)
% character).  The method uses the lock-in technique for which reference
% functions with a single frequency 
%
% INPUT:  img - 2D image from which to generate phase map
%         q_px - vector of points in FT image corresponding to Bragg peaks (in
%         pixel number) 
%         q_px = [y1 y2 y3 y4; x1 x2 x3 x4]
%         
% OUTPUT: phi_1 - phase map for direction 1
%         phi_2 - phase map for direction 2
%
% CODE HISTORY
%
%  110628 MHH  Modular code rewritten from old code
%%%%%%%%
function phase = phase_map(img,img_r,q_px,filt_width)
load_color;
[nr nc] = size(img);
% make reference functions
ref_fun = lockin_ref_fun(img,img_r,q_px);

% multiply image by reference functions
lock_signal.ts1 = img.*ref_fun.sin1; lock_signal.tc1 = img.*ref_fun.cos1;
lock_signal.ts2 = img.*ref_fun.sin2; lock_signal.tc2 = img.*ref_fun.cos2;
load_color;
cols = Cmap.Defect1;
cols = Cmap.Blue2;
% img_plot2(img,Cmap.Blue2,'IMAGE');
% img_plot2(lock_signal.ts1,cols,'X-dir sin locked image');img_plot2(lock_signal.tc1,cols,'X-dir cos locked image');
% img_plot2(lock_signal.ts2,cols,'Y-dir sin locked image');img_plot2(lock_signal.tc2,cols,'Y-dir cos locked image');

filt_img.ts1 = (fourier_filter_dc(lock_signal.ts1,filt_width));
filt_img.tc1 = (fourier_filter_dc(lock_signal.tc1,filt_width));
filt_img.ts2 = (fourier_filter_dc(lock_signal.ts2,filt_width));
filt_img.tc2 = (fourier_filter_dc(lock_signal.tc2,filt_width));

%img_plot2(abs(filt_img.ts1),cols,'X-dir sin locked FT'); img_plot2(abs(filt_img.tc1),cols,'X-dir cos locked FT');
%img_plot2(abs(filt_img.ts2),cols,'Y-dir sin locked FT'); img_plot2(abs(filt_img.tc2),cols,'Y-dir cos locked FT');

% %Find Phase Shift
% 
% Create phase shift map
phase.theta1 = mod(atan2(filt_img.tc1,filt_img.ts1),2*pi);
phase.theta2 = mod(atan2(filt_img.tc2,filt_img.ts2),2*pi); 

phase.theta1 = atan2(filt_img.tc1,filt_img.ts1);
phase.theta2 = atan2(filt_img.tc2,filt_img.ts2); 


img_plot2(phase.theta1,cols,'theta 1');
img_plot2(phase.theta2,cols,'theta 2');
% 
% % %Record Amplitude
% % phase.amp1 = real(((filt_img.ts1.^2)+(filt_img.tc1.^2)).^0.5);
% % phase.amp2 = real(((filt_img.ts2.^2)+(filt_img.tc2.^2)).^0.5);
% % 
% % %img_plot2((phase.amp1),Cmap.Defect1);
% % %img_plot2((phase.amp2),Cmap.Defect1);
% % 
 [X Y] = meshgrid(img_r,img_r);
 phase.q1r = ref_fun.q1(2,1)*X + ref_fun.q1(1,1)*Y;
 phase.q2r = ref_fun.q2(2,1)*X + ref_fun.q2(1,1)*Y;
% 
% phase.phi1 = mod(phase.q1r + phase.theta1,2*pi);
 %phase.phi2 = mod(phase.q2r + phase.theta2,2*pi);
 phase.phi1 = phase.q1r + phase.theta1;
phase.phi2 = phase.q2r + phase.theta2;

 
 img_plot2(phase.phi1,cols,'phi 1');
img_plot2(phase.phi2,cols,'phi 2');
 
% 
% phase.q1 = ref_fun.q1; phase.q2 = ref_fun.q2;
%img_plot2(sin(phase.phi2));
%img_plot2(sin(phase.phi1));
%img_plot2(phase.amp2.*sin(phase.phi1) + phase.amp2.*sin(phase.phi2));
% img_plot2(img,cols,'Orignal Image');
% tol1 = 0.27;
% tol2 = 0.31;
% rr = 48; cc = 14;
% [r c] = find((phase.phi1 > phase.phi1(rr,cc)- tol1) & (phase.phi1 < phase.phi1(rr,cc) + tol1)...
%     & (phase.phi2 > phase.phi2(rr,cc)- tol2) & (phase.phi2 < phase.phi2(rr,cc) + tol2));
% hold on;  plot(c,r,'rx');
% img_plot2(sin(phase.phi1)+sin(phase.phi2),cols, 'Reconstructed Image');
% hold on;  plot(c,r,'rx');
end