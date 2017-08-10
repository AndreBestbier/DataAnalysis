clc;
clear;

HeartBeats = xlsread('Excels/Statistica.xlsx','HeartBeats','B4:C35');
Actual = HeartBeats(:,1);
Headband = HeartBeats(:,2);

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

AverageHR = csvread('AuxiliaryDataFiles/AverageHR_ICC.txt');
Actual = AverageHR(:,1);
Headband = AverageHR(:,2);

figure
plot(Actual, Headband, 'k*'); grid; hold on;
axis([min(Actual)*0.99 max(Actual)*1.01 min(Headband)*0.99 max(Headband)*1.01])
fplot(x, 'k'); hold off;