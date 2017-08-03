clear
clc
format short g

load AllDataIndex.mat              %All names
load TempDataIndex.mat        %All names with valid temp (Excludes Philip and Cobus)
load ControlDataIndex.mat      %4 prticipants used for calibration
load CalibrationDataIndex.mat  %Participants not used for calibration

usedDataSet = CalibrationDataIndex;
err = zeros(length(usedDataSet), 1);

%% Calibration
calData = csvread('TempCal_TrailDataSet.txt');
calTdie = calData(:,1);
calTdie = calTdie + 273.15;
calVsensor = calData(:,2);
calVsensor = calVsensor.*(156.25/1000000000);
calTobj = calData(:,3);

for n = 1:length(usedDataSet)
    
    %% Load data from textfile
    FolderName = usedDataSet(n);
    tempText = csvread(strcat(FolderName, '\tempText.txt'),3,0);
    TobjMCU = tempText(:,4);            %Tobj as calculated by Arduino code used during trial
    Tdie = tempText(:,5);               %Tdie measured by TMP006 in degC
    Vsensor = tempText(:,6);            %Vsensor digialized val from TM006 register
    Tobj_ActualMean = tempText(1,7);    %ET 100-A average temp (degC)
    time = tempText(:,3);               %Millis val from Arduino code
    time = time - time(1);
    
    clicksTemp = csvread(strcat(FolderName, '\ClicksTemp.txt'));
    Tobj_Actual = ones(length(Tdie),1)*Tobj_ActualMean;
    


    %% Call CalCurveFunction to calculate Tobj
    Tobj = CalCurveFunction(Tdie, Vsensor);


    %% Results
    err(n) = mean(abs(Tobj_Actual-Tobj));
    

    %% Plot
    % figure('name',FolderName, 'units','normalized','outerposition',[0 0 1 1]);
    % plot(time, TobjMCU, 'Color',[168/255 224/255 222/255]); hold on;
    % plot(time, Tobj, 'o-', 'Color',[55/255 95/255 153/255], 'MarkerSize', 2, 'MarkerFaceColor', [55/255 95/255 153/255]);
    % plot([1 time(length(time))], [meanClicksTemp meanClicksTemp], 'Color',[145/255 43/255 43/255]);
    % plot(time, Tdie_digital);
    % legend('Tobj(MATLAB)', 'Tobj(MCU)', 'Tclicks', 'Tdie');
    % axis([0 inf 34 39]);
    % hold off;

    %% Print Results
%     fprintf(FolderName);
%     fprintf('\nAverage Clicks temp\t\t\t\t\t= %f\t\tSTD: %f\n', Tobj_ActualMean, std(clicksTemp));
%     fprintf('Average ear object temp (MATLAB) \t= %f\t\tSTD: %f\n', mean(Tobj), std(Tobj));
%     fprintf('Average ear object temp (MCU) \t\t= %f\t\tSTD: %f\n', mean(TobjMCU), std(TobjMCU));
%     fprintf('Error (MATLAB) \t\t= %f degC\n\n', err(n));
    
    %disp([Tdie Vsensor Tobj_Actual]);

    disp(FolderName);
    disp([Tobj_Actual Tobj]);
    disp(err(n));
    
    

    % disp(FolderName);
%     for q=1:length(Tobj)
%         fprintf('%f\t,\t%f\t,\t%f\n', Tdie(q), Vsensor(q), Tobj_Actual(q));
%     end
%     fprintf('\n');

    %disp(FolderName);
    % fprintf('Tdie STD\t%f\n', std(Tdie_digital));
    % fprintf('Vsensor STD\t%f',  std(Vsensor_digital));
    % fprintf('\n\n\n\n\n\n\n\n\n\n\n\n');
end

disp('Errors');
disp(err);

























% tdie_tref = zeros(length(TobjEar), 1);
% S = zeros(length(TobjEar), 1);
% Vos = zeros(length(TobjEar), 1);
% fVsensor = zeros(length(TobjEar), 1);
% Tobj = zeros(length(TobjEar), 1);
% 
% for i=1:length(TobjEar)
% Vsensor(i) = Vsensor(i).*(156.25/1000000000);  %Convert digital value to voltage (156.25 per LSB)
% %Tdie(i) = Tdie(i).*0.03125;              %Convert digital value to deg C (0.03125 per LSB)
% Tdie(i) = Tdie(i) + 273.15;                 %Convert deg C to Kelvin
% 
% tdie_tref(i) = Tdie(i) - T_ref;
% S(i) = S0*(1 + A1*tdie_tref(i) + A2*tdie_tref(i)^2);
% 
% Vos(i) = B0 + B1*tdie_tref(i) + B2*tdie_tref(i)^2;
% 
% fVsensor(i) = (Vsensor(i) - Vos(i)) + C*(Vsensor(i)-Vos(i))^2;
% 
% Tobj(i) = sqrt(sqrt(Tdie(i)^4 + fVsensor(i)/S(i)));
% 
% Tobj(i) = Tobj(i) - 273.15;     %Convert Kelvin back to deg C
% end



