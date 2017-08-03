function [Tobj] = ArduinoCal(Tdie, Vsensor)

Vsensor = Vsensor.*(156.25/1000000000);  %Convert digital value to voltage
Tdie = Tdie + 273.15;                 %Convert deg C to Kelvin

B0  = -0.0000294;
B1 = -0.00000057;
B2 = 0.00000000463;
C = 13.4;
TREF = 298.15;
A2 = -0.00001678;
A1 = 0.00175;
S0 = 9.40;       % was * 10^-14

tdie_tref = Tdie - Tref;
S = S0.*(1 + A1.*tdie_tref);

Vos = B0 + B1.*tdie_tref;       % + B2.*(tdie_tref.^2);

fVsensor = (Vsensor - Vos);     % + C*(Vsensor - Vos).^2;

Tobj = sqrt(sqrt(Tdie.^4 + fVsensor./S));

Tobj = Tobj - 273.15;     %Convert Kelvin back to deg C

end

