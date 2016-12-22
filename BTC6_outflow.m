%% BTC6_outflow.m
%  To create a vector of outlet volumetric flowrates for every flowtest sampling time
%  (i.e. 10s intervals from time of injection to time of termination)
%  Requires: 
%           1. full flowtest sampling time vector - hrs since injection format (time)
%              => already calibrated and extracted
%           2. outflow cycle DateTime [ t_out ] and corresponding volumetric flowrate [ q_out ]

%  Creates a zero matrix of size(time) to represent Q_out
%  Compares every time to t_out
%  Then assigns a volumetric flowrate to replace each zero for every sample time
%  **** time and Q_out must have the same dimensions ****
close all
clear all

% 624 for port 2, depth 2
load C:/users/Lara/Desktop/Hydraulics2/2_2_BTC_A1.mat 
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

% Outflow LOG data
Log_out = xlsread('LOG2.xlsx', 'Tabelle1', 'E2:E5082');      % Outflow Cycle Time - Excel numeric format
t_out = datetime(Log_out,'ConvertFrom','excel');
T_out = datenum(t_out);
T_out_hr = (T_out - datenum([2016 05 02 16 52 00])).*24;     % time since injection (hrs)
q_out = xlsread('LOG2.xlsx', 'Tabelle1', 'G2:G5082');        % Outlet volumetric flowrate (L/h) 

% Check agreement between 'out' start & end times
start_out = T_out_hr(1,1);
stop_out = T_out_hr(end,1);
check_start_out = abs(time(1,1) - start_out);     % should be zero if both entries represent the same DateTime
check_stop_out = abs(time(end,1) - stop_out);     % should be zero if both entries represent the same DateTime

% Assign volumetric flowrates to all flowtest times
[r,c] = size(time);
[a,b] = size(T_out_hr);
Q_out = zeros(r,1);
count = 1;
for m = 1 : r
    if time(m,1) < T_out_hr(count+1,1)
        Q_out(m,1) = q_out(count,1);
    elseif time(m,1) == T_out_hr(count+1,1)
        Q_out(m,1) = q_out(count+1,1);
    elseif time(m,1) > T_out_hr(count+1,1) && count < a
        count = count + 1;
        Q_out(m,1) = q_out(count,1);
    elseif count >= a
        disp('count IN exceeds time steps')
        r = r + 1;
    end
end

v1(:,1) = time;      % hrs since injection
v1(:,2) = conc;      % [uranine] (ppb)
v1(:,3) = Q_out;     % outlet volumetric flowrate (L/hr)

save('2_2_outflow', 'Q_out') 
