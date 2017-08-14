function [Tobj] = FirstPolynomialFunction(Tdie, Vsensor)

    Vsensor = Vsensor.*(156.25/1000000000);     %Convert digital value to voltage
    Tdie = Tdie + 273.15;                       %Convert deg C to Kelvin

    %Calibration with Jaryd, Josh, Talon and Marga
    % p00 =      -117.1;
    % p10 =      0.5037;
    % p01 =   5.907e+04;

    %All temp data fit
    % p00 =       26.33;
    % p10 =      0.0368;
    % p01 =   -1.17e+04;
    
    %All temp data minus 2 and 4
%     p00 =       39.57;
%     p10 =   -0.006523;
%     p01 =  -1.517e+04;

    %Using Philipp1, Talon1, Maretha1, Tayla1, AndreV1 (all data points)
%     p00 =       20.31;
%     p10 =     0.05633;
%     p01 =  -1.321e+04;
    
    %Using Philipp1, Talon1, Maretha1, Tayla1, AndreV1 (averages)
    p00 =       22.85;
    p10 =     0.04803;
    p01 =  -1.344e+04;

    Tobj = p00 + p10*Tdie + p01*Vsensor;
    
end

