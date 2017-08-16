clear
clc
format short g

load AuxiliaryDataFiles/AllDataIndex.mat

meanSureSign = zeros(length(AllDataIndex), 1);
meanSats_meanAbs = zeros(length(AllDataIndex), 1);
meanSats_meanAbs_beats1 = zeros(length(AllDataIndex), 1);
meanSats_meanAbs_beats2 = zeros(length(AllDataIndex), 1);
meanSats_rms = zeros(length(AllDataIndex), 1);

errSats_meanAbs = zeros(length(AllDataIndex), 1);
errSats_meanAbs_beats1 = zeros(length(AllDataIndex), 1);
errSats_meanAbs_beats2 = zeros(length(AllDataIndex), 1);
errSats_rms = zeros(length(AllDataIndex), 1);


for n = 1:length(AllDataIndex)
clear r_rms
clear r_meanAbs
clear r_meanAbs_beats
    
%% Load data
%FolderName = char(str(folderNum));
%FolderName = '1. Philip2_Data';
FolderName = AllDataIndex(n);

ppgText = csvread(strcat('Trial1/', FolderName, '\ppgText.txt'),3,0);
EarPeaksMillis = csvread(strcat('Trial1/', FolderName, '\EarPeaksMillis.txt'),1,0);%Peaks in Processing time

ppgMillis = ppgText(:,3);
rawIR = ppgText(:,4);
rawRed = ppgText(:,5);
irFiltered = ppgText(:,6);
nPPG = length(rawIR);

SureSign = csvread(strcat('Trial1/',  FolderName, '\SureSignSats.txt'));
SureSign_X = (1000:1000:120000)' + ppgMillis(1);

%% AC/DC extraction
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

%% Filter
[b, a] = butter(3, 3/(50/2), 'low');

irAC_filt = filter(b,a,irAC);
redAC_filt = filter(b,a,redAC);
irDC_filt = filter(b,a,irDC);
redDC_filt = filter(b,a,redDC);

%% Fixed window
windowSize = 50;
r = zeros(length(ppgMillis)-windowSize+1, 1);

for i=windowSize+1:length(ppgMillis)
    irAC_rms = rms(irAC_filt(i-windowSize:i));
    redAC_rms = rms(redAC_filt(i-windowSize:i));
    irDC_rms = rms(irDC_filt(i-windowSize:i));
    redDC_rms = rms(redDC_filt(i-windowSize:i));
    
    r_rms(i) = (redAC_rms/redDC_rms)/(irAC_rms/irDC_rms);
    
    irAC_meanAbs = mean(abs(irAC_filt(i-windowSize:i)));
    redAC_meanAbs = mean(abs(redAC_filt(i-windowSize:i)));
    irDC_meanAbs = mean(abs(irDC_filt(i-windowSize:i)));
    redDC_meanAbs = mean(abs(redDC_filt(i-windowSize:i)));
    
    r_meanAbs(i) = (redAC_meanAbs/redDC_meanAbs)/(irAC_meanAbs/irDC_meanAbs);
end
Sats_meanAbs = 111.2-(25*r_meanAbs);
Sats_rms = 111.51-(25*r_rms);

%% Beat dependant window
numBeats = 12;

peakIndex = zeros(length(EarPeaksMillis)+1, 1);
peakIndex(1) = 1;
for i=2:length(EarPeaksMillis)
    peakIndex(i) = find(ppgMillis == EarPeaksMillis(i));
end

for i=1:length(EarPeaksMillis)-numBeats
    irAC_meanAbs = mean(abs(irAC_filt(peakIndex(i):peakIndex(i+numBeats))));
    redAC_meanAbs = mean(abs(redAC_filt(peakIndex(i):peakIndex(i+numBeats))));
    irDC_meanAbs = mean(abs(irDC_filt(peakIndex(i):peakIndex(i+numBeats))));
    redDC_meanAbs = mean(abs(redDC_filt(peakIndex(i):peakIndex(i+numBeats))));

    r_meanAbs_beats(i) = (redAC_meanAbs/redDC_meanAbs)/(irAC_meanAbs/irDC_meanAbs);
end

Sats_meanAbs_beats1 = 111.2-(25*r_meanAbs_beats);
Sats_meanAbs_beats2 = 100-(100-(111.2-(25*r_meanAbs_beats)))*0.6;

%% Second by second comparison
for q=1:60
    
    SatsActual(q) = SureSign(59+q);
    time = SureSign_X(59+q);
    [val, idx] = min(abs(EarPeaksMillis-time));
    closest = EarPeaksMillis(idx);
    SatsHeadband(q) = Sats_meanAbs_beats2(idx-12);
    
    %disp([SatsActual(q) SatsHeadband(q)]);
    
end
%disp(SatsActual')

%% Remove transients
SureSign = SureSign(12:length(SureSign));
SureSign_X = SureSign_X(12:length(SureSign_X));

Sats_meanAbs = Sats_meanAbs(600:length(Sats_meanAbs));
Sats_rms = Sats_rms(600:length(Sats_rms));
ppgMillis = ppgMillis(600:length(ppgMillis));

irAC_filt = irAC_filt(600:length(irAC_filt));
redAC_filt = redAC_filt(600:length(redAC_filt));

Sats_meanAbs_beats1 = Sats_meanAbs_beats1(3:length(Sats_meanAbs_beats1));
Sats_meanAbs_beats2 = Sats_meanAbs_beats2(3:length(Sats_meanAbs_beats2));
EarPeaksMillis_X = EarPeaksMillis(numBeats+3:length(EarPeaksMillis));

EarPeaksMillis_X = EarPeaksMillis_X-EarPeaksMillis_X(1);
ppgMillis = ppgMillis-ppgMillis(1);
SureSign_X = SureSign_X-SureSign_X(1);

%% Results
meanSureSign(n) = mean(SureSign);
meanSats_meanAbs(n) = mean(Sats_meanAbs);
meanSats_meanAbs_beats1(n) = mean(Sats_meanAbs_beats1);
meanSats_meanAbs_beats2(n) = mean(Sats_meanAbs_beats2);
meanSats_rms(n) = mean(Sats_rms);

errSats_meanAbs(n) =  meanSureSign(n)-meanSats_meanAbs(n);
errSats_meanAbs_beats1(n) =  meanSureSign(n)-meanSats_meanAbs_beats1(n);
errSats_meanAbs_beats2(n) =  meanSureSign(n)-meanSats_meanAbs_beats2(n);
errSats_rms(n) =  meanSureSign(n)-meanSats_rms(n);

% Plot
figure('name',FolderName, 'units','normalized','outerposition',[0 0 1 1]);
subplot(2,1,1)
plot(SureSign_X, SureSign, 'Color',[178/255 48/255 48/255]); hold on;
plot(ppgMillis, Sats_meanAbs, 'Color',[121/255 178/255 196/255]);
plot(EarPeaksMillis_X, Sats_meanAbs_beats1, 'Color',[56/255 52/255 173/255]);
plot(EarPeaksMillis_X, Sats_meanAbs_beats2, 'Color',[200/255 100/255 173/255]);
axis([SureSign_X(1)-1000 SureSign_X(length(SureSign_X))+1000 92 103]);
%legend('SureSign Sats', 'MATLAB Sats-meanAbs', 'MATLAB Sats-meanAbs-beats1', 'MATLAB Sats-meanAbs-beats2'); hold off;

subplot(2,1,2)
plot(ppgMillis, irAC_filt); hold on;
plot(ppgMillis, redAC_filt);
plot(EarPeaksMillis, 50, 'o', 'Color',[1 0 0], 'MarkerSize', 3, 'MarkerFaceColor', [1 0 0]);
axis([SureSign_X(1)-1000 SureSign_X(length(SureSign_X))+1000 -100 100]);
legend('IR AC','Red AC'); hold off;


%% Print Results
% fprintf('\n\nData folder: %s\n', FolderName);
% fprintf('Average SureSign \t\t\t\t\t= %f\n', meanSureSign(n));
% fprintf('Average MATLAB Sats_meanAbs \t\t= %f \tSTD: %f\n', meanSats_meanAbs(n), std(Sats_meanAbs));
% fprintf('Average MATLAB Sats_rms \t\t\t= %f \tSTD: %f\n', meanSats_rms(n), std(Sats_rms));
% fprintf('Error between SureSign and Sats_meanAbs\t\t\t= %f\n', errSats_meanAbs(n));
% fprintf('Error between SureSign and Sats_meanAbs_beats\t= %f\n', errSats_meanAbs_beats(n));

% fprintf('Data folder: %s\n\n', FolderName);
% disp(SureSign);

%disp(FolderName);
%disp([SatsActual' SatsHeadband']);
fprintf('%f\n', SatsHeadband'); %, SatsHeadband'


end
% fprintf('%f\t,\t%f\t,\t%f\t,\t%f\n', meanSureSign, meanSats_meanAbs, meanSats_meanAbs_beats1, meanSats_meanAbs_beats2)
% 
% syms y;
% x = y;
% 
% figure
% plot(meanSureSign, meanSats_meanAbs_beats2, 'r*'); grid; hold on;
% axis([96 102 90 102]);
% fplot(x, 'k'); hold off;

