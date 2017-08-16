clear
clc

load AuxiliaryDataFiles/AllDataIndex.mat
FolderName = AllDataIndex(1);

%% Load data
ppgText = csvread(strcat('Trial1\SpO2', FolderName, '\ppgText.txt'),3,0);
ppgMillis = ppgText(:,3);
rawIR = ppgText(:,4);
rawRed = ppgText(:,5);
irFiltered = ppgText(:,6);
nPPG = length(rawIR);

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

%% Plot
plot(ppgMillis, irAC_filt); hold on;
plot(ppgMillis, redAC_filt);
plot(EarPeaksMillis, 50, 'o', 'Color',[1 0 0], 'MarkerSize', 3, 'MarkerFaceColor', [1 0 0]);
axis([SureSign_X(1)-1000 SureSign_X(length(SureSign_X))+1000 -100 100]);
legend('IR AC','Red AC'); hold off;
