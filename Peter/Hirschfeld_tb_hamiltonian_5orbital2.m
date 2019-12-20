function [Hss, Haa] = Hirschfeld_tb_hamiltonian_5orbital2(px, py, p1, p2, kz)

H = zeros(10,10,1);
Hpp = zeros(5,5,1);
Hpm = zeros(5,5,1);
Hss = zeros(5,5,1);
Haa = zeros(5,5,1);

z = 5;
zc = 5;
%% changed after checking original parameters by Kreisel

t1111 = 0.086/z + 0.0005 - 0.001;

t1016 = -0.063/z -0.0211;
t2011 = -0.028/z + 0.00283;

t2116 = 0.017/z;
%t1113 = -0.056*1i/z; june 25th
t1113 = -0.056*1i/z + 0.006*1i;

t1018 = 0.305*1i/z + 0.07625*1i;

t1115 = -0.109/z;
t1027 = -0.412/z + 0.02289;

t1122 = -0.066/z + 0.0037;

t1029 = -0.364*1i/z - 0.034*1i;
t1123 = 0.089*1i/z;
t102ten = 0.338/z - 0.01877;
t104ten = 0.180*1i/z;



%% H++33 and H++44
t2033 = 0.009/z;
t0233 = -0.045/z;

t20133 = -0.008/zc;
t02133 = 0.020/zc;

% the following three hopping integrals are symmetric in 33 and 44 
t2233 = 0.027/z;
t1133 = 0.232/z;
t00133 = 0.011/zc;
%% H+-38 and H+-39
t1038 = 0.080/z + 0.00344;
t1049 = 0.311/z + 0.01224;

t2138 = 0.016/z;
t2149 = -0.019/z;

t10138 = 0.006/zc + 0.00253;
t10149 = 0.025/zc - 0.00203;

t12138 = -0.003/zc;
t12149 = 0.006/zc;
%% H++34
t1134 = 0.099/z;
%% H++35
t1135 = 0.146*1i/z;
%% H+-39
t10139 = 0.015/zc;

%%
% po1 = 0.0125-0.0075;
% po2 = 0.0025-0.0075;
% po3 = 0.0025-0.0075;
% po4 = 0.0025-0.0075;
% po5 = 0.0025-0.0075;

%po1 = -0.03; %June25th

po1 = 0.01-0.004;
po2 = 0.01-0.004;
po3 = 0.01-0.004;
po4 = 0.01-0.004;
po5 = 0.01-0.004;

e1 = 0.014/z -0.0004 + po1;

e2 = -0.539/z + 0.0299 + po2;

e3 = 0.020/z -0.000043 + po3;

e4 = 0.020/z -0.000043 + po4;

e5 = -0.581/z +0.03224 + po5;

%% 
t10116 = 0 + 0.00275;

t00111 = 0;
t12116 = -0.017/zc;
t11111 = 0;
t10118 = 0.009*1i/zc;

t20111 = 0.017/zc - 0.002753;

t10119 = 0.020*1i/zc;
t20114 = 0.0030*1i/zc + 0.0045*1i;
t12119 = -0.0031*1i/zc;



oos = 0.025;
oodfe = -0.025;







%% Hpp (H++) from suppl. inf. Mukherjee paper
        Hpp(1,1,1) = e1 + 2*t1111*( cos(p1)+ cos(p2) )+...
            2*t2011*( cos(2*px) + cos(2*py) )+...
            (2*t00111 + 4*t11111 * ( cos(p1)+ cos(p2)) + 4*t20111 * ...
            (cos(2*px) + cos(2*py)))* cos(kz);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Hpp(1,2,1) = 0;
        
        Hpp(2,1,1) = 0;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Hpp(1,3,1) = 2*1i*t1113 * (sin(p1) - sin(p2)) - ...
            4*t20114 * sin(2*py)*sin(kz);
        
        Hpp(3,1,1) = conj(Hpp(1,3,1));
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Hpp(1,4,1) = 2*1i*t1113 * (sin(p1) + sin(p2)) - ...
            4*t20114 * sin(2*px) * sin(kz);
        
        Hpp(4,1,1) = conj(Hpp(1,4,1));
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Hpp(1,5,1) = 2*t1115 * (cos(p1) - cos(p2));
        
        Hpp(5,1,1) = conj(Hpp(1,5,1));
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Hpp(2,2,1) = e2 + 2*t1122 * (cos(p1) + cos(p2));
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Hpp(2,3,1) = 2*1i*t1123 * (sin(p1) + sin(p2));
        
        Hpp(3,2,1) = conj(Hpp(2,3,1));
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Hpp(2,4,1) = 2*1i*t1123 * (-sin(p1) + sin(p2));
        
        Hpp(4,2,1) = conj(Hpp(2,4,1));
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Hpp(2,5,1) = 0;
        
        Hpp(5,2,1) = 0;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Hpp(3,3,1) = e3 + 2*t1133 * (cos(p1) + cos(p2)) +...
            2*t2033 * cos(2*px) + 2*t0233 * cos(2*py) +...
            4*t2233 *cos(2*px)*cos(2*py)+...
            (2*t00133 + 4*t20133 *cos(2*px) + 4*t02133 *cos(2*py))*cos(kz) +...
            oos;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Hpp(3,4,1) = 2*t1134 * (cos(p1) - cos(p2));
        
        Hpp(4,3,1) = conj(Hpp(3,4,1));
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Hpp(3,5,1) = 2*1i*t1135 * (sin(p1) + sin(p2));
        
        Hpp(5,3,1) = conj(Hpp(3,5,1));
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Hpp(4,4,1) = e4 + 2*t1133 * (cos(p1) + cos(p2)) +...
            2*t0233 * cos(2*px) +2*t2033 * cos(2*py) +...
            4*t2233 * cos(2*px) * cos(2*py) +...
            (2*t00133 + 4*t02133 * cos(2*px)+4*t20133 * cos(2*py))*cos(kz) -...
            oos;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Hpp(4,5,1) = 2*1i*t1135 * (sin(p1) - sin(p2));
        
        Hpp(5,4,1) = conj(Hpp(4,5,1));
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Hpp(5,5,1) = e5;
        
        %% Hpm (H+-) from suppl. inf. Mukherjee paper
%         Hpm(1,1,1) = 100 +100 * 1i;
        Hpm(1,1,1) = 2*t1016 * (cos(px) + cos(py))+...
            2*t2116 * ( (cos(p1)+cos(p2))*(cos(px)+cos(py)) - ...
            sin(p1) *(sin(px)+sin(py)) + sin(p2) *(sin(px)-sin(py)) ) +...
            4*t10116 * (cos(px) + cos(py))*cos(kz) +...
            2*t12116 * ( (cos(p1+py)+cos(p1+px)) *exp(1i*kz) +...
            (cos(p2+py) + cos(p2-px)) * exp(-1i*kz) );
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Hpm(1,2,1) = 0;
        
        Hpm(2,1,1) = 0;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Hpm(1,3,1) = 2*1i*t1018 *sin(px) -...
            4*(t10118 * sin(px) + t10119 * sin(py))*sin(kz) +...
            2*1i*t12119 *(sin(p1+py)*exp(1i*kz)-sin(p2+py)*exp(-1i*kz));
        
        Hpm(3,1,1) = conj(Hpm(1,3,1));
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Hpm(1,4,1) = 2*1i*t1018 * sin(py) -...
            4*(t10119 * sin(px) +t10118 * sin(py))* sin(kz) +...
            2*1i*t12119 *( sin(p1+px)*exp(1i*kz)+sin(p2-px)*exp(-1i*kz) );
        
        Hpm(4,1,1) = conj(Hpm(1,4,1));
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Hpm(1,5,1) = 0;
        
        Hpm(5,1,1) = 0;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Hpm(2,2,1) = 2*t1027 * (cos(px) + cos(py));
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Hpm(2,3,1) = -2*1i*t1029 * sin(py);
        
        Hpm(3,2,1) = conj(Hpm(2,3,1));
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Hpm(2,4,1) = 2*1i*t1029 * sin(px);
        
        Hpm(4,2,1) = conj(Hpm(2,4,1));
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Hpm(2,5,1) = 2*t102ten *(cos(px) - cos(py));
        
        Hpm(5,2,1) = conj(Hpm(2,5,1));
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Hpm(3,3,1) = 2*t1038 *cos(px) + 2*t1049 *cos(py) +...
            2*t2138 *( (cos(p1)+cos(p2))*cos(px) - (sin(p1)-sin(p2)) *...
            sin(px) ) +...
            2*t2149 *( (cos(p1)+cos(p2))*cos(py) - (sin(p1)+sin(p2)) *...
            sin(py) )+...
            4*(t10138 *cos(px) + t10149 * cos(py) )*cos(kz) +...
            2*t12138 *( cos(p1+px)*exp(1i*kz) + cos(p2-px)*exp(-1i*kz) )+...
            2*t12149 *( cos(p1+py)*exp(1i*kz) + cos(p2+py)*exp(-1i*kz) )-...
            oodfe * ( cos(px) - cos(py) );
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Hpm(3,4,1) = 4*1i* t10139 * (cos(px) + cos(py)) * sin(kz);
        
        Hpm(4,3,1) = conj(Hpm(3,4,1));
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Hpm(3,5,1) = 2*1i*t104ten *sin(py);
        
        Hpm(5,3,1) = conj(Hpm(3,5,1));
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Hpm(4,4,1) = 2*t1049 * cos(px) + 2*t1038 * cos(py) +...
            2*t2149 *( (cos(p1)+cos(p2))*cos(px) - (sin(p1)-sin(p2)) *...
            sin(px) ) +...
            2*t2138 *( (cos(p1)+cos(p2))*cos(py) - (sin(p1)+sin(p2)) *...
            sin(py) ) +...
            4*(t10149 * cos(px) +t10138 *cos(py)) * cos(kz) +...
            2*t12149 *( cos(p1+px)*exp(1i*kz) + cos(p2-px)*exp(-1i*kz) )+...
            2*t12138 *(cos(p1+py)*exp(1i*kz) + cos(p2+py)*exp(-1i*kz) )-...
            oodfe * ( cos(px) - cos(py) );
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Hpm(4,5,1) = 2*1i*t104ten * sin(px);
        
        Hpm(5,4,1) = conj(Hpm(4,5,1));
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Hpm(5,5,1) = 0;
        
        
         %%
        % assemble H
        H(1:5, 1:5, 1) = Hpp(:, :, 1);
        H(1:5, 6:10, 1) = Hpm(:, :, 1);
        H(6:10, 1:5, 1) = conj(Hpm(:,:,1));
        H(6:10, 6:10, 1) = conj(Hpp(:,:,1));
        
        Hss = Hpp + Hpm;
        Haa = Hpp - Hpm;
        
end
        