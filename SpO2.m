clear
clc
format short g

%% Load data

FolderName = 'Data4';
beatText = csvread(strcat(FolderName, '\beatText.txt'),3,0);
ppgText = csvread(strcat(FolderName, '\ppgText.txt'),3,0);
EarPeaksMillis = csvread(strcat(FolderName, '\EarPeaksMillis1.txt'),1,0);

EarSats = beatText(:,6);
time = beatText(:,3);
time = time-time(1);

ppgMillis = ppgText(:,3);
rawIR = ppgText(:,4);
rawRed = ppgText(:,5);
irFiltered = ppgText(:,6);
nPPG = length(rawIR);
X_ppg = 1:nPPG;

%% Calculation

%AC/DC extraction
alpha = 0.7;               
irW = 0;
redW = 0;
irAC = zeros(nPPG,1);
redAC = zeros(nPPG,1);

for i=1:nPPG
    newW  = rawIR(i) + alpha*irW;
    irAC(i) = newW - irW;
    irW = newW;
    
    newW  = rawRed(i) + alpha*redW;
    redAC(i) = newW - redW;
    redW = newW;
end

irDC = rawIR - irAC;
redDC = rawRed - redAC;

%Remove transient strat
irAC = irAC(60:length(irAC));
irDC = irDC(60:length(irDC));
redAC = redAC(60:length(redAC));
redDC = redDC(60:length(redDC));

X_ppg = X_ppg(60:length(X_ppg));
irFiltered = irFiltered(60:length(irFiltered));
ppgMillis = ppgMillis(60:length(ppgMillis));

%Filter
[b, a] = butter(3, 3/(50/2), 'low');

irAC_filt = filter(b,a,irAC);
redAC_filt = filter(b,a,redAC);
irDC_filt = filter(b,a,irDC);
redDC_filt = filter(b,a,redDC);

%SpO2 calcs
r_meanAbs = zeros(length(EarPeaksMillis), 1);
r_rms = zeros(length(EarPeaksMillis), 1);
pos = zeros(length(EarPeaksMillis), 1);

for i = 1:length(EarPeaksMillis)
    pos(i) = find(ppgMillis==EarPeaksMillis(i));
    
    if i<=10
        window = 1:pos(i);
    else
        window = pos(i-10):pos(i);
    end
    
    %Mean Abs value
    irAC_meanAbs = mean(sqrt(irAC_filt(window).^2));
    redAC_meanAbs = mean(sqrt(redAC_filt(window).^2));
    irDC_meanAbs = mean(sqrt(irDC_filt(window).^2));
    redDC_meanAbs = mean(sqrt(redDC_filt(window).^2));
    
    %RMS value
    irAC_rms = rms(irAC_filt(window));
    redAC_rms = rms(redAC_filt(window));
    irDC_rms = rms(irDC_filt(window));
    redDC_rms = rms(redDC_filt(window));
        
    r_meanAbs(i) = (redAC_meanAbs/redDC_meanAbs)/(irAC_meanAbs/irDC_meanAbs);
    r_rms(i) = (redAC_rms/redDC_rms)/(irAC_rms/irDC_rms);
end

windowSize = 500;
r = zeros(length(ppgMillis)-windowSize+1, 1);

for i=windowSize+1:length(ppgMillis)
    irAC_rms = rms(irAC_filt(i-windowSize:i));
    redAC_rms = rms(redAC_filt(i-windowSize:i));
    irDC_rms = rms(irDC_filt(i-windowSize:i));
    redDC_rms = rms(redDC_filt(i-windowSize:i));
    
    r(i) = (redAC_rms/redDC_rms)/(irAC_rms/irDC_rms);
end
r = r(windowSize+1:length(r));
Sats_500 = 113-(25*r);


Sats_meanAbs = 113-(25*r_meanAbs);
Sats_rms = 113-(25*r_rms);

%% Plot
figure();
plot(1:length(EarSats), EarSats); hold on;
plot(1:length(Sats_meanAbs), Sats_meanAbs);
plot(1:length(Sats_rms), Sats_rms);
plot((1:length(Sats_500))./43, Sats_500);
legend('Ear-Monitor Sats','MATLAB Sats_meanAbs', 'MATLAB Sats_rms', 'Sats_500'); hold off;

figure();
plot(ppgMillis, irAC_filt, ppgMillis, redAC_filt);
legend('irAC_filt','redAC_filt');

% figure();
% plot(ppgMillis, irAC_filt, ppgMillis, irFiltered); hold on;
% plot(EarPeaksMillis, 20, 'o', 'Color',[1 0 0], 'MarkerSize', 3, 'MarkerFaceColor', [1 0 0]);
% title('Filtered IR generated by this Sketch and Filtered IR saved by Ear-Monitor. Beats marked generated by MATLAB beat detection');
% legend('irAC','irFiltered'); hold off;


%% Print Results
fprintf('Total SpO2 = %f\n\n', mean(EarSats));
fprintf('Average MATLAB Sats_meanAbs = %f\n\n', mean(Sats_meanAbs));
fprintf('Average MATLAB Sats_rms = %f\n\n', mean(Sats_rms));
fprintf('Average MATLAB Sats_500 = %f\n\n', mean(Sats_500));

