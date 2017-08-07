clear
clc
format short g

%% Select Data folder
DataFolders = dir ('Trial1/*Data*');
str = {DataFolders.name};
[folderNum,v] = listdlg('PromptString','Select a data file:','SelectionMode','single','ListString',str);

fprintf('Data folder: %s\n', char(str(folderNum)));

%% Loading text files--------------------------------------------------------------------------
FolderName = char(str(folderNum));
ppgText = csvread(strcat('Trial1/', FolderName, '/ppgText.txt'), 3,0);
beatText = csvread(strcat('Trial1/', FolderName, '/beatText.txt'), 3,0);
tempText = csvread(strcat('Trial1/', FolderName, '/tempText.txt'), 3,0);
Nexus = csvread(strcat('Trial1/', FolderName, '/Nexus.txt'));
NexusPeaks = csvread(strcat('Trial1/', FolderName, '/NexusPeaks.txt'), 1,0);

%Ear PPG Data variables
EarPPG = ppgText(:,6);      %Change to 7 for Andre1, 6 for rest
EarSeconds = ppgText(:,2);
EarMillis = ppgText(:,3);
n = length(EarPPG);
EarPPG_X = zeros(n,1);
SSF = zeros(n,1);

%Nexus Data variables
NexusPPG = Nexus(:,1);
NexusRSP = Nexus(:,2);
NexusPPG = detrend(NexusPPG);

% Nexus X-axis generation
sampleRate = 1000/128.55;
NexusPPG_X = 0:sampleRate:length(NexusPPG)*sampleRate-sampleRate;
NexusPPG_X = NexusPPG_X+320;

%% Dynamic x-axis generation for Ear-Monitor---------------------------------------------------
i=1;
j=1;
time = EarSeconds(1);
secInterval = 1;
M = zeros(50, 60);

while i<=length(EarPPG)
    if EarSeconds(i) == time
        M(j,secInterval) = EarPPG(i);
        j = j+1;    
    else
        numSamples = j-1;
        period = 1000/numSamples;
        
        for k = i-numSamples:i-1
            EarPPG_X(k+1) = EarPPG_X(k) + period;
        end
        secInterval=secInterval+1;
        M(1,secInterval) = EarPPG(i);
        time = EarSeconds(i+1);
        j=2;
    end
    i=i+1;
end

numSamples = j-1;
period = 1000/numSamples;
     
for k = i-numSamples:i-2
    EarPPG_X(k+1) = EarPPG_X(k) + period;
end

%% SSF window size followed by calling the SSF function
w = 10;             
for i=1:n
    if i>w
        window = EarPPG((i-1):-1:(i-w));
        SSF(i) = SSF_function(window);
    else
        SSF(i) = 0;
    end    
end

%% Beat Detection Ear
prev_beatMillis = EarPPG_X(1);
beatDelay = 500;
beatPeriodSum = 0;
beatPeriodMillis = zeros(10,1);
beatPeriodAverage = 0;
threshold = ones(n,1).*10;
stdev = zeros(n,1);
numOfPeaks_Ear = 0;

%Beat betection function Ear
for i=2:n-1 %Start at the 2nd
    tempBeatPeriod = EarPPG_X(i)-prev_beatMillis;
    if numOfPeaks_Ear>=3
        thres_Window = EarPeaks(numOfPeaks_Ear-1:numOfPeaks_Ear, 2);
        peakmean = mean(thres_Window);
        threshold(i) = peakmean/2;    
    end
    
    if tempBeatPeriod > 2*beatPeriodAverage
        %fprintf('Reset threshold at %d\n', EarPPG_X(i));
        threshold(i) = 10;
    end


    if SSF(i) > threshold(i) && tempBeatPeriod > beatDelay && SSF(i-1)<=SSF(i) && SSF(i)>SSF(i+1)
        beatPeriodSum = beatPeriodSum - beatPeriodMillis(10);
        numOfPeaks_Ear = numOfPeaks_Ear+1;
        
        for j=10:-1:2
            beatPeriodMillis(j) = beatPeriodMillis(j-1); 
        end
        
        if tempBeatPeriod>1500
            beatPeriodMillis(1) = 1500;
        elseif tempBeatPeriod<500
            beatPeriodMillis(1) = 500;
        else
            beatPeriodMillis(1) = tempBeatPeriod;
        end
        
        prev_beatMillis = EarPPG_X(i);
        
        beatPeriodSum = beatPeriodSum + beatPeriodMillis(1);
        beatPeriodAverage = beatPeriodSum/10;
        beatDelay = 0.7*beatPeriodAverage;
        EarPeaks(numOfPeaks_Ear,1) = EarPPG_X(i);
        EarPeaks(numOfPeaks_Ear,2) = SSF(i);
        EarPeakMillis(numOfPeaks_Ear) = EarMillis(i);
        
        if numOfPeaks_Ear>1
            EarPeriod(numOfPeaks_Ear-1,1) = beatPeriodMillis(1);
        end
    end
end

for i=1:length(EarPeaks)-1
    EarPeriod(i) = EarPeaks(i+1,1) - EarPeaks(i,1);
end

fileID = fopen(strcat('Trial1/', FolderName, '\EarPeaksMillis.txt'),'w');
fprintf(fileID,'Millis\r\n');
fprintf(fileID,'%d\r\n',EarPeakMillis');
fclose(fileID);

%% Nexus Periods
numOfPeaks_Nexus = length(NexusPeaks);
NexusPeriod = zeros(length(NexusPeaks)-1,1);

for i=2:length(NexusPeaks)
    NexusPeriod(i-1) = NexusPeaks(i,1) - NexusPeaks(i-1,1);
end

%% Plot peak detection
Period_X = 1:numOfPeaks_Nexus-1;

figure('name',FolderName);
subplot(2,1,1);
plot(EarPPG_X, SSF, 'k'); grid; hold on;
plot(EarPPG_X, threshold);
plot(EarPeaks(:,1), EarPeaks(:,2), 'o', 'Color',[1 0 0], 'MarkerSize', 3, 'MarkerFaceColor', [1 0 0]);
title('Ear-Monitor: Beat Detection'); legend('Ear-Monitor SSF', 'Threshold', 'Beats detected');
ylabel('Ear-Monitor SSF value'); xlabel('Time (MS)'); hold off;

subplot(2,1,2);
plot(NexusPPG_X, NexusPPG, 'k'); grid; hold on;
plot(NexusPeaks(:,1), NexusPeaks(:,2), 'o', 'Color',[1 0 0],  'MarkerSize', 3, 'MarkerFaceColor', [1 0 0]);
title('Nexus-10: Beat Annotation'); legend('Nexus-10 PPG','Beats annotated');
ylabel('nexus-10 PPG value'); xlabel('Time (MS)'); hold off;

%% Plot magnatude envelopes
[upEar, loEar] = envelope(EarPPG, 40,'peak');
[upNexus, loNexus] = envelope(NexusPPG, 115,'peak');

clipStartEar = 30;
clipEndEar = 50;
upEar = upEar(clipStartEar:length(upEar)-clipEndEar);
loEar = loEar(clipStartEar:length(loEar)-clipEndEar);
earTimePPGx = EarPPG_X(clipStartEar:length(EarPPG_X)-clipEndEar);

clipStartNexus = 50;
clipEndNexus = 100;
upNexus = upNexus(clipStartNexus:length(upNexus)-clipEndNexus);
loNexus = loNexus(clipStartNexus:length(loNexus)-clipEndNexus);
NexusTimex = NexusPPG_X(clipStartNexus:length(NexusPPG_X)-clipEndNexus);

figure('name',FolderName);
subplot(2,1,1);
plot(EarPPG_X, EarPPG, 'k'); grid; hold on;
plot(earTimePPGx, upEar, '--k', earTimePPGx, loEar, '--k');
title('Ear-Monitor PPG and envelopes'); legend('Ear-Monitor PPG','Envelopes');
ylabel('PPG value'); xlabel('Time (ms)'); hold off;

subplot(2,1,2);
plot(NexusPPG_X, NexusPPG, 'k'); grid; hold on;
plot(NexusTimex, upNexus, '--k', NexusTimex, loNexus, '--k');
title('Nexus-10 PPG and envelopes'); legend('Nexus-10 PPG','Envelopes');
ylabel('PPG value'); xlabel('Time (ms)'); hold off;

magnatudeEar = upEar-loEar;
magnatudeNexus = upNexus-loNexus;

mean_magnatudeEar = mean(magnatudeEar);
mean_magnatudeNexus = mean(magnatudeNexus);

%% Plot peaks overlapping
figure('name',FolderName);
plot(EarPPG_X, SSF); grid; hold on;
plot(EarPeaks(:,1), EarPeaks(:,2), 'o', 'Color',[0 0 1], 'MarkerSize', 3, 'MarkerFaceColor', [0 0 1]);
plot(NexusPPG_X, NexusPPG); grid;
plot(NexusPeaks(:,1), NexusPeaks(:,2), 'o', 'Color',[1 0 0],  'MarkerSize', 3, 'MarkerFaceColor', [1 0 0]);
hold off;

%% Plot resperation (RSP)
EarPeriod_DT = detrend(EarPeriod);
NexusRSP_DT = detrend(NexusRSP);
numBreathsDetected = 0;

EarPeriod_MA = zeros(length(EarPeriod_DT),1);
for i=2:length(EarPeriod_DT)
    EarPeriod_MA(i) = mean(EarPeriod_DT(i-1:i));
end

figure('name',FolderName);
%plot(EarPeaks(1:numOfPeaks_Ear-1, 1), EarPeriod_DT, '-o', 'MarkerSize', 3, 'MarkerFaceColor', 'k'); hold on;
plot(NexusPPG_X, NexusRSP_DT.*10); hold on;
plot(EarPeaks(1:numOfPeaks_Ear-1, 1), EarPeriod_MA, '-o', 'MarkerSize', 3, 'MarkerFaceColor', 'y'); hold on;
title(strcat(FolderName, ': Resperation Plots')); xlabel('Time (ms)'); ylabel('Nexus chest expantion and Ear-Monitor beat period');

for i=2:length(EarPeriod_MA)-1
    if EarPeriod_MA(i)<EarPeriod_MA(i-1) && EarPeriod_MA(i)<EarPeriod_MA(i+1)
    plot(EarPeaks(i, 1), EarPeriod_MA(i), 'r*');
    numBreathsDetected = numBreathsDetected+1;
    end
end



legend('Ear-Monitor beat period','Chest expantion'); hold off;

%% Plot Average HR
for i=1:length(EarPeriod)-10
    meanPeriodEar = mean(EarPeriod(i:i+9));
    bpmEar(i,1) = 60000/meanPeriodEar;
end

for i=1:length(NexusPeriod)-10
    meanPeriodNexus = mean(NexusPeriod(i:i+9));
    bpmNexus(i,1) = 60000/meanPeriodNexus;
end


if numOfPeaks_Ear==numOfPeaks_Nexus
    %% Stats
    periodErr = abs(NexusPeriod-EarPeriod);
    meanPeriodErr = mean(periodErr);

    errBPM = abs(bpmNexus-bpmEar);
    meanBpmErr = mean(errBPM);
    BeatsTime = 1:length(errBPM);


    %% Plot Periods
    figure('name',FolderName);
    subplot(2,1,1);
    plot(Period_X, EarPeriod, '-*', 'Color', 'k', 'MarkerSize', 4); hold on; grid;
    plot(Period_X, NexusPeriod, '--o','Color','k',  'MarkerSize', 3, 'MarkerFaceColor', 'k');
    title('Beat periods (msec)'); legend('Ear-Monitor Period', 'Nexus-10 Period');
    subplot(2,1,2);
    plot(Period_X, NexusPeriod-EarPeriod, 'k-.');
    title('Beat period error (msec)'); legend('Error (Scaled)');
    ylabel('Period time (ms)'); xlabel('Period number'); hold off;


    figure('name',FolderName);
    plot(BeatsTime, bpmEar, '-*', 'Color', 'k', 'MarkerSize', 4); grid; hold on;
    plot(BeatsTime, bpmNexus, '--o','Color','k',  'MarkerSize', 3, 'MarkerFaceColor', 'k');
    title('10-beat mean heartrate'); legend('bpmEar', 'bpmNexus');
    ylabel('Ten-beat mean heartrate (bpm)'); xlabel('Calculation number'); hold off;

end



%% Print Results
fprintf('Number of peaks detected\n');
fprintf('\tEar-Monitor:\t%d\n', numOfPeaks_Ear);
fprintf('\tNexus:\t\t\t%d\n', numOfPeaks_Nexus);
fprintf('\t%%\t\t\t\t%d%%\n\n', numOfPeaks_Ear/numOfPeaks_Nexus*100);
fprintf('Breaths detected %d\n\n', numBreathsDetected);

if numOfPeaks_Ear==numOfPeaks_Nexus
    fprintf('Mean period Err (ms)\n');
    fprintf('\tPeriod Err\t\t%f\n\n', meanPeriodErr);
    fprintf('Mean bpm Err\n');
    fprintf('\tBPM Err\t\t\t%f\n\n', meanBpmErr);
    fprintf('Mean magnetudes\n');
    fprintf('\tEar-Monitor:\t%f\n', mean_magnatudeEar);
    fprintf('\tNexus:\t\t\t%f\n', mean_magnatudeNexus);
    fprintf('Mean Breath Period Err\n');
else
    fprintf('Not all the beats were detected by the Ear-Monitor!!\n\n');
end
%fprintf('\tPeriod Err:\t\t%f\n', mean_errBreathPeriod);




















%% Respiratory rate
% [Ear_BreathingPeriod, Nexus_BreathingPeriod] = Respiration(EarPeriod, NexusRSP);
% errBreathPeriod = abs(Ear_BreathingPeriod - Nexus_BreathingPeriod);
% mean_errBreathPeriod = mean(errBreathPeriod);


%% Beat Detection Nexus (auto)
% peak_Num_Nexus = 0;
% prev_Peak = 0;
% sum = 0;
% 
% for i=1:length(NexusPPG)
%     sum = sum+NexusPPG(i);
% end
% avg = sum/length(NexusPPG);
% threshold_Nexus = 5;
% 
% for i=2:length(NexusPPG)-1
%     if NexusPPG(i)>threshold_Nexus
%        if NexusPPG(i-1)<NexusPPG(i) && NexusPPG(i)>=NexusPPG(i+1) && NexusTime(i)-prev_Peak>300
%             peak_Num_Nexus = peak_Num_Nexus+1;
%             NexusPeaks(peak_Num_Nexus,1) = NexusTime(i);
%             NexusPeaks(peak_Num_Nexus,2) = NexusPPG(i);
%             prev_Peak = NexusTime(i);
% 
%             if peak_Num_Nexus>1
%                  NexusPeriod(peak_Num_Nexus-1,1) = NexusPeaks(peak_Num_Nexus,1)-NexusPeaks(peak_Num_Nexus-1,1);
%             end
%             
%             if peak_Num_Nexus>2
%                 %threshold_Nexus = mean(NexusPeaks(peak_Num2-2:peak_Num2,2))*1.5;
%                 %disp(threshold_Nexus);
%             end
%         end
%     end
% 
% end