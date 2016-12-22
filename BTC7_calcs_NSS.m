% BTC_calcs_NSS.m for port 2, depth 2 (f = 624)
close all
clear all

%% (1) Input variables
%      ALL UNITS SHOULD BE IN sec, L, ppb or ug/L
%      **** UPDATE FILES ****  

% Sampling time with corresponding conc., inlet & outlet flowrate
load C:/users/Lara/Desktop/Hydraulics2/2_2_BTC_A1.mat 
% A1(:,1) = hrs since injection
% A1(:,2) = conc.

% Time variant inlet volumetric flowrate, Qi (L/h):
load C:/users/Lara/Desktop/Hydraulics2/inflow.mat
% Time variant outlet volumetric flowrate, Qo (L/h):
load C:/users/Lara/Desktop/Hydraulics2/outflow.mat 

Data(:,1) = A1(:,1);
Data(:,2) = Q_in;
Data(:,3) = Q_out;
Data(:,4) = A1(:,2);

% INPUT: Mass of Uranine injected     
M = 0.015*1000000;                    % (ug). g converted to ug using 1,000,000 ug/g 

% Define flow variables
time = A1(:,1);
Qi = Q_in;
Qo = Q_out;
conc = A1(:,2);

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
V_bed_L = V_bed_m3 * 1000     % (L). convert m3 to L using 1000 L/m3.

%% (3) Uranine Calculations

% (3.1) Calculate Flow Weighted Time, phi
%       phi = V_out / V_system for each time point

[a,b] = size(time);
V_out = zeros(a,1);
V_out(1,1) = 0;         % volume of water that has exited between t_inj and time (L)
for n = 2 : a
    V_out(n,1) = Qo(n-1,1)*(time(n,1) - time(n-1,1)) + V_out(n-1,1);
end
Data(:,5) = V_out;

phi = V_out ./ V_bed_L;
Data(:,6) = phi;

% (3.2) Calculate Normalized Conc., c_phi
c_phi = conc*(V_bed_L/M);
c_phi(c_phi < 0) = 0;                   % Set negative concentrations to zero
Data(:,7) = c_phi;

% Normalized BTC
figure(1)
plot(phi, c_phi); hold on
title('Normalized BTC Port 2 (24cm below gravel surface) - non-steady flow')
xlabel('Flow Weighted Time')
ylabel('Normalized [Uranine]')
savefig('BTC_norm_NSS')

% % (3.3) Normalized peak concentration 
c_peak_norm = max(c_phi);       % Normalized peak conc.

% (3.4) Normalized peak time (mode)
[~,max_ind] = max(c_phi);  
t_peak_norm = phi(max_ind);     % Normalized peak time

%% (4) Moment Analysis

% Normalized 0th Moment - fractional tracer recovery
[r,c] = size(c_phi);
d_phi = zeros(r,1);
d_phi(1,1) = 0.00056;
for m = 2 : r
    d_phi(m,1) = (V_out(m,1) - V_out(m-1,1)) ./ V_bed_L;
end

M0_norm = sum(c_phi .* d_phi)

% Normalized 1st Moment - mean residence time
M1_norm = sum(phi .* c_phi .* d_phi)

% Normalized 2nd Moment - variance
M2_norm = sum((phi - M1_norm).^2 .* c_phi .* d_phi)


