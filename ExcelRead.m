clc;
clear;

syms y;
x = y;


%% Number of hertbeats
HeartBeats = xlsread('Excels/Statistica.xlsx','HeartBeats','B4:C36');
Actual = HeartBeats(:,1);
Headband = HeartBeats(:,2);

p_Headband = polyfit(Actual,Headband,1);
Headband_fit1 = p_Headband(1)*Actual + p_Headband(2);

figure('units','normalized','outerposition',[0.25 0.25 0.55 0.7])
plot(Actual, Headband, 'b*'); grid; hold on;
plot(Actual, Headband_fit1, 'b-');
fplot(x, 'k');
axis([min(Actual)*0.99 max(Actual)*1.05 min(Headband)*0.99 max(Headband)*1.05]);
title('Number of beats: Nexus-10 vs. Ear-Monitor'); xlabel('Number of Nexus-10 beats'); ylabel('Number of Ear-Monitor beats'); hold off;


%% Beat period
HeartPeriod = csvread('AuxiliaryDataFiles/HeartPeriode_ICC.txt');
Actual = HeartPeriod(:,1);
Headband = HeartPeriod(:,2);

p_Headband = polyfit(Actual,Headband,1);
Headband_fit1 = p_Headband(1)*Actual + p_Headband(2);

figure('units','normalized','outerposition',[0.25 0.25 0.55 0.7])
plot(Actual, Headband, 'b*'); grid; hold on;
plot(Actual, Headband_fit1, 'b-');
fplot(x, 'k');
axis([min(Actual)*0.99 max(Actual)*1.01 min(Headband)*0.99 max(Headband)*1.01]);
title('Beat period: Nexus-10 vs. Ear-Monitor'); xlabel('Nexus-10 period (ms)'); ylabel('Ear-Monitor period (ms)'); hold off;

%% Average hert rate
AverageHR = csvread('AuxiliaryDataFiles/AverageHR_ICC.txt');
Actual = AverageHR(:,1);
Headband = AverageHR(:,2);

p_Headband = polyfit(Actual,Headband,1);
Headband_fit1 = p_Headband(1)*Actual + p_Headband(2);

figure('units','normalized','outerposition',[0.25 0.25 0.55 0.7])
plot(Actual, Headband, 'b*'); grid; hold on;
plot(Actual, Headband_fit1, 'b-');
fplot(x, 'k');
axis([min(Actual)*0.99 max(Actual)*1.01 min(Headband)*0.99 max(Headband)*1.01])
title('10-beat average heart rate: Nexus-10 vs. Ear-Monitor'); xlabel('Nexus-10 average heart rate (bpm)'); ylabel('Ear-Monitor average heart rate (bpm)'); hold off;





% Breaths = xlsread('Excels/Statistica.xlsx','RespiratoryRate','B5:D36');
% Actual = Breaths(:,1);
% Headband = Breaths(:,2);
% boxplot(Actual-Headband); grid;
% 
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
