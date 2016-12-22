%% 625 Fluorometer data calibration - Uranine only
   % Original script by Julia Knapp, Uni T�bingen 2013/14. 
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
flu_file = '2_3_f025.mv';

%% (2) Update script with correct fluorometer number (find & replace works i.e SHIFT + ENTER)
%      Read fluoro data into Matlab

    fid = fopen(flu_file);
    T = textscan(fid, '%*s %s %*s %f %f %f %f %f %f %f %*s', 'headerlines', 3); 
    fclose(fid);

    Date_625 = T{1};
    Uranine_625_mv = T{2};
    Resorufin_625_mv = T{3};
    Resazurin_625_mv = T{4};
    Turbidity_625 = T{5};
    Baseline_625 = T{6};
    Battery_625 = T{7};
    Temperature_625 = T{8};
    
% Generate numerical date
DateNum_625 = datenum(Date_625, 'dd/mm/yy-HH:MM:SS');

% %% (3) Save raw data. 
% %    **** Update file name ****
% save('2_3_625_mV', 'DateNum_625', 'Turbidity_625', 'Uranine_625_mv', 'Resorufin_625_mv', 'Resazurin_625_mv', 'Temperature_625'); 

%% (4) Plot raw mV data to extract calibration period by visual inspection
figure(11)
subplot(2,1,1)
plot(Uranine_625_mv, 'g');
subplot(2,1,2)
plot(DateNum_625, Uranine_625_mv, 'g'); 
datetick('x', 'dd/mm/yy-HH:MM', 'keepticks', 'keeplimits')     % dynamicDateTicks

%% (5) Define calibration windows 
ind_ura = 136:137;         % Ura window
ind_blank = 1515:1906;     % Blank window

%% (6) Calculate calibrated concentrations (without temperature correction) 

% Define calibration concentrations [ppb = ug/L] 
c_cal_Uranine = 70.0;           % ppb
calib_conc = c_cal_Uranine;

% Blank
blank = mean(Uranine_625_mv(ind_blank));

% Uranine
L1_ura = mean(Uranine_625_mv(ind_ura));
  
% Temperature during calibration
T_calib = mean(Temperature_625(ind_ura));    

% Calculate calibrated concetrations
C1_625 = zeros(length(Temperature_625),1);                         
    for i = 1:length(Temperature_625)
        Raw_signals_minusblank = (Uranine_625_mv - blank)';     
        coeff1 = (L1_ura-blank(1))/calib_conc;
        C1_625(i,:) = (coeff1\Raw_signals_minusblank(:,i))';     
    end

%% (7) Plot calibrated concentrations
%      **** Update figure name ****
figure(12)
plot(DateNum_625, C1_625(:,1), 'g'); 
datetick('x', 'dd/mm-HH', 'keepticks', 'keeplimits'); 
ylabel('[Uranine] (ppb)'); 
ylim([0 80]);
xlabel('Date & time (dd/mm-hr)');
title('Calibrated Uranine concentration (without temperature correction)');
% savefig('2_3_CalPlot.fig');

%% (8) Save calibrated concentrations. 
%      Saves data without (C1) temperature correction.
%      **** Update file name ****
save('2_3_625_Cal', 'DateNum_625', 'Turbidity_625', 'Temperature_625', 'C1_625');    
