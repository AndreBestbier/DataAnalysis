clear
clc
format short g

load AuxiliaryDataFiles/AllDataIndex.mat          %All names
load AuxiliaryDataFiles/TempDataIndex.mat         %All names with valid temp (Excludes Philip and Cobus)
load AuxiliaryDataFiles/ControlDataIndex.mat      %Participants used for calibration
load AuxiliaryDataFiles/CalibrationDataIndex.mat  %Participants not used for calibration
usedDataSet = TempDataIndex;

%% Initialize variables
MCU = 0;
Poly1 = 0;
Poly2 = 0;
Cal = 0;
Actual = 0;

err_Poly1 = zeros(length(usedDataSet), 1);
absErr_Poly1 = zeros(length(usedDataSet), 1);

%% Calibration data set (Use with Curve Fitting App)
calData = csvread('AuxiliaryDataFiles/CalibrationGroup.txt');      %Text file with 4 calibration participants
calTdie = calData(:,1);
calTdie = calTdie + 273.15;
calVsensor = calData(:,2);
calVsensor = calVsensor.*(156.25/1000000000);
calTobj = calData(:,3);

for n = 1:length(usedDataSet)
   
    %% Load the dataset
    %Ear-Monitor Data
    FolderName = usedDataSet(n);
    tempText = csvread(strcat('Trial1/', FolderName, '\tempText.txt'),3,0);
    TobjMCU = tempText(:,4);            %Tobj as calculated by Arduino code used during trial
    Tdie = tempText(:,5);               %Tdie measured by TMP006 in degC
    Vsensor = tempText(:,6);            %Vsensor digialized val from TM006 register
    Tobj_ActualMean = tempText(1,7);    %ET 100-A average temp (degC)
    time = tempText(:,3);               %Millis val from Arduino code
    time = time - time(1);
    
    %ET 100-A Data
    clicksTemp = csvread(strcat('Trial1/', FolderName, '\ClicksTemp.txt'));
    Tobj_Actual = ones(length(Tdie),1)*Tobj_ActualMean;
    
    %% Call CalCurveFunction to calculate Tobj
    Tobj_Poly1 = FirstPolynomialFunction(Tdie, Vsensor);    %First order polynomial

    %% Results
    err_Poly1(n) = mean(Tobj_Actual-Tobj_Poly1);
    absErr_Poly1(n) = mean(abs(Tobj_Actual-Tobj_Poly1));
    
    %% Plot
%     figure('name', FolderName, 'units','normalized','outerposition',[0 0 1 1]);
%     plot(time, TobjMCU, 'Color',[168/255 224/255 222/255]); hold on;
%     plot(time, Tobj_Poly1, 'o-', 'Color',[55/255 95/255 153/255], 'MarkerSize', 2, 'MarkerFaceColor', [55/255 95/255 153/255]);
%     plot([1 time(length(time))], [Tobj_Actual(1) Tobj_Actual(1)], 'Color',[145/255 43/255 43/255]);
%     plot(time, Tdie);
%     legend('Tobj(MCU)', 'Tobj(Poly1)', 'T_Actual', 'Tdie');
%     axis([0 inf 34 39]);
%     hold off;



    
    %% Load values in big arrays
    Poly1 = [Poly1; mean(Tobj_Poly1)];
    Actual = [Actual; mean(Tobj_Actual)];
   
    %% Print Results
    % fprintf(FolderName);
    % fprintf('\nAverage Clicks temp\t\t\t\t\t= %f\t\tSTD: %f\n', Tobj_ActualMean, std(clicksTemp));
    % fprintf('Average ear object temp (MATLAB) \t= %f\t\tSTD: %f\n', mean(Tobj_Poly1), std(Tobj_Poly1));
    % %fprintf('Average ear object temp (MCU) \t\t= %f\t\tSTD: %f\n', mean(TobjMCU), std(TobjMCU));
    % fprintf('Error (MATLAB) \t\t= %f degC\n\n', absErr_Poly1(n));
    % 
    % fprintf(FolderName);
    % fprintf('\n%f\t,\t%f\t,\t%f\t,\t%f\t,\t%f\t,\t%f\n\n',...
    % Tobj_ActualMean, std(clicksTemp), mean(Tobj), std(Tobj), err(n));

    % Tdie(q), Vsensor(q), Tobj_Actual(q), Tobj
    % disp(FolderName);
    % for q=1:length(Tobj_Poly1)
    %     fprintf('%f\t,\t%f\n',Tobj_Actual(q), Tobj_Poly1(q));
    % end
    % fprintf('\n\n');


    %fprintf('%f\t,\t%f\n',mean(Tobj_Actual), mean(Tobj_Poly1));

    fprintf('%f\t,\t%f\t,\t%f\t,\t%f\t,\t%f\n', Tobj_ActualMean, std(clicksTemp), mean(Tobj_Poly1), std(Tobj_Poly1), Tobj_ActualMean-mean(Tobj_Poly1));

    % disp(FolderName);
    % fprintf('Tdie STD\t%f\n', std(Tdie_digital));
    % fprintf('Vsensor STD\t%f',  std(Vsensor_digital));
    % fprintf('\n\n\n\n\n\n\n\n\n\n\n\n');
end

disp('Errors');
disp(err_Poly1);
disp('Abs Mean Error');
disp(mean(absErr_Poly1));

MCU(1) = [];
Poly1(1) = [];
Poly2(1) = [];
Cal(1) = [];
Actual(1) = [];

p_Poly1 = polyfit(Actual,Poly1,1);
Poly_fit1 = p_Poly1(1)*Actual + p_Poly1(2);

figure('units','normalized','outerposition',[0.25 0.25 0.55 0.7])
plot(Actual, Poly1, 'b*'); hold on;
plot(Actual,Poly_fit1,'b-');
plot(linspace(36, 39), linspace(36, 39), 'k'); hold off;
xlabel('Ear-Monitor temperature'); ylabel('ET 100-A temperature');
title('Calibration group method results');
grid; hold off;

%boxplot([err_CalCurve err_Poly], ["CalCurve" "Polynomial"]);






















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

%% Plot surface
%Best fit for all data points
% p00 =       26.33;
% p10 =      0.0368;
% p01 =   -1.17e+04;
% [X,Y] = meshgrid(linspace(305,309), linspace(-9e-5,3e-5));
% Z = p00 + p10*X + p01*Y;
% surf(X,Y,Z); grid; hold on;

% figure();
% Best fit for all data points minus Jarryd and julian
% p00 =       39.57;
% p10 =   -0.006523;
% p01 =  -1.517e+04;
% [X,Y] = meshgrid(linspace(305,309), linspace(-9e-5,3e-5));
% Z = p00 + p10*X + p01*Y;
% surf(X,Y,Z); grid; hold on;

%Attemp2 using Talon1, Philipp1, Philipp2, Josh1, Tayla1
% p00 =       20.31;
% p10 =     0.05633;
% p01 =  -1.321e+04;
% [X,Y] = meshgrid(linspace(305,309), linspace(-9e-5,3e-5));
% Z = p00 + p10*X + p01*Y;
% surf(X,Y,Z); grid; hold off;
