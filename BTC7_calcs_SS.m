%% BTC Calculations 2 (calculations not performed using t99)
%  Calculates various hydraulic parameters (based on packed bed reactor model)
%  Script by Lara Aylward, Helmholtz-UFZ. 
close all
clear all

%% (1) Input variables
%      ALL UNITS SHOULD BE IN sec, L, ppb or ug/L

% **** UPDATE FILE ****  
% Input = calibrated & cropped data in p#_d#_BTC_P1.mat format (saved from BTCfilter script)
load 'C:/users/Lara/Desktop/Hydraulics2/2_2_BTC_A1';     % LINE 92 must agree with 'P' or 'F' or 'A' 
% A1(:,1) = hrs after injection
% A1(:,2) = conc.

% INPUT: Number of fluorometer
Fluoro = 624; 

% INPUT: Avergae inflow rate
q = 8.1529*(1/3600);                  % (L/s). L/hr converted to L/s using (1/3600) hr/s 
Q = q*3600*24;                        % (L/d)  
 
% INPUT: Mass of Uranine injected     
M = 0.015*1000000;                    % (ug). g converted to ug using 1,000,000 ug/g 

%% (2) System Physical Parameters
% INPUT:
h_H2O = 0.44;            % water level/height (m
L = 2.255;               % length of bed to sample port (m)
voidage = 0.3597;        % factional voidage of gravel

h = 0.70;                % height of steel container (m)
h_gravel = 0.50;         % gravel/bed height (m)    
B_top = 1.20;            % breadth of steel container (surface) (m)
B_base = 1.0;            % breadth of steel container (base) (m)
B_bed_base = B_base;     % breadth of gravel/bed (base of wetland) (m)
L_bed = L;               

% (2.1) System fluid volume (up to the point of sample removal)
%       Volume = volume of rectangular section + volume of triangular section

% Volume of rectangular section
V_rect = L_bed * B_bed_base * h_H2O * voidage;     % (m3)

% Volume of triangular section (see diagram in lab book for varibale definitions)
ao = 0.2;                                          % (m)
bo = h;                                            % (m)
ho = sqrt((ao*ao) + (bo*bo));                      % (m) - Pythagoras' theorem
bi = h_H2O;                                        % (m)
hi = (bi/bo) * ho;                                 % (m) - Ratio of sides of right angled triangle
ai = sqrt((hi*hi) - (bi*bi));                      % (m) - Pythagoras' theorem 
base = ai;                                         % (m)
h_perp = bi;                                       % (m)
V_tri = L_bed * 0.5*base * h_perp * voidage;       % (m3)  

% Volume of bed
V_bed_m3 = V_rect + V_tri;     % (m3)
V_bed_L = V_bed_m3 * 1000;     % (L). convert m3 to L using 1000 L/m3.

% (2.2) Reynold's Number (Re < 10 for laminar flow)
Dp = 0.006;                                                    % Equivalent spherical diameter (m) (assumed to be average particle size for particles 4mm - 8mm) 
density_H2O = 998.2;                                           % (kg/m3) - Engineering Toolbox
viscosity_H2O = 1.002e-3;                                      % (Ns/m2) - Engineering Toolbox
Us = (q*0.001)/((B_bed_base*h_H2O) + (0.5*base * h_perp));     % superficial velocity (m/s) = volumetric flowrate / cross sectional area
Re = (Dp*Us*density_H2O) / ((1-voidage)*viscosity_H2O);        % Reynolds number for packed bed
disp('Re =')
disp(Re)

% (2.3) Calculate nominal residence time (space time or avg residence time)
tau_sec = V_bed_L / q;          % (s)
tau_hr = tau_sec*(1/3600);      % (hr). s converted to hr using (1/3600) hr/sec. 
tau_d = tau_hr*(1/24);          % (d). hr converted to d using (1/24) d/hr.

%% (3) Uranine Calculations     
t_sec = A1(:,1).*3600;          % time since inj (sec). hr converted to sec using 60 min/hr * 60 sec/min
t_hr = A1(:,1);                 % time since inj (hr).
dt = 10;                        % time interval for flowtest data (sec)
DT = 1*3600;                    % time interval for fitted tail section (sec)                        
C = A1(:,2);                    % Uranine concentration (ppb = ug/L) 
C(C < 0) = 0;                   % Set negative concentrations to zero

% Dimensional conc. BTC
figure(1)
plot(t_hr,C); hold on
title('BTC for Port 2 (24cm below gravel surface)')
xlabel('Time since injection (hr)')
ylabel('[Uranine] (ppb)')

% (3.1) Normalized (dimensionless) time.
%       theta = t/tau
theta = t_sec./tau_sec;     

% (3.2) Normalized (dimensionless) conc. 
%       C_theta = C*V/M
C_theta = C.*(V_bed_L/M);

% Normalized BTC
figure(2)
plot(theta, C_theta); hold on
title('Normalized BTC Port 2 (24cm below gravel surface) - steady flow')
xlabel('Normalized exit age')
ylabel('Normalized [Uranine]')
savefig('BTC_norm_SS')

% (3.3) Peak concentration 
Cpeak = max(C);                             % Peak conc. (ppb)
Cpeak_norm = Cpeak*(V_bed_L/M)              % Normalized peak conc.  

% (3.4) Peak time (mode)
[~,max_ind] = max(C);  
tpeak_hr = t_hr(max_ind); 	                % Peak time (hr)
tpeak_norm = tpeak_hr/tau_hr                % Normalized peak time

% (3.5) Area under curve and percentage recovery
m0_all = sum(C(1:74402)).*dt + sum(C(74403:74759)).*DT;     % Area under C(t) curve (ug*s/L)
Recovery = ((m0_all*q)/M)*100;                              % Percentage recovery

% (3.6) t99
% Fluoro data terminates at: 206.8914 hrs after injection 
% Calculated end time: 563.4335 hrs after injection
% => based on exponentially fitted tail function 

[r,c] = size(C);
m0_inc = zeros(r,1);
for n = 1 : r
    if n <= 74402
        m0_inc(n,1) = sum(C(1:n)).*dt;
    else
        m0_inc(n,1) = sum(C(1:74402)).*dt + sum(C(74402:n)).*DT;
    end
end
t99_ind = find(m0_inc > (m0_all*0.99),1);
t99_hr = t_hr(t99_ind)
t99_d = t99_hr/24;
t99_norm = t99_hr/tau_hr

%% (4) Moment Analysis

% Normalized 0th Moment - fractional tracer recovery
% 1 - flowtest data with timestep = 10s (index 1:74402)
% 2 - tail section with timestep = 1hr  (index 74403:74759)
d_theta = dt/tau_sec;
D_theta = DT/tau_sec;
M0_norm = sum(C_theta(1:74402)).*d_theta + sum(C_theta(74403:74759)).*D_theta

% Normalized 1st Moment - mean residence time
M1_norm = sum(theta(1:74402).*C_theta(1:74402)).*d_theta + sum(theta(74403:74759).*C_theta(74403:74759)).*D_theta

% Normalized 2nd Moment - variance
M2_norm = sum((theta(1:74402)-M1_norm).^2.*C_theta(1:74402)).*d_theta + sum((theta(74403:74759)-M1_norm).^2.*C_theta(74403:74759)).*D_theta

%% (5) Hydraulic Indexes
