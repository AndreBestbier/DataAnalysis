function [Tobj] = CalCurveFunction(Tdie, Vsensor)

%sqrt(sqrt(calTdie.^4 + (calVsensor - (B0 + B1.*(calTdie - 310.15)))./(S0.*(1 + A1.*(calTdie - 310.15))))) - 273.15;

    A1 = 0.0018;
    B0 = -0.0000294;            %-0.0000294
    B1 = 0.00000257;            %-0.00000057
    S0 = 8.603e-14;

    Tref =  310.15;         %25 degC  /  298.15 degK

    Vsensor = Vsensor.*(156.25/1000000000);  %Convert digital value to voltage (156.25 per LSB)
    Tdie = Tdie + 273.15;                 %Convert deg C to Kelvin

    tdie_tref = Tdie - Tref;
    S = S0.*(1 + A1.*tdie_tref);

    Vos = B0 + B1.*tdie_tref;       % + B2.*(tdie_tref.^2);

    fVsensor = (Vsensor - Vos);     % + C*(Vsensor - Vos).^2;

    Tobj = sqrt(sqrt(Tdie.^4 + fVsensor./S));

    Tobj = Tobj - 273.15;     %Convert Kelvin back to deg C

end