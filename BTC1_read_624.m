%% 624 Fluorometer data calibration - Uranine only
   % Original script by Julia Knapp, Uni Tübingen 2013/14. 
   % Modified by Marie Kurz, Helmholtz-UFZ 2015. 
   % Adapted by Lara Aylward, Helmholtz-UFZ 2015.

%% Converts fluorometer raw mV data to corresponding concentration
   % Imports fluorometer data from .mv files into Matlab.
   % Calibrates data (without temperature correction). 
   % Saves mV and calibrated data in separate .mat files.
clear all
close all

%% (1) Define path and .mv datafile to import. 
%      **** Change to the folder with data and update .mv file name ****
path(path,'C:/users/aylward/Desktop/MATLAB/Final/NSS/Hydraulics2')    
flu_file = '2_2_f024.mv';

%% (2) Update script with correct fluorometer number (find & replace works i.e SHIFT + ENTER)
%      Read fluoro data into Matlab

    fid = fopen(flu_file);
    T = textscan(fid, '%*s %s %*s %f %f %f %f %f %f %f %*s', 'headerlines', 3); 
    fclose(fid);

    Date_624 = T{1};
    Uranine_624_mv = T{2};
    Resorufin_624_mv = T{3};
    Resazurin_624_mv = T{4};
    Turbidity_624 = T{5};
    Baseline_624 = T{6};
    Battery_624 = T{7};
    Temperature_624 = T{8};
    
% Generate numerical date
DateNum_624 = datenum(Date_624, 'dd/mm/yy-HH:MM:SS');

%% (3) Save raw data. 
%      **** Update file name ****
% save('2_2_624_mV', 'Date_624', 'DateNum_624', 'Turbidity_624', 'Uranine_624_mv', 'Temperature_624');

% warning('off','MATLAB:xlswrite:AddSheet');
% xlswrite('Hydraulics for non-steady flow.xlsx', Date_624, 'Raw Data', 'A2');        % Date format from .mv file
% xlswrite('Hydraulics for non-steady flow.xlsx', DateNum_624, 'Raw Data', 'B2');     % DateNum format from MATLAB

%% (4) Plot raw mV data to extract calibration period by visual inspection
% figure(11)
% subplot(2,1,1)
% plot(Uranine_624_mv, 'g');
% subplot(2,1,2)
% plot(DateNum_624, Uranine_624_mv, 'g'); 
% datetick('x', 'dd/mm/yy', 'keepticks', 'keeplimits')    

%% (5) Define calibration windows 
ind_ura = 158:159;         % Ura window
ind_blank = 1264:1559;     % Blank window

%% (6) Calculate calibrated concentrations (without temperature correction) 

% Define calibration concentrations [ppb = ug/L] 
c_cal_Uranine = 70.0;           % ppb
calib_conc = c_cal_Uranine;

% Blank
blank = mean(Uranine_624_mv(ind_blank));

% Uranine
L1_ura = mean(Uranine_624_mv(ind_ura));
  
% Temperature during calibration
T_calib = mean(Temperature_624(ind_ura));    

% Calculate calibrated concetrations
C1_624 = zeros(length(Temperature_624),1);                         
    for i = 1:length(Temperature_624)
        Raw_signals_minusblank = (Uranine_624_mv - blank)';     
        coeff1 = (L1_ura-blank(1))/calib_conc;
        C1_624(i,:) = (coeff1\Raw_signals_minusblank(:,i))';     
    end

%% (7) Plot calibrated concentrations
%      **** Update figure name ****
figure(12)
plot(DateNum_624, C1_624(:,1), 'g'); 
datetick('x', 'dd/mm/yy', 'keepticks', 'keeplimits'); 
ylim([0 80]);
ylabel('[Uranine] (ppb)'); 
xlabel('Date (dd/mm/yy)');
title('Calibrated Uranine concentration (without temperature correction)');
% savefig('2_2_CalPlot.fig');

%% (8) Save calibrated concentrations. 
%      Saves data without (C1) temperature correction.
%      **** Update file name ****
save('2_2_624_Cal', 'DateNum_624', 'Turbidity_624', 'Temperature_624', 'C1_624');    
