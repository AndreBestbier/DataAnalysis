clc
clear

%% Load data

FolderName = 'Data2';
tempText = csvread(strcat(FolderName, '\tempText.txt'),3,0);
TobjEar = tempText(:,4);
Tdie = tempText(:,5);
Vsensor = tempText(:,6);
time = tempText(:,3);
time = time - time(1);

%% Calculation
B0 = -0.0000294;
B1 = -0.00000057;
B2 = 0.00000000463;
C = 13.4;
T_ref = 298.15;         %25 degC
A1 = 0.00175;
A2 = -0.00001678;
S0 = 9.4e-14;        %  was 6.4    changed to 9.4

Vsensor = Vsensor.*(156.25/1000000000);  %Convert digital value to voltage (156.25 per LSB)
%Tdie = Tdie.*0.03125;              %Convert digital value to deg C (0.03125 per LSB)
Tdie = Tdie + 273.15;                 %Convert deg C to Kelvin

tdie_tref = Tdie - T_ref;
S = S0.*(1 + A1.*tdie_tref + A2.*tdie_tref.^2);

Vos = B0 + B1.*tdie_tref + B2.*(tdie_tref.^2);

fVsensor = (Vsensor - Vos) + C.*((Vsensor-Vos).^2);

Tobj = sqrt(sqrt(Tdie.^4 + fVsensor./S));

Tobj = Tobj - 273.15;     %Convert Kelvin back to deg C


%% Plot
figure()
plot(time, Tobj, time, Tdie, time, Vsensor);
xlabel('Milliseconds');
legend('objTemp', 'dieTemp', 'voltage'); title('Original Values');

figure()
plot(time, Tobj, time, TobjEar);
legend('Tobj', 'TobjEar');



%% Print Results
fprintf('Average ear object temp = %f\n\n', mean(Tobj));








% tdie_tref = zeros(length(TobjEar), 1);
% S = zeros(length(TobjEar), 1);
% Vos = zeros(length(TobjEar), 1);
% fVsensor = zeros(length(TobjEar), 1);
% Tobj = zeros(length(TobjEar), 1);
% 
% for i=1:length(TobjEar)
% Vsensor(i) = Vsensor(i).*(156.25/1000000000);  %Convert digital value to voltage (156.25 per LSB)
% %Tdie(i) = Tdie(i).*0.03125;              %Convert digital value to deg C (0.03125 per LSB)
% Tdie(i) = Tdie(i) + 273.15;                 %Convert deg C to Kelvin
% 
% tdie_tref(i) = Tdie(i) - T_ref;
% S(i) = S0*(1 + A1*tdie_tref(i) + A2*tdie_tref(i)^2);
% 
% Vos(i) = B0 + B1*tdie_tref(i) + B2*tdie_tref(i)^2;
% 
% fVsensor(i) = (Vsensor(i) - Vos(i)) + C*(Vsensor(i)-Vos(i))^2;
% 
% Tobj(i) = sqrt(sqrt(Tdie(i)^4 + fVsensor(i)/S(i)));
% 
% Tobj(i) = Tobj(i) - 273.15;     %Convert Kelvin back to deg C
% end



