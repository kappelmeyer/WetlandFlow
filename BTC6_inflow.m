%% BTC6_inflow.m
%  To create a vector of inlet volumetric flowrates for every flowtest sampling time
%  (i.e. 10s intervals from time of injection to time of termination)
%  Requires: 
%           1. full flowtest sampling time vector - hrs since injection format (time)
%              => already calibrated and extracted
%           2. inflow cycle DateTime [ t_in ] and corresponding volumetric flowrate [ q_in ]

%  Creates a zero matrix of size(time) to represent Q_in
%  Compares every time to t_in
%  Then assigns a volumetric flowrate to replace each zero for every sample time
%  **** time and Q_in must have the same dimensions ****
close all
clear all

% 624 for port 2, depth 2
load C:/users/aylward/Desktop/MATLAB/Final/Hydraulics2/2_2_BTC_A1.mat 
% A1(:,1) = hrs since injection
% A1(:,2) = conc.

% Time: time of injection to end of flowtest
% **** Injection time = 02 May 2016, 16:52:00 ****
% **** End of Flowtest = 26 May 2016, 04:45:29 **** 
% Conc: for each time (from injectin to termination)

% Fluoro flowtest data
time = A1(:,1);
time_end = A1(end,1);
conc = A1(:,2);
conc(conc < 0) = 0;

% Inflow LOG data
% Start & end time of LOG_in data must = start & end time of flowtest
Log_in = xlsread('LOG2.xlsx', 'Tabelle1', 'A2:A2604');       % Inflow cycle start DateTime (Excel numeric format)
t_in = datetime(Log_in,'ConvertFrom','excel');
T_in = datenum(t_in);
T_in_hr = (T_in - datenum([2016 05 02 16 52 00])).*24;       % time since injection (hrs)
q_in = xlsread('LOG2.xlsx', 'Tabelle1', 'C2:C2604');         % Inlet volumetric flowrate (L/h)

% Check agreement between 'in' start & end times
start_in = T_in_hr(1,1);
stop_in = T_in_hr(end,1);
check_start_in = abs(time(1,1) - start_in);     % should be zero if both entries represent the same DateTime
check_stop_in = abs(time(end,1) - stop_in);     % should be zero if both entries represent the same DateTime

% Assign volumetric flowrates to all flowtest times
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

V1(:,1) = time;      % hrs since injection
V1(:,2) = conc;      % [uranine] (ppb)
V1(:,3) = Q_in;      % inlet volumetric flowrate (L/hr)

save('2_2_inflow', 'Q_in')

%% Cut from script above
% f = 624; 
% FluoroDat = eval(['P1_' num2str(f)]);
% FluoroDat (P1_624) is a 74402 x 3 matrix
% FluoroDat(:,1) = DateNum
% FluoroDat(:,2) = [uranine]
% FluoroDat(:,3) = hrs since injection

% % This section is only for Test.m
% % Selects a small subset of the full sampling time vector
% % corresponding to the time window of the inflow LOG data
% start_in = T_in(1,1);
% stop_in = T_in(60,1);
% T = FluoroDat(:,1);
% T_sub = T(6117:10538);                         % Located on ExtractPlot.fig
% check_start_in = abs(T_sub(1) - start_in);     % should be zero if both entries represent the same DateTime
% check_stop_in = abs(T_sub(end) - stop_in);     % should be zero if both entries represent the same DateTime

% % Export data to Excel
% warning('off','MATLAB:xlswrite:AddSheet');
% xlswrite('LOG.xlsx', T_sub, 'CodeCheck', 'A2');     % Flowtest sample time     
% xlswrite('LOG.xlsx', T_in, 'CodeCheck', 'B2');      % Data LOG cycle time
% xlswrite('LOG.xlsx', q_in, 'CodeCheck', 'C2');      % Volumetric flowrate corresponding to each cycle time
% xlswrite('LOG.xlsx', Q_in, 'CodeCheck', 'D2');      % Volumetric flowrate corresponding to each flowtest sample time

