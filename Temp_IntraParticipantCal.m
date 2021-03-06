clear
clc
format short g

load AuxiliaryDataFiles/AllDataIndex.mat          %All names
load AuxiliaryDataFiles/TempDataIndex.mat         %All names with valid temp (Excludes Philip and Cobus)
load AuxiliaryDataFiles/ControlDataIndex.mat      %5 recording sessions used for calibration
load AuxiliaryDataFiles/CalibrationDataIndex.mat  %Participants not used for calibration
usedDataSet = TempDataIndex;

Tobj_ActualMean_1 = zeros(length(usedDataSet)/2, 1);
Tobj_ActualMean_2 = zeros(length(usedDataSet)/2, 1);
Tobj_1a = zeros(length(usedDataSet)/2, 1);
Tobj_1b = zeros(length(usedDataSet)/2, 1);
Tobj_2a = zeros(length(usedDataSet)/2, 1);
Tobj_2b = zeros(length(usedDataSet)/2, 1);

err_1a = zeros(length(usedDataSet)/2, 1);     %Dataset 1 err before calibration
err_1b = zeros(length(usedDataSet)/2, 1);     %Dataset 1 err after calibration
err_2a = zeros(length(usedDataSet)/2, 1);     %Dataset 2 err before calibration
err_2ba = zeros(length(usedDataSet)/2, 1);    %Dataset 2 err after calibration

Actual = 0;
Tobj = 0;

for n = 1:length(usedDataSet)/2
   
    %% Load the 1st dataset
    FolderName = usedDataSet(2*n-1);
    tempText = csvread(strcat('Trial1\', FolderName, '\tempText.txt'),3,0);
    Tdie = tempText(:,5);                                        %Tdie measured by TMP006 in degC
    Vsensor = tempText(:,6);                                     %Vsensor digialized val from TM006 register
    Tobj_ActualMean_1(n) = tempText(1,7);                          %ET 100-A average temp (degC)
    
    %% Calibrate equation with first data set
    Tobj_1a(n) = mean(FirstPolynomialFunction(Tdie, Vsensor));   %1st set before calibration
    err_1a(n) = Tobj_ActualMean_1(n)-Tobj_1a(n);                   %1st error before calibration
    Tobj_1b(n) = Tobj_1a(n) + err_1a(n);                         %1st set after calibration
    err_1b(n) = Tobj_ActualMean_1(n)-Tobj_1b(n);                   %1st error after calibration
    
    %% Load the 2nd dataset
    FolderName = usedDataSet(2*n);
    tempText = csvread(strcat('Trial1\', FolderName, '\tempText.txt'),3,0);
    Tdie = tempText(:,5);                                        %Tdie measured by TMP006 in degC
    Vsensor = tempText(:,6);                                     %Vsensor digialized val from TM006 register
    Tobj_ActualMean_2 = tempText(1,7);                          %ET 100-A average temp (degC)
    %Tobj_Actual = ones(length(Tdie),1)*Tobj_ActualMean_2;
    
    %% Calibrate second data set
%     Tobj_2a(n) = mean(FirstPolynomialFunction(Tdie, Vsensor));   %2nd set before calibration
%     err_2a(n) = Tobj_ActualMean_2(n)-Tobj_2a(n);                   %2nd error before calibration
%     Tobj_2b(n) = Tobj_2a(n) + err_1a(n)-0.18;                     %2nd set after calibration
%     err_2b(n) = Tobj_ActualMean_2(n)-Tobj_2b(n);                   %2nd error after calibration
    
    Tobj_2a = FirstPolynomialFunction(Tdie, Vsensor);   %2nd set before calibration
    err_2a(n) = Tobj_ActualMean_2-mean(Tobj_2a);                   %2nd error before calibration
    Tobj_2b = Tobj_2a + err_1a(n)-0.18;                     %2nd set after calibration
    err_2b(n) = Tobj_ActualMean_2-mean(Tobj_2b);                   %2nd error after calibration
    
    

    %% Plot
    % figure('name',FolderName, 'units','normalized','outerposition',[0 0 1 1]);
    % plot(time, TobjMCU, 'Color',[168/255 224/255 222/255]); hold on;
    % plot(time, Tobj, 'o-', 'Color',[55/255 95/255 153/255], 'MarkerSize', 2, 'MarkerFaceColor', [55/255 95/255 153/255]);
    % plot([1 time(length(time))], [meanClicksTemp meanClicksTemp], 'Color',[145/255 43/255 43/255]);
    % plot(time, Tdie_digital);
    % legend('Tobj(MATLAB)', 'Tobj(MCU)', 'Tclicks', 'Tdie');
    % axis([0 inf 34 39]);
    % hold off;

    %% Print Results
%     fprintf(FolderName);
%     fprintf('\nAverage Clicks temp\t\t\t\t\t= %f\t\tSTD: %f\n', Tobj_ActualMean, std(clicksTemp));
%     fprintf('Average ear object temp (MATLAB) \t= %f\t\tSTD: %f\n', mean(Tobj), std(Tobj));
%     fprintf('Average ear object temp (MCU) \t\t= %f\t\tSTD: %f\n', mean(TobjMCU), std(TobjMCU));
%     fprintf('Error (MATLAB) \t\t= %f degC\n\n', err(n));
% 
%     disp([Tdie Vsensor Tobj_Actual]);
% 
%     for q=1:length(Tobj_2b)
%         fprintf('%f\t,\t%f\n',Tobj_Actual(q), Tobj_2b(q));
%     end
%     fprintf('\n\n');

    

%     disp(FolderName);
%     for q=1:length(Tobj)
%         fprintf('%f\t,\t%f\t,\t%f\n', Tdie(q), Vsensor(q), Tobj_Actual(q));
%     end
%     fprintf('\n');
% 
%     disp(FolderName);
%     fprintf('Tdie STD\t%f\n', std(Tdie_digital));
%     fprintf('Vsensor STD\t%f',  std(Vsensor_digital));
%     fprintf('\n\n\n\n\n\n\n\n\n\n\n\n');
    
    
      
    %fprintf('%f\t,\t%f\t,\t%f\t,\t%f\n',Tobj_ActualMean_2(n), mean(Tobj_2b), std(Tobj_2b), Tobj_ActualMean_2(n)-mean(Tobj_2b));
    fprintf('%f\n', Tobj_2b');
    fprintf('\n\n');
    
end

disp('Errors');
disp(err_2b');
disp('Mean Error');
disp(mean(err_2b));

p_Poly = polyfit(Tobj_ActualMean_2,Tobj_2a,1);
Poly_fit = p_Poly(1)*Tobj_ActualMean_2 + p_Poly(2);

figure('units','normalized','outerposition',[0.25 0.25 0.55 0.7])
plot(Tobj_ActualMean_1, Tobj_1a,'b*'); hold on;
plot(Tobj_ActualMean_2, Tobj_2a,'r*');
plot(Tobj_ActualMean_2,Poly_fit,'r-');
plot(linspace(36, 39), linspace(36, 39), 'k');
xlabel('Ear-Monitor temperature'); ylabel('ET 100-A temperature');
title('9.2	Intra-participant calibration results');
grid; hold off;













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



%  usedDataSet = ["2. Jarryd1_Data"
%     "2. Jarryd2_Data"
%     "3. Josh1_Data"
%     "3. Josh2_Data"
%     "4. Julian1_Data"
%     "4. Julian2_Data"
%     "6. David1_Data"
%     "6. David2_Data"
%     "7. Dean2_Data"
%     "7. Dean3_Data"
%     "8. Danie1_Data"
%     "8. Danie2_Data"
%     "9. Talon1_Data"
%     "9. Talon2_Data"
%     "10. Gerard1_Data"
%     "10. Gerard3_Data"
%     "11. Philipp1_Data"
%     "11. Philipp2_Data"
%     "12. AndreV1_Data"
%     "12. AndreV2_Data"
%     "13. Tayla1_Data"
%     "13. Tayla2_Data"
%     "14. Marga1_Data"
%     "14. Marga2_Data"
%     "15. Allan1_Data"
%     "15. Allan3_Data"
%     "16. Maretha1_Data"
%     "16. Maretha2_Data"];