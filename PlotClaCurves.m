clear
clc

[Tdie, Vsensor] = meshgrid(32:35,-150:150);

Vsensor = Vsensor.*(156.25/1000000000);  %Convert digital value to voltage (156.25 per LSB)
Tdie = Tdie + 273.15;                 %Convert deg C to Kelvin

%% Curve formula 1 (From TMP006 arduino code)

B0 = -0.0000294;
B1 = -0.00000057;
B2 = 0.00000000463;
C = 13.4;
Tref = 298.15;         %25 degC  /  298.15 degK
A1 = 0.00175;
A2 = -0.00001678;
S0 = 9.4e-14;        %  was 6.4    changed to 9.4

Tobj = sqrt(sqrt(Tdie.^4 + ((Vsensor - (B0 + B1.*(Tdie-298.15) + B2.*((Tdie-298.15).^2))) + ...
    C.*((Vsensor-(B0 + B1.*(Tdie-298.15) + B2.*((Tdie-298.15).^2))).^2))./...
    (S0.*(1 + A1.*(Tdie-298.15) + A2.*(Tdie-298.15).^2)))) - 273.15;

figure();
surf(Tdie, Vsensor, Tobj);
title('TMP006 arduino code');

%% Curve formula 2 (From TMP006 calibration guide)

B0 = -1.178e-05;
A1 = 1.750e-03;
A2 = -1.680e-05;
S0 = 3.287e-14;        %  was 6.4    changed to 9.4

Tobj = sqrt(sqrt(Tdie.^4 + ((Vsensor - B0))./ ...
    (S0.*(1 + A1.*(Tdie-298.15) + A2.*(Tdie-298.15).^2)))) - 273.15;

figure();
surf(Tdie, Vsensor, Tobj);
title('TMP006 calibration guide');

%% Curve formula 3 (From own guesswork)

B0 = -0.0000294;              %-0.0000294
B1 = 0.00000257;    %-0.00000057
Tref =  310.15;         %25 degC  /  298.15 degK
A1 = 0.00175;
S0 = 9.4e-14;        %  was 6.4    changed to 9.4

Tobj = sqrt(sqrt(Tdie.^4 + (Vsensor - (B0 + B1.*(Tdie - 310.15)))./...
    (S0.*(1 + A1.*(Tdie - 310.15))))) - 273.15;

figure();
surf(Tdie, Vsensor, Tobj);
xlabel('Tdie'); ylabel('Vsensor'); zlabel('Tobj');
title('Own modeling');

%% Curve formula 4 (Polynomial)
% 
% p00 =      -252.2;
% p10 =      0.9418;
% p01 =   2.447e+05;
% 
% Tdie = Tdie_test2;
% Vsensor = Vsensor_test2;
% 
% Tobj = p00 + p10*Tdie + p01*Vsensor;