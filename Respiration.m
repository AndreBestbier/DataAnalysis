function [Ear_Period, Nexus_Period] = Respiration(EarPeriod, NexusRSP)

EarFreq = 1000./EarPeriod;

sampleRate = 1000/128;
NexusTime = 0:sampleRate:length(NexusRSP)*sampleRate-sampleRate;

NexusTime = NexusTime(1:length(NexusRSP)-250);
NexusRSP = NexusRSP(1:length(NexusRSP)-250);

n_Nexus = length(NexusRSP);
n_Ear = length(EarPeriod);

X = zeros(n_Ear,1);
X(1) = EarPeriod(1);
for i = 2:n_Ear
    X(i) = X(i-1) + EarPeriod(i);
end

%% Peak detection Nexus
Nexus_Avg = zeros(n_Nexus,1);
Nexus_Peak = zeros(7,2);
Nexus_Period = zeros(2,1);
Nexus_PeakCount = 0;

%Moving average
for i = 1:n_Nexus
    if i<40
        Nexus_Avg(i) = mean(NexusRSP(1:i));
    end
    if i>=40
        Nexus_Avg(i) = mean(NexusRSP(i-39:i));
    end
end

%Peaks
for i = 2:n_Nexus-1
   if  Nexus_Avg(i-1)<Nexus_Avg(i)
      while Nexus_Avg(i+1)==Nexus_Avg(i)
        i = i+1;
      end
      if Nexus_Avg(i+1)<Nexus_Avg(i)
        Nexus_PeakCount = Nexus_PeakCount+1;
        Nexus_Peak(Nexus_PeakCount,1) = NexusTime(i)-170;
        Nexus_Peak(Nexus_PeakCount,2) = Nexus_Avg(i);
      end
   end
end

%Periods
for i = 2:length(Nexus_Peak(:,1))
    Nexus_Period(i-1) = Nexus_Peak(i,1)-Nexus_Peak(i-1,1);
end


%% Peak detection Ear-Monitor

Ear_Peak = zeros(7,2);
Sum = 1;
PeakNum = 1;
Ear_Period = zeros(2,1);


for i = 2:n_Ear-1
   if  EarFreq(i-1)<EarFreq(i) && EarFreq(i)>EarFreq(i+1) && EarFreq(i)>(Sum/PeakNum)*0.9
        Ear_Peak(PeakNum,1) = X(i);
        Ear_Peak(PeakNum,2) = EarFreq(i);
        
        Sum = Sum + EarFreq(i);
        
        
        
        
        PeakNum = PeakNum+1;
   end
end

%Periods
for i = 2:length(Ear_Peak(:,1))
    Ear_Period(i-1) = Ear_Peak(i,1)-Ear_Peak(i-1,1);
end


%% Plot

figure();
subplot(2,1,1);
plot(X, EarFreq, '-o','Color','k',  'MarkerSize', 2, 'MarkerFaceColor', 'k'); grid; hold on;
plot(Ear_Peak(:,1), Ear_Peak(:,2), 'o', 'Color',[1 0 0], 'MarkerSize', 4, 'MarkerFaceColor', [1 0 0]);
axis([0 61000 0.6 1.2]);
title('Ear-Monitor heart beat frequency vs. Time'); legend('Ear-Monitor heart beat frequency', 'Peaks detected');
ylabel('Heart beat frequency (Beats per second)'); xlabel('Time (ms)');  hold off;

subplot(2,1,2);
plot(NexusTime-170, Nexus_Avg, 'k'); grid; hold on;
plot(Nexus_Peak(:,1), Nexus_Peak(:,2), 'o', 'Color',[1 0 0], 'MarkerSize', 4, 'MarkerFaceColor', [1 0 0]);
axis([0 61000 10 80]);
title('Nexus-10 chest expantion vs. Time'); legend('Nexus-10 chest expantion', 'Peaks detected');
ylabel('Voltage (mV)'); xlabel('Time (ms)'); hold off;


end

