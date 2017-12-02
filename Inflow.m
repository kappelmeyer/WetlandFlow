%% Inflow.m
%  To create a vector of inlet volumetric flowrates for every flowtest sampling time
%  (i.e. 10s intervals from time of injection to time of termination)
%  NOTE: ' => ' indicates where user inputs are required

%  Requires: 
%           1. full flowtest sampling time vector - hrs since injection format (time)
%              -> already calibrated and extracted
%           2. inflow cycle DateTime [ t_in ] and corresponding volumetric flowrate [ q_in ]

%  Creates a zero matrix of size(time) to represent Q_in
%  Compares every (time) to (t_in)
%    Then assigns a volumetric flowrate to replace each zero for every sample time
%    **** (time) and (Q_in) must have the same dimensions ****

%% User Instructions:
%  1. Follow instructions as they are given below

close all
clear all

%% (1) Load experimental data: time & [Uranine]
% => 
     load C:/users/Lara/Desktop/MATLAB/Final2017/1_2_BTC_F1.mat
     % F1(:,1): time (DateNum)
     % F1(:,2): [Uranine] (ppb)  
     % F1(:,3): time (hrs since inj)

% *** Injection time = 12 April 2016, 12:21:20 ***
% => 
     t_inj = datenum([2016 04 12 12 21 20]); 

% *** End of Flowtest = 18 April 2016, 09:43:30 ***
% =>  
     t_end = datenum([2016 04 18 09 43 30]); 

%% (2) Fluoro flowtest data

% (2.1) If NO tail-fit has been performed:
time = F1(:,3);
time_end = time(end,1);
time(1,1) = 0;

% (2.2) If a tail-fit HAS been performed:
%       ! CHECK: index corresponding to t_end
% =>
%      time = F1(1:120532, 1);           
% 
% time_end = time(end,1);     
% time(1,1) = 0;
%__________________________________________________________________________
%
% conc: for each time (from injectin to termination)
% ! CHECK: index corresponding to t_end
% =>
     conc = F1(:,2);

conc(conc < 0) = 0;

%% (3) Inflow LOG data
%      Save Excel file (LOG#.xlsx) containing flow rate data into MATLAB current folder 
%      (see LOG_Template.xlsx for required spreadsheet layout)
%      ! CHECK: start & end time of LOG data = start & end time of flow test

%  (3.1) ENTER spreadsheet name & cell references for 'Log_in' & 'q_in'
% =>
     Log_in = xlsread('LOG1.xlsx', 'LogData', 'A2:A479');         % Inflow cycle start DateTime (Excel numeric format)

t_in = datetime(Log_in,'ConvertFrom','excel');
T_in = datenum(t_in);
T_in_hr = (T_in - t_inj).*24;                                     % time since injection (hrs)

% =>
     q_in = xlsread('LOG1.xlsx', 'LogData', 'C2:C479');           % Inlet volumetric flowrate (L/h)

%  (3.2) ! CHECK: agreement between 'in' start & end times
%        1. Run script now, up until the end of section (3.2)
%        2. If start & end times are in agreement, continue with (3.3)
start_in = T_in_hr(1,1);
stop_in = T_in_hr(end,1);
check_start_in = abs(time(1,1) - start_in);     % should be zero if both entries represent the same DateTime
check_stop_in = abs(time_end - stop_in);        % should be zero if both entries represent the same DateTime

%  (3.3) ! CHECK: time vectors
%        1. Adjust LOG spreadsheet indexes and assign Q_in(1,1) now before
%           continuing to section (4) (explanation follows directly below and
%           an example is contained in Example_Adjustment_Inflow_section3_3.m)

%   time(2,1) may not be 0.0028hr (10s) after t_inj = 0
%   -> open time and T_in_hr in the variable window
%   -> if time(2,1) does not = t_inj + 0.0028hr (10s) &
%         time(2,1) > T_in_hr(2,1)
%      then t_in from LOGx.xlsx must be set = to time(2,1) by adjusting the 
%      cells referenced from the Excel log data spreadsheet in 'Log_in'
%   -> * it will also then be neccessary to manually assign the correct q_in
%      @ t_inj to Q_in(1,1) directly after the 'for' loop in section (4)

%% (4) Assign volumetric flowrates to all flowtest times
[r,c] = size(time);
[a,b] = size(T_in_hr);
Q_in = zeros(r,1);
count = 1;
for m = 1 : r
    if time(m,1) < T_in_hr(count+1,1)
        Q_in(m,1) = q_in(count,1);
    elseif time(m,1) == T_in_hr(count+1,1)
        Q_in(m,1) = q_in(count+1,1);
    elseif time(m,1) > T_in_hr(count+1,1) && count < a
        count = count + 1;
        Q_in(m,1) = q_in(count,1);
    elseif count >= a
        disp('count IN exceeds time steps')
        r = r + 1;
    end
end

% =>
     % Q_in(1,1) = 6.8000;     % see Sectiion (3.3) for explanation

% =>
     save('1_2_inflow', 'Q_in')

%% (5) Export data to Excel (UPDATE WORKSHEET NAME)
%      ! CHECK: that the correct volumetric flowrates are assigned to each experimental sampling time
       warning('off','MATLAB:xlswrite:AddSheet');
% =>
     xlswrite('LOG1.xlsx', time, 'CheckData1_2', 'A2');     % Flow test sample time (hrs since inj)     
     xlswrite('LOG1.xlsx', conc, 'CheckData1_2', 'B2');     % Uranine conc. (ppb) 
     xlswrite('LOG1.xlsx', Q_in, 'CheckData1_2', 'C2');     % Inlet volumetric flowrate corresponding to each flowtest sample time

     