clc;
clear;

% HeartBeats = xlsread('Excels/Statistica.xlsx','HeartBeats','B4:C35');
% Actual = HeartBeats(:,1);
% Headband = HeartBeats(:,2);

syms y;
x = y;

% figure
% plot(Actual, Headband, 'k*'); grid; hold on;
% axis([min(Actual)*0.99 max(Actual)*1.05 min(Headband)*0.99 max(Headband)*1.05]);
% fplot(x, 'k'); hold off;
% 
% HeartPeriod = csvread('AuxiliaryDataFiles/HeartPeriode_ICC.txt');
% Actual = HeartPeriod(:,1);
% Headband = HeartPeriod(:,2);
% 
% figure
% plot(Actual, Headband, 'k*'); grid; hold on;
% axis([min(Actual)*0.99 max(Actual)*1.01 min(Headband)*0.99 max(Headband)*1.01]);
% fplot(x, 'k'); hold off;

% AverageHR = csvread('AuxiliaryDataFiles/AverageHR_ICC.txt');
% Actual = AverageHR(:,1);
% Headband = AverageHR(:,2);
% 
% figure
% plot(Actual, Headband, 'k*'); grid; hold on;
% axis([min(Actual)*0.99 max(Actual)*1.01 min(Headband)*0.99 max(Headband)*1.01])
% fplot(x, 'k'); hold off;

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

figure
Sats = csvread('AuxiliaryDataFiles/Sats_ICC.txt',2);
Actual = Sats(:,1);
Headband = Sats(:,2);
plot(Actual, Headband, 'k*'); grid; hold on;
axis([min(Actual)*0.99 max(Actual)*1.01 min(Headband)*0.99 max(Headband)*1.01])
fplot(x, 'k'); hold off;
