clear
clc
format short g

load AllDataIndex.mat          %All names
load TempDataIndex.mat         %All names with valid temp (Excludes Philip and Cobus)
load ControlDataIndex.mat      %Participants used for calibration
load CalibrationDataIndex.mat  %Participants not used for calibration

%usedDataSet = TempDataIndex;

 usedDataSet = ["2. Jarryd1_Data"
    "2. Jarryd2_Data"
    "3. Josh1_Data"
    "3. Josh2_Data"
    "4. Julian1_Data"
    "4. Julian2_Data"
    "6. David1_Data"
    "6. David2_Data"
    "7. Dean2_Data"
    "7. Dean3_Data"
    "8. Danie1_Data"
    "8. Danie2_Data"
    "9. Talon1_Data"
    "9. Talon2_Data"
    "10. Gerard1_Data"
    "10. Gerard3_Data"
    "11. Philipp1_Data"
    "11. Philipp2_Data"
    "12. AndreV1_Data"
    "12. AndreV2_Data"
    "13. Tayla1_Data"
    "13. Tayla2_Data"
    "14. Marga1_Data"
    "14. Marga2_Data"
    "15. Allan1_Data"
    "15. Allan3_Data"
    "16. Maretha1_Data"
    "16. Maretha2_Data"];

%% Initialize variables
err_CalCurve = zeros(length(usedDataSet), 1);
absErr_CalCurve = zeros(length(usedDataSet), 1);

err_Poly1 = zeros(length(usedDataSet), 1);
absErr_Poly1 = zeros(length(usedDataSet), 1);

err_Poly2 = zeros(length(usedDataSet), 1);
absErr_Poly2 = zeros(length(usedDataSet), 1);

%% Calibration data set (Use with Curve Fitting App)
calData = csvread('TempCal_Closest2.txt');      %Text file with 4 calibration participants
calTdie = calData(:,1);
calTdie = calTdie + 273.15;
calVsensor = calData(:,2);
calVsensor = calVsensor.*(156.25/1000000000);
calTobj = calData(:,3);

%% Plot surface
p00 =       26.33;
p10 =      0.0368;
p01 =   -1.17e+04;

[X,Y] = meshgrid(linspace(305,309), linspace(-9e-5,3e-5));
Z = p00 + p10*X + p01*Y;
surf(X,Y,Z); grid; hold on;

%Attemp2
p00 =       20.31;
p10 =     0.05633;
p01 =  -1.321e+04;    
       
[X,Y] = meshgrid(linspace(305,309), linspace(-9e-5,3e-5));
Z = p00 + p10*X + p01*Y;
surf(X,Y,Z); grid;


for n = 1:length(usedDataSet)
   
    %% Load the dataset
    %Ear-Monitor Data
    FolderName = usedDataSet(n);
    tempText = csvread(strcat(FolderName, '\tempText.txt'),3,0);
    TobjMCU = tempText(:,4);            %Tobj as calculated by Arduino code used during trial
    Tdie = tempText(:,5);               %Tdie measured by TMP006 in degC
    Vsensor = tempText(:,6);            %Vsensor digialized val from TM006 register
    Tobj_ActualMean = tempText(1,7);    %ET 100-A average temp (degC)
    time = tempText(:,3);               %Millis val from Arduino code
    time = time - time(1);
    
    %ET 100-A Data
    clicksTemp = csvread(strcat(FolderName, '\ClicksTemp.txt'));
    Tobj_Actual = ones(length(Tdie),1)*Tobj_ActualMean;
    
    %% Plot points
    plot3(Tdie + 273.15, Vsensor.*(156.25/1000000000), Tobj_Actual, '*');
    
    
    %% Call CalCurveFunction to calculate Tobj
    Tobj_CalCurve = CalCurveFunction(Tdie, Vsensor);
    Tobj_Poly1 = FirstPolynomialFunction(Tdie, Vsensor);
    Tobj_Poly2 = SecondPolynomialFunction(Tdie, Vsensor);

    %% Results
    err_CalCurve(n) = mean(Tobj_Actual-Tobj_CalCurve);
    absErr_CalCurve(n) = mean(abs(Tobj_Actual-Tobj_CalCurve));
    
    err_Poly1(n) = mean(Tobj_Actual-Tobj_Poly1);
    absErr_Poly1(n) = mean(abs(Tobj_Actual-Tobj_Poly1));
    
    err_Poly2(n) = mean(Tobj_Actual-Tobj_Poly2);
    absErr_Poly2(n) =  mean(abs(Tobj_Actual-Tobj_Poly2));
    

    
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
%     fprintf('Average ear object temp (MATLAB) \t= %f\t\tSTD: %f\n', mean(Tobj_Poly1), std(Tobj_Poly1));
%     %fprintf('Average ear object temp (MCU) \t\t= %f\t\tSTD: %f\n', mean(TobjMCU), std(TobjMCU));
%     fprintf('Error (MATLAB) \t\t= %f degC\n\n', absErr_Poly1(n));
    
    %fprintf(FolderName);
%     fprintf('\n%f\t,\t%f\t,\t%f\t,\t%f\t,\t%f\t,\t%f\n\n',...
%         Tobj_ActualMean, std(clicksTemp), mean(Tobj), std(Tobj), err(n));
    
    fprintf(FolderName);
    for q=1:length(Tobj_Poly1)
        fprintf('%f\t,\t%f\t,\t%f\n', Tdie(q), Vsensor(q), Tobj_Actual(q));
    end
    fprintf('\n');





%     disp(FolderName);
%     fprintf('Tdie STD\t%f\n', std(Tdie_digital));
%     fprintf('Vsensor STD\t%f',  std(Vsensor_digital));
%     fprintf('\n\n\n\n\n\n\n\n\n\n\n\n');
end

disp('Errors');
disp(err_Poly1);
disp('Mean Error');
disp(mean(absErr_Poly1));

%boxplot([err_CalCurve err_Poly], ["CalCurve" "Polynomial"]);

xlabel('Tdie'); ylabel('Vsensor'); zlabel('Tobj');
legend("2. Jarryd1","2. Jarryd2","3. Josh1",...
    "3. Josh2",...
    "4. Julian1",...
    "4. Julian2",...
    "6. David1",...
    "6. David2a",...
    "7. Dean2",...
    "7. Dean3",...
    "8. Danie1_Data",...
    "8. Danie2_Data",...
    "9. Talon1_Data",...
    "9. Talon2_Data",...
    "10. Gerard1_Data",...
    "10. Gerard3_Data",...
    "11. Philipp1_Data",...
    "11. Philipp2_Data",...
    "12. AndreV1_Data",...
    "12. AndreV2_Data",...
    "13. Tayla1_Data",...
    "13. Tayla2_Data",...
    "14. Marga1_Data",...
    "14. Marga2_Data",...
    "15. Allan1_Data",...
    "15. Allan3_Data",...
    "16. Maretha1_Data",...
    "16. Maretha2_Data");
hold off;






















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



