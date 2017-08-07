function [Tobj] = SecondPolynomialFunction(Tdie, Vsensor)

Vsensor = Vsensor.*(156.25/1000000000);  %Convert digital value to voltage
Tdie = Tdie + 273.15;                 %Convert deg C to Kelvin

% p00 =   1.547e+04;
% p10 =      -100.6;
% p01 =   3.142e+07;
% p20 =      0.1638;
% p11 =   -1.02e+05;
% p02 =    8.89e+09;

%        p00 =        36.9;%  (36.76, 37.03)
%        p10 =      0.2299;%  (0.1428, 0.3171)
%        p01 =      0.2419;%  (0.1562, 0.3277)
%        p20 =      0.1488;%  (0.04847, 0.2492)
%        p11 =     -0.3872;%  (-0.5088, -0.2656)
%        p02 =       0.141;%  (0.07034, 0.2117)

%        p00 =       37.09;%  (36.99, 37.19)
%        p10 =      0.2209;%  (0.1283, 0.3135)
%        p01 =      0.1748;%  (0.09088, 0.2587)
%        p20 =     0.05927;%  (-0.0362, 0.1547)
%        p11 =     -0.4492;%  (-0.5742, -0.3241)
       
       p00 =   6.066e+04;%  (4.28e+04, 7.853e+04)
       p10 =      -395.7;%  (-512.3, -279)
       p01 =  -5.019e+06;%  (-2.195e+07, 1.192e+07)
       p20 =      0.6455;%  (0.4552, 0.8358)
       p11 =   1.696e+04;%  (-3.832e+04, 7.224e+04)
       p02 =   2.104e+09;%  (-3.576e+09, 7.783e+09)
       
       
% Tdie = Tdie-mean(Tdie)/std(Tdie);
% Vsensor = Vsensor-mean(Vsensor)/std(Vsensor);

Tobj = p00 + p10*Tdie + p01*Vsensor + p20*Tdie.^2 + p11*Tdie.*Vsensor + p02*Vsensor.^2;
%Tobj = p00 + p10*Tdie + p01*Vsensor + p20*Tdie.^2 + p11*Tdie.*Vsensor;
end

