clear
clc
format short g

load AuxiliaryDataFiles/AllDataIndex.mat

meanSureSign = zeros(length(AllDataIndex), 1);
meanSats_meanAbs = zeros(length(AllDataIndex), 1);
meanSats_meanAbs_beats = zeros(length(AllDataIndex), 1);
meanSats_rms = zeros(length(AllDataIndex), 1);

errSats_meanAbs = zeros(length(AllDataIndex), 1);
errSats_meanAbs_beats = zeros(length(AllDataIndex), 1);
errSats_rms = zeros(length(AllDataIndex), 1);


%% Select Data folder
%     DataFolders = dir ('*Data*');
%     str = {DataFolders.name};
%     [folderNum,v] = listdlg('PromptString','Select a data file:','SelectionMode','single','ListString',str);
%     fprintf('Data folder: %s\n\n', char(str(folderNum)));

for n = 1:length(AllDataIndex)
%n=1;
clear r_rms
clear r_meanAbs
clear r_meanAbs_beats
    
%% Load data
%FolderName = char(str(folderNum));
%FolderName = '1. Philip1_Data';
FolderName = AllDataIndex(n);
ppgText = csvread(strcat('Trial1/', FolderName, '\ppgText.txt'),3,0);
EarPeaksMillis = csvread(strcat('Trial1/', FolderName, '\EarPeaksMillis.txt'),1,0);

ppgMillis = ppgText(:,3);
rawIR = ppgText(:,4);
rawRed = ppgText(:,5);
irFiltered = ppgText(:,6);
nPPG = length(rawIR);
X_ppg = ppgMillis;

SureSign = csvread(strcat('Trial1/',  FolderName, '\SureSignSats.txt'));
SureSign_X = (0:1000:119000)' + X_ppg(1);

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
peakIndex(i) = find(X_ppg == EarPeaksMillis(i));
end

for i=1:length(EarPeaksMillis)-numBeats
    irAC_meanAbs = mean(abs(irAC_filt(peakIndex(i):peakIndex(i+numBeats))));
    redAC_meanAbs = mean(abs(redAC_filt(peakIndex(i):peakIndex(i+numBeats))));
    irDC_meanAbs = mean(abs(irDC_filt(peakIndex(i):peakIndex(i+numBeats))));
    redDC_meanAbs = mean(abs(redDC_filt(peakIndex(i):peakIndex(i+numBeats))));

    r_meanAbs_beats(i) = (redAC_meanAbs/redDC_meanAbs)/(irAC_meanAbs/irDC_meanAbs);
end

Sats_meanAbs_beats = 111.2-(25*r_meanAbs_beats);

%%Remove transients
SureSign = SureSign(12:length(SureSign));
SureSign_X = SureSign_X(12:length(SureSign_X));

Sats_meanAbs = Sats_meanAbs(600:length(Sats_meanAbs));
Sats_rms = Sats_rms(600:length(Sats_rms));
X_ppg = X_ppg(600:length(X_ppg));

irAC_filt = irAC_filt(600:length(irAC_filt));
redAC_filt = redAC_filt(600:length(redAC_filt));

Sats_meanAbs_beats = Sats_meanAbs_beats(3:length(Sats_meanAbs_beats));
EarPeaksMillis_X = EarPeaksMillis(numBeats+3:length(EarPeaksMillis));


%% Results
meanSureSign(n) = mean(SureSign);
meanSats_meanAbs(n) = mean(Sats_meanAbs);
meanSats_meanAbs_beats(n) = mean(Sats_meanAbs_beats);
meanSats_rms(n) = mean(Sats_rms);

errSats_meanAbs(n) =  meanSureSign(n)-meanSats_meanAbs(n);
errSats_meanAbs_beats(n) =  meanSureSign(n)-meanSats_meanAbs_beats(n);

errSats_rms(n) =  meanSureSign(n)-meanSats_rms(n);

%% Plot
% figure('name',FolderName, 'units','normalized','outerposition',[0 0 1 1]);
% subplot(2,1,1)
% plot(SureSign_X, SureSign, 'Color',[178/255 48/255 48/255]); hold on;
% plot(X_ppg, Sats_meanAbs, 'Color',[121/255 178/255 196/255]);
% plot(EarPeaksMillis_X, Sats_meanAbs_beats, 'Color',[56/255 52/255 173/255]);
% legend('SureSign Sats', 'MATLAB Sats-meanAbs', 'MATLAB Sats-meanAbs-beats'); hold off;

% subplot(2,1,2)
% plot(X_ppg, irAC_filt); hold on;
% plot(X_ppg, redAC_filt);
% plot(EarPeaksMillis, 50, 'o', 'Color',[1 0 0], 'MarkerSize', 3, 'MarkerFaceColor', [1 0 0]);
% legend('IR AC','Red AC'); hold off;


%% Print Results
% fprintf('Data folder: %s\n\n', FolderName);
% fprintf('Average SureSign \t\t\t\t\t= %f\n', meanSureSign(n));
% fprintf('Average MATLAB Sats_meanAbs \t\t= %f \tSTD: %f\n', meanSats_meanAbs(n), std(Sats_meanAbs));
% fprintf('Average MATLAB Sats_rms \t\t\t= %f \tSTD: %f\n', meanSats_rms(n), std(Sats_rms));
% fprintf('Error between SureSign and Sats_meanAbs\t\t\t= %f\n', errSats_meanAbs(n));
% fprintf('Error between SureSign and Sats_meanAbs_beats\t= %f\n', errSats_meanAbs_beats(n));

fprintf('Data folder: %s\n\n', FolderName);
disp(SureSign);

end

[errSats_meanAbs errSats_meanAbs_beats errSats_rms]
[mean(errSats_meanAbs) mean(errSats_meanAbs_beats) mean(errSats_rms)]