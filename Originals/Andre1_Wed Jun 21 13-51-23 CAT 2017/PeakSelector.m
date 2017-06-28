%% Run this function to manually input the peaks of the Nexus PPG
%Peaks are selected by mouse click
%Nearest max to mouse click is found
%Peaks are stored in text file
%Make sure sample rates are the same!!

%% Load data
Nexus = csvread('Data/Nexus.txt');
NexusPPG = Nexus(:,1);
NexusPPG = detrend(NexusPPG);

sampleRate = 1000/128.55;           %Make sure sample rates are the same!!
NexusTime = 0:sampleRate:length(NexusPPG)*sampleRate-sampleRate;
NexusTime = NexusTime+320;
numNexusPeaks = 0;

for j=0:5
    plot(NexusTime(1+3000*j:3000*(j+1)), NexusPPG(1+3000*j:3000*(j+1)));
    [x, y] = ginput();
    k=1;

    for i=1:length(x)
        while NexusTime(k)<x(i)
            k = k+1;
        end
            NexusPeaks(numNexusPeaks+i,2) = max(NexusPPG(k-20:k+20));
            k = find(NexusPPG==NexusPeaks(numNexusPeaks+i,2));
            NexusPeaks(numNexusPeaks+i,1) = NexusTime(k);
    end
    numNexusPeaks = numNexusPeaks + length(x);
end

fileID = fopen('Data\NexusPeaks.txt','w');
fprintf(fileID,'Time\t\tHeight\r\n');
fprintf(fileID,'%f\t,\t%f\r\n',NexusPeaks');
fclose(fileID);

figure();
plot(NexusTime, NexusPPG); hold on; grid;
plot(NexusPeaks(:,1), NexusPeaks(:,2), 'o', 'Color',[1 0 0],  'MarkerSize', 3, 'MarkerFaceColor', [1 0 0]);
hold off;

