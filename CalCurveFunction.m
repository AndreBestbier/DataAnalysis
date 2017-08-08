function [Tobj] = CalCurveFunction(Tdie, Vsensor)

    %sqrt(sqrt(calTdie.^4 + (calVsensor - (B0 + B1.*(calTdie - 310.15)))./(S0.*(1 + A1.*(calTdie - 310.15))))) - 273.15;

    % Data sheet calibration
    A1 = 9.995e-04;
    A2 = -6.020e-06;
    B0 = -3.094e-05;           
    B1 = -8.728e-08;          
    B2 = 1.300e-08;
    S0 = 4.430e-14;
    C  = 0;

% Self calibration
%     A1 = 0.0018;
%     A2 = 0;
%     B0 = -0.0000294;            %-0.0000294
%     B1 = 0.00000257;            %-0.00000057
%     B2 = 0;
%     S0 = 8.603e-14;
%     C  = 0;


    Tref =  310.15;         %25 degC  /  298.15 degK

    Vsensor = Vsensor.*(156.25/1000000000);  %Convert digital value to voltage (156.25 per LSB)
    Tdie = Tdie + 273.15;                 %Convert deg C to Kelvin

    tdie_tref = Tdie - Tref;
    S = S0.*(1 + A1.*tdie_tref + A2.*tdie_tref.^2);

    Vos = B0 + B1.*tdie_tref + B2.*tdie_tref.^2;       % + B2.*(tdie_tref.^2);

    fVsensor = (Vsensor - Vos) + C.*(Vsensor - Vos).^2;     % + C*(Vsensor - Vos).^2;

    Tobj = sqrt(sqrt(Tdie.^4 + fVsensor./S));

    Tobj = Tobj - 273.15;     %Convert Kelvin back to deg C

end