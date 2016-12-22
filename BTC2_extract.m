%% Generate calibrated BTC 
%  Original script by Marie Kurz, Helmholtz-UFZ (WORMSGRABEN, JUNE 2015). 
%  Adapted by Lara Aylward, Helmholtz-UFZ 

%%  Extracts BTC from full time series (starting @ time of injection)
clear all
close all

%% (1) Load calibrated data files (C1_6## from read_6##.m script)
% load C:/users/aylward/Desktop/MATLAB/Final/NSS/Hydraulics2/2_1_623_Cal.mat     % 623 for port #, depth 1
% load C:/users/aylward/Desktop/MATLAB/Final/NSS/Hydraulics2/2_2_624_Cal.mat     % 624 for port #, depth 2
load C:/users/aylward/Desktop/MATLAB/Final/NSS/Hydraulics2/2_3_625_Cal.mat     % 625 for port #, depth 3

%% (2) Define number of fluorometer
% f = 623;  
% f = 624; 
f = 625; 

%% (3) Define date and C1_6## vectors to use
DateNum = eval(['DateNum_' num2str(f)]);
C1 = eval(['C1_' num2str(f)]);

%% (4) Correct for calibrated concentrations
%      Set all negative concentrations to a value of zero
C1(C1 < 0) = 0;

figure(21)
plot(DateNum, C1(:,1)); hold on
datetick('x', 'dd/mm/yy', 'keepticks', 'keeplimits')     
ylabel('[Uranine] (ppb)');

%% (6) Define time window and extract data from this period only
%      **** P1_ = datenum([yyyy mm dd HH MM SS]); ****

% **** Injection time = 02 May 2016, 16:52:00 ****
P1_inj = datenum([2016 05 02 16 52 00]);

% % 623
% P1I = P1_inj;
% P1F = datenum([2016 05 11 07 41 10]); 
% % Determine P1S by visual inspection (to eliminate false positive concentrations too close to t_inj)
% % Find first zero concentration and export cursor data to workspace
% % P1S = [2.9833 0] DataIndex = 875
% P1S_ind = 1062;
% for n = 1:P1S_ind
%     C1(n,1) = 0;
% end

% % 624
% P1I = P1_inj;
% P1F = datenum([2016 05 11 07 41 10]);
% % P1S = (7.36452e+05, 0); DataIndex = 744
% P1S_ind = 744;
% for n = 1:P1S_ind
%     C1(n,1) = 0;
% end

% 625
P1I = P1_inj;
P1F = datenum([2016 05 11 07 41 10]);
% % P1S = (x, y); DataIndex = #
% P1S_ind = #;
% for n = 1:P1S_ind
%     C1(n,1) = 0;
% end

% Find time window in 6##_Cal.mat data files 
[~,P1I_ind] = min(abs(DateNum-P1I));        
[~,P1F_ind] = min(abs(DateNum-P1F)); 

Extract(:,1) = DateNum(P1I_ind:P1F_ind);           % [DateNum]
Extract(:,2) = C1(P1I_ind:P1F_ind,:);              % [DateNum Ura]
Extract(:,3) = (Extract(:,1) - P1I).*24;           % [DateNum Ura hrSinceInj]
assignin('base', ['P1_' num2str(f)], Extract);     % Renames matrix as P1_6##

%% (7) Plot extracted (cropped) data
%      **** Update Figure Title ****
figure(22)
P1 = eval(['P1_' num2str(f)]);              % Defines P1_### matrix to use
plot(P1(:,3), P1(:,2)); hold on             % x: hrSinceInj  y: extracted conc.
xlabel('Time since injection (hr)');
ylabel('[Uranine] (ppb)');

% title('BTC for Port 2 (12cm below gravel surface)');
% title('BTC for Port 2 (24cm below gavel surface)');
title('BTC for Port 2 (36cm below gravel surface)');       

% savefig('2_1_ExtractPlot.fig');    
% savefig('2_2_ExtractPlot.fig');           
savefig('2_3_ExtractPlot.fig');          

%% (8) Save Extract matrix 
%      Data for BTC (calibration and unnecessary data removed)
%      **** Update filename ****
% save('2_1_BTC_P1', 'P1_623');     
% save('2_2_BTC_P1', 'P1_624');   
save('2_3_BTC_P1', 'P1_625'); 