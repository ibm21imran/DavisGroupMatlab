%% Fe up

[data_loc, dx, dy, selocex, fe1locex, fe2locex] = fesefinddefectcenter_integer(obj_60425a02_T_LF_SCC_LF,487, 439);
% 
[prft_data, prft_topo, clfdata, clftopo] = fesesingleimpurityphaseanalysis(obj_60425a02_T_LF_SCC_LF, obj_60425a02_T_LF_SCC_LF, [dx, dy], 400, selocex, fe1locex, fe2locex);

real_prft_topo = prft_topo;
real_prft_topo.map = real(prft_topo.map);

imag_prft_topo = prft_topo;
imag_prft_topo.map = imag(prft_topo.map);

%% Se vacancy
% % %
% [data_loc, dx, dy, selocex, fe1locex, fe2locex] = fesefinddefectcenter_se_atom_integer(obj_60425a02_T_LF_SCC_LF,487, 454);
% % % 
% [prft_data, prft_topo, clfdata, clftopo] = fesesingleimpurityphaseanalysis(obj_60425a02_T_LF_SCC_LF, obj_60425a02_T_LF_SCC_LF, [dx, dy], 400, selocex, fe1locex, fe2locex);
% % 
% 
% real_prft_topo = prft_topo;
% real_prft_topo.map = real(prft_topo.map);
% 
% imag_prft_topo = prft_topo;
% imag_prft_topo.map = imag(prft_topo.map);


%% Fe right
% %
% [data_loc, dx, dy, selocex, fe1locex, fe2locex] = fesefinddefectcenter_integer(obj_60425a02_T_LF_SCC_LF,502, 454);
% % 
% [prft_data, prft_topo, clfdata, clftopo] = fesesingleimpurityphaseanalysis(obj_60425a02_T_LF_SCC_LF, obj_60425a02_T_LF_SCC_LF, [dx, dy], 400, selocex, fe1locex, fe2locex);
% 
% real_prft_topo = prft_topo;
% real_prft_topo.map = real(prft_topo.map);
% 
% imag_prft_topo = prft_topo;
% imag_prft_topo.map = imag(prft_topo.map);