function [Tobj] = SecondPolynomialFunction(Tdie, Vsensor)

Vsensor = Vsensor.*(156.25/1000000000);  %Convert digital value to voltage
Tdie = Tdie + 273.15;                 %Convert deg C to Kelvin

    %Attemp2 using Phillip1, Talon1, Maretha1, Tayla2, AndreV1
    p00 =       20.31;
    p10 =     0.05633;
    p01 =  -1.321e+04;
    p11 =  -1.321e-04;

    Tobj = p00 + p10*Tdie + p01*Vsensor + p11*(Tdie-273.15).^2 ;
end

