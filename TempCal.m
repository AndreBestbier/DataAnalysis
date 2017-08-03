clear
clc
format long

%% Trail test data 1 (Collected from 16 participants)
Data1 = csvread('TempCal_TrailDataSet.txt',1,0);
Tdie_test1 = Data1(:,1);
Tdie_test1 = Tdie_test1 + 273.15;
Vsensor_test1 = Data1(:,2);
Vsensor_test1 = Vsensor_test1.*(156.25/1000000000);
Tobj_test1 = Data1(:,3);

%% Curve formula 1 (From TMP006 arduino code)

% B0 = -0.0000294;
% B1 = -0.00000057;
% B2 = 0.00000000463;
% C = 13.4;
% Tref = 298.15;         %25 degC  /  298.15 degK
% A1 = 0.00175;
% A2 = -0.00001678;
% S0 = 13.8e-14;        %  was 6.4    changed to 9.4
% 
% Tdie = Tdie_test2;
% Vsensor = Vsensor_test2;
% 
% Tobj = sqrt(sqrt(Tdie.^4 + ((Vsensor - (B0 + B1.*(Tdie-298.15) + B2.*((Tdie-298.15).^2))) + ...
%     C.*((Vsensor-(B0 + B1.*(Tdie-298.15) + B2.*((Tdie-298.15).^2))).^2))./...
%     (S0.*(1 + A1.*(Tdie-298.15) + A2.*(Tdie-298.15).^2)))) - 273.15;



%% Curve formula 2 (From TMP006 calibration guide)

% B0 = -1.178e-05;
% A1 = 1.750e-03;
% A2 = -1.680e-05;
% S0 = 6.05e-14;        %  was 6.4    changed to 9.4
% 
% Tdie = Tdie_test2;
% Vsensor = Vsensor_test2;
% 
% Tobj = sqrt(sqrt(Tdie.^4 + ((Vsensor - B0))./ ...
%     (S0.*(1 + A1.*(Tdie-298.15) + A2.*(Tdie-298.15).^2)))) - 273.15;

%% Curve formula 3 (From own guesswork)

% B0 = -0.0000294;     %-0.0000294
% B1 = 0.00000257;     %-0.00000057
% B2 = 0;              %0.00000000463
% C = 0;               %13.4
% A1 = 0.00175;
% A2 = 0;              %-0.00001678
% S0 = 9.4e-14;        %  was 6.4    changed to 9.4
% 
% Tdie = Tdie_test1;
% Vsensor = Vsensor_test1;
% 
% Tobj = sqrt(sqrt(Tdie.^4 + (Vsensor - (B0 + B1.*(Tdie - 310.15)))./(S0.*(1 + A1.*(Tdie - 310.15))))) - 273.15;


%% Curve formula 4 (1st order Polynomial)

% p00 =      -252.2;
% p10 =      0.9418;
% p01 =   2.447e+05;
% 
% Tdie = Tdie_test2;
% Vsensor = Vsensor_test2;
% 
% Tobj = p00 + p10*Tdie + p01*Vsensor;

%% Curve formula 4 (2nd order Polynomial)

       p00 =   1.547e+04;%  (5070, 2.586e+04)
       p10 =      -100.6;%  (-168.3, -32.78)
       p01 =   3.142e+07;%  (2.16e+07, 4.124e+07)
       p20 =      0.1638;%  (0.05337, 0.2743)
       p11 =   -1.02e+05;%  (-1.34e+05, -6.998e+04)
       p02 =    8.89e+09;%  (4.435e+09, 1.334e+10)
       
Tdie = Tdie_test1;
Vsensor = Vsensor_test1;

Tobj = p00 + p10*Tdie + p01*Vsensor + p20*Tdie.^2 + p11.*Tdie.*Vsensor + p02*Vsensor.^2;

%% Plotting
figure();
plot(1:length(Tobj), Tdie-273.15); hold on;
plot(1:length(Tobj), Vsensor./(156.25/1000000000));
plot(1:length(Tobj), Tobj); grid;
legend('Tdie','Vsensor','Tobj'); hold off

