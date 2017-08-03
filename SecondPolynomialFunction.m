function [Tobj] = SecondPolynomialFunction(Tdie, Vsensor)

Vsensor = Vsensor.*(156.25/1000000000);  %Convert digital value to voltage
Tdie = Tdie + 273.15;                 %Convert deg C to Kelvin

p00 =   1.547e+04;
p10 =      -100.6;
p01 =   3.142e+07;
p20 =      0.1638;
p11 =   -1.02e+05;
p02 =    8.89e+09;

%        p00 =        36.9;%  (36.76, 37.03)
%        p10 =      0.2299;%  (0.1428, 0.3171)
%        p01 =      0.2419;%  (0.1562, 0.3277)
%        p20 =      0.1488;%  (0.04847, 0.2492)
%        p11 =     -0.3872;%  (-0.5088, -0.2656)
%        p02 =       0.141;%  (0.07034, 0.2117)

Tobj = p00 + p10*Tdie + p01*Vsensor + p20*Tdie.^2 + p11*Tdie.*Vsensor + p02*Vsensor.^2;
end

