function [Tobj] = FirstPolynomialFunction(Tdie, Vsensor)

Vsensor = Vsensor.*(156.25/1000000000);  %Convert digital value to voltage
Tdie = Tdie + 273.15;                 %Convert deg C to Kelvin

p00 =      -117.1;
p10 =      0.5037;
p01 =   5.907e+04;
       
Tobj = p00 + p10*Tdie + p01*Vsensor;

end

