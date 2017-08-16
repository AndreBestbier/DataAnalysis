clc;
clear;

syms y;
x = y;





%% Temp: Group calibration
% TempA = xlsread('Excels/Statistica.xlsx','TempCalGroup','B2:C29');
% Actual = TempA(:,1);
% Headband = TempA(:,2);
% 
% p_Headband = polyfit(Actual,Headband,1);
% Headband_fit1 = p_Headband(1)*Actual + p_Headband(2);
% 
% figure('units','normalized','outerposition',[0.25 0.25 0.55 0.7])
% plot(Actual, Headband, 'b*'); grid; hold on;
% plot(Actual, Headband_fit1, 'b-');
% fplot(x, 'k');
% axis([36.25 38.6 36.25 38.6]);
% title('Temperature through Calibration Group: ET 100-A vs. Ear-Monitor'); xlabel('Number of Nexus-10 beats'); ylabel('Number of Ear-Monitor beats'); hold off;


%% Temp: Intra-participant calibration
% TempB = xlsread('Excels/Statistica.xlsx','TempIntraPartsp','B2:C15');
% Actual = TempB(:,1);
% Headband = TempB(:,2);
% 
% p_Headband = polyfit(Actual,Headband,1);
% Headband_fit1 = p_Headband(1)*Actual + p_Headband(2);
% 
% figure('units','normalized','outerposition',[0.25 0.25 0.55 0.7])
% plot(Actual, Headband, 'b*'); grid; hold on;
% plot(Actual, Headband_fit1, 'b-');
% fplot(x, 'k');
% axis([36 38.6 36 38.6]);
% title('Temperature through Intra-participant Calibration: ET 100-A vs. Ear-Monitor'); xlabel('Number of Nexus-10 beats'); ylabel('Number of Ear-Monitor beats'); hold off;

%% Box Plot: Before and after calibration
% TempErrors = csvread('AuxiliaryDataFiles/BeforeCalBoxplot.txt');
% Before = TempErrors(:,1);
% After = TempErrors(:,2);
% 
% figure('units','normalized','outerposition',[0.25 0.25 0.55 0.7])
% boxplot([Before, After],[0,1], 'OutlierSize', 4, 'Whisker',10,'Labels',{'Before calibration','After calibration'});
% title('Temperature errors before and after calibration');
% ylabel('Error: ET100-A temperature - Ear-Monitor temperature');

%% Box Plot: Comparing 2 types of calibration
% TempErrors = csvread('AuxiliaryDataFiles/TempErrors.txt');
% CalibrationA = TempErrors(:,1);
% CalibrationB = TempErrors(1:218,2);
% 
% Data = [CalibrationA' CalibrationB'];
% Group = [zeros(1,length(CalibrationA)),ones(1,length(CalibrationB))];
% 
% figure('units','normalized','outerposition',[0.25 0.25 0.55 0.7])
% boxplot(Data,Group,'OutlierSize',4,'Whisker',50,'Labels',{'Calibration Group','Intra-participant Calibration'})
% title('Temperature errors of Calibration group method and Intra-participant calibration method');
% ylabel('Error: ET100-A temperature - Ear-Monitor temperature');

%% Number of hertbeats
% HeartBeats = xlsread('Excels/Statistica.xlsx','HeartBeats','B2:C33');
% Actual = HeartBeats(:,1);
% Headband = HeartBeats(:,2);
% 
% p_Headband = polyfit(Actual,Headband,1);
% Headband_fit1 = p_Headband(1)*Actual + p_Headband(2);
% 
% figure('units','normalized','outerposition',[0.25 0.25 0.55 0.7])
% plot(Actual, Headband, 'b*'); grid; hold on;
% plot(Actual, Headband_fit1, 'b-');
% fplot(x, 'k');
% axis([min(Actual)*0.99 190 100 max(Headband)*1.05]);
% title('Number of beats: Nexus-10 vs. Ear-Monitor'); xlabel('Number of Nexus-10 beats'); ylabel('Number of Ear-Monitor beats'); hold off;


%% Beat period
% HeartPeriod = csvread('AuxiliaryDataFiles/HeartPeriode_ICC.txt');
% Actual = HeartPeriod(:,1);
% Headband = HeartPeriod(:,2);
% 
% p_Headband = polyfit(Actual,Headband,1);
% Headband_fit1 = p_Headband(1)*Actual + p_Headband(2);
% 
% figure('units','normalized','outerposition',[0.25 0.25 0.55 0.7])
% plot(Actual, Headband, 'b*'); grid; hold on;
% plot(Actual, Headband_fit1, 'b-');
% fplot(x, 'k');
% axis([min(Actual)*0.99 max(Actual)*1.01 min(Headband)*0.99 max(Headband)*1.01]);
% title('Beat period: Nexus-10 vs. Ear-Monitor'); xlabel('Nexus-10 period (ms)'); ylabel('Ear-Monitor period (ms)'); hold off;

%% Average hert rate
% AverageHR = csvread('AuxiliaryDataFiles/AverageHR_ICC.txt');
% Actual = AverageHR(:,1);
% Headband = AverageHR(:,2);
% 
% p_Headband = polyfit(Actual,Headband,1);
% Headband_fit1 = p_Headband(1)*Actual + p_Headband(2);
% 
% figure('units','normalized','outerposition',[0.25 0.25 0.55 0.7])
% plot(Actual, Headband, 'b*'); grid; hold on;
% plot(Actual, Headband_fit1, 'b-');
% fplot(x, 'k');
% axis([min(Actual)*0.99 max(Actual)*1.01 min(Headband)*0.99 max(Headband)*1.01])
% title('10-beat average heart rate: Nexus-10 vs. Ear-Monitor'); xlabel('Nexus-10 average heart rate (bpm)'); ylabel('Ear-Monitor average heart rate (bpm)'); hold off;

%% Respiration
Breaths = csvread('AuxiliaryDataFiles/Respiration_ICC.txt');

Actual_All = Breaths(:,1);
Headband_All = Breaths(:,2);
Error_All = Breaths(:,3);
HR_All = Breaths(:,4);
Actual_1 = Breaths(:,5);
Headband_1 = Breaths(:,6);
Error_1 = Breaths(:,7);
HR_1 = Breaths(:,8);
Actual_2 = Breaths(:,9);
Headband_2 = Breaths(:,10);
Error_2 = Breaths(:,11);
HR_2 = Breaths(:,12);

figure('units','normalized','outerposition',[0.25 0.25 0.55 0.7])
plot(Actual_1, Headband_1, 'bo'); hold on;
plot(Actual_All, Headband_All, 'ro');
fplot(x, 'k'); hold off;
axis([3 48 3 48]);
legend('After 1 minute','After 2 minutes','y = x');
xlabel('Number of Nexus-10 breaths'); ylabel('Number of Ear-Monitor breaths');
title('Number of breaths: Nexus-10 vs. Ear-Monitor'); grid; hold off;

figure('units','normalized','outerposition',[0.25 0.25 0.55 0.7])
plot(Error_1, HR_1, 'bo'); hold on;
plot(Error_2, HR_2, 'ro');
legend('Normal breathing','Breathing exercise');
xlabel('Error: No. of Breaths_{Nexus-10} - No. of Breaths_{Ear-Monitor}'); ylabel('Average Heart Rate');
title('Error vs. Average Heart Rate'); hold off;


figure('units','normalized','outerposition',[0.25 0.25 0.55 0.7])
plot(Error_1, Actual_1, 'bo'); hold on;
plot(Error_2, Actual_2, 'ro');
legend('Normal breathing','Breathing exercise');
xlabel('Error: No. of Breaths_{Nexus-10} vs. No. of Breaths_{Ear-Monitor}'); ylabel('Respiratory rate');
axis([-3 6 0 30]);
title('Error vs. Respiratory rate'); grid; hold off;



%%
% Sats = csvread('AuxiliaryDataFiles/SatsAverage_ICC.txt',2);
% Actual = Sats(:,1);
% Headband_meanAbs = Sats(:,2);
% Headband_meanAbs_beats = Sats(:,3);
% Headband_rms = Sats(:,4);
% 
% figure
% plot(Actual, Headband_meanAbs, 'r*'); grid; hold on;
%plot(Actual, Headband_meanAbs_beats, 'g*');
%plot(Actual, Headband_rms, 'b*');
% axis([96 102 90 102]);
% fplot(x, 'k'); hold off;
% 
% figure
% %plot(Actual, Headband_meanAbs, 'r*'); grid; hold on;
% plot(Actual, Headband_meanAbs_beats, 'g*'); hold on;
% %plot(Actual, Headband_rms, 'b*');
% axis([96 102 90 102]);
% fplot(x, 'k'); hold off;
% 
% figure
% %plot(Actual, Headband_meanAbs, 'r*'); grid; hold on;
% %plot(Actual, Headband_meanAbs_beats, 'g*');
% plot(Actual, Headband_rms, 'b*'); hold on;
% axis([96 102 90 102]);
% fplot(x, 'k'); hold off;

% figure
% Sats = csvread('AuxiliaryDataFiles/Sats_ICC.txt',2);
% Actual = Sats(:,1);
% Headband = Sats(:,2);
% plot(Actual, Headband, 'k*'); grid; hold on;
% axis([min(Actual)*0.99 max(Actual)*1.01 min(Headband)*0.99 max(Headband)*1.01])
% fplot(x, 'k'); hold off;
