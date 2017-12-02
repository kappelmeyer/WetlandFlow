% MasterDataProc.m
% Pre-processing of experimental data
close all
clear all

%% 
% => USER TO SPECIFY THE FOLLOWING: 
     path(path,'C:/users/aylward/Desktop/MATLAB/Final2017')        % working directory   
     flu_file = '7iii_f025.mv';                                    % experimental data file
     f = 625;                                                      % number of fluorometer
     c_cal_Uranine = 70.0;                                         % Uranine calibration conc. (ppb)
     P1I = datenum([2016 08 22 12 35 00]);                         % Time of injection (YYYY MM DD hh mm ss)
     P1F = datenum([2016 09 15 12 32 00]);                         % End Time of flow test (YYYY MM DD hh mm ss)

     %--------------------------------------------------------------------------------------------------------------
     % User instructions for this sub-section:
     % 1. Set P1S_ind = 0 (see next OPTIONAL section below) 
     % 2. Run script to _____BREAK 1_____
     % 3. In Figure (1), determine calibration windows: 
% =>
             ind_ura = 104:105;                                    % Uranine calibration window (by data index)
             ind_blank = 27220:32820;                              % Baseline calibration window (by data index)
     % 4. Comment out section (2.1)
     % 5. Re-run script to _____BREAK 2_____ - check figure (2)
     %--------------------------------------------------------------------------------------------------------------

     %==============================================================================================================
     % THIS SECTION IS OPTIONAL 
     %  Determine 'data start time' (P1S) by visual inspection 
     %    To eliminate false +ve conc. before the peak
     %    (set all conc. prior to first attainment of 0ppb to zero)
     
     % User instructions for this section:
     %  1. Run script to _____BREAK 2_____
     %  2. In Figure (2), find the first zero conc. after calibration but before the peak
     %  3. Export cursor data to workspace and record 'DataIndex':
% =>          DataIndex =
              P1S_ind = 27111;
     %  4. Comment out section (2.2)
     %  5. Re-run script to _____BREAK 3_____ - check figure (3)                                         
     %===============================================================================================================
     

% NOW PROCEED TO RUNNING REMAINING SECTIONS AFTER _____BREAK 3_____
% It is recommended that each new section be run individually and in numerical order
% Follow instructions as they appear


%% (1) Import data into MATLAB
       [DateNum, Uranine_mv, Temperature] = read(flu_file); 

%% (2) Calibrate data & convert mV to conc. (ppb)
 
% %      (2.1) Plot Uranine mV data to determine calibration windows
%              figure(21)
%              plot(Uranine_mv, 'g');
%              xlabel('Data index')
%              ylabel('Uranine mV')
%              title('Raw data for determination of calibration window')

%__________________________________BREAK 1__________________________________________________            
       
       [C1] = cal(Uranine_mv, Temperature, c_cal_Uranine, ind_ura, ind_blank);

% %      (2.2) Plot calibrated Uranine conc. data       
%              figure(22)
%              plot(DateNum, C1(:,1), 'g'); 
%              datetick('x', 'dd/mm-HH', 'keepticks', 'keeplimits'); 
%              xlabel('Date & time (dd/mm-hr)');
%              ylabel('[Uranine] (ppb)'); 
%              title('Calibrated Uranine conc.');

%__________________________________BREAK 2_________________________________________________ 

%% (3) Extract BTC from full time series (starting @ time of injection)
       [E1] = extract(DateNum, C1, P1I, P1S_ind, P1F);
% => 
       save('7iii_BTC_E1', 'E1')
       
%     (3.1) Plot Uranine BTC (i.e Uranine conc. (ppb) vs time (hrs since inj)) 
             figure(31)
             plot(E1(:,3), E1(:,2)); hold on                     
             xlabel('Time since injection (hr)');
             ylabel('[Uranine] (ppb)');
             title('Uranine BTC')
          
%__________________________________BREAK 3_________________________________________________  
 
%% ========================================================================================
%% Exponential Tail Fit
%  If a tail fit is required: 
%     -> Run MasterTailFit.m using E1 matrix now
%     -> MasterDataProc.m can be closed because the SG Filter will run in MasterTailFit.m
%  If a tail fit is not required: 
%     -> continue to section (4) below
%% ========================================================================================

%% (4) Applies the Savitsky-Golay (SG) filter to smooth the extracted data
       % User instructions for this section:
       % 1. Comment out section (3.1)
       % 2. Update figure title and figure name
       % 3. Run script to end of section (4)

       [F1] = myfilter(E1);
% =>
       save('7ii_BTC_F1', 'F1')
       
%      (4.1) Plot Uranine BTC (Uranine conc. (ppb) vs time (hrs since inj)
             figure(41)
             plot(E1(:,3), E1(:,2), 'g.'); hold on
             plot(F1(:,3), F1(:,2), 'm-', 'LineWidth', 1.25); hold off
             legend('Raw data', 'Filtered data (SG deg5)', 'Location', 'northeast');
             xlabel('Time since injection (hr)');
             ylabel('[Uranine] (ppb)')
% =>         Specify domain and range:
             xlim([0 450])
             ylim([0 6])
% =>
             % title('BTC for Port 2 (12cm below gravel surface)');
             % title('BTC for Port 2 (24cm below gravel surface)');
             % title('BTC for Port 2 (36cm below gravel surface)');  
             title('BTC for Port 7ii');
% =>
             % savefig('2_1_FilterPlot.fig');
             % savefig('2_2_FilterPlot.fig');
             % savefig('2_3_FilterPlot.fig');
             savefig('7ii_FilterPlot.fig');
                        