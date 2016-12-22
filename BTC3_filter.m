%% Applies the Savitsky-Golay filter to smooth the extracted data from BTCextract_2016
%  Abbreviated SG
%  Often used for spectroscopic data - effective at preserving higher moments but less successful at rejecting noise
%  A generalized moving avergae filter
%  Performs an unweighted linear least-squares fit using a polynomial (whose degree can be specified)
%  Higher degree polynomials will capture the heights and widths of narrow peaks more accurately, but perform poorly when smoothing broad peaks

%  Original script by by Lara Aylward, Helmholtz-UFZ. 
close all
clear all

%% (1) **** UPDATE FILE **** 
% load C:/users/aylward/Desktop/MATLAB/Final/NSS/Hydraulics2/2_1_BTC_P1.mat     % 623 for port #, depth 1
% load C:/users/aylward/Desktop/MATLAB/Final/NSS/Hydraulics2/2_2_BTC_P1.mat     % 624 for port #, depth 2
load C:/users/aylward/Desktop/MATLAB/Final/NSS/Hydraulics2/2_3_BTC_P1.mat     % 625 for port #, depth 3

%% (2) Define number of fluorometer
% f = 623;
% f = 624; 
f = 625; 

%% (3) Define data to be filtered
P1 = eval(['P1_' num2str(f)]); 

%% (4) Savitzky-Golay Filter
%      yy = smooth(x, y, span, 'sgolay', degree)
%      **span must be odd (default 5)
%      **degree must be less than span (default 2)
%      x = P1(:,3) => time (hrs since injection)
%      y = P1(:,2) => extracted conc. (ppb)

SGfilt_d5 = smooth(P1(:,2), 1500, 'sgolay', 5);               % span = 1500; degree = 5

figure(31)
plot(P1(:,3), P1(:,2), 'g.'); hold on
plot(P1(:,3), SGfilt_d5, 'm-', 'LineWidth', 1.25); hold off
xlabel('Time since injection (hr)');
ylabel('[Uranine] (ppb)')
xlim([0 220]);
ylim([0 55]);

% title('BTC (SG deg5) for Port 2 (12cm below gravel surface)');
% title('BTC (SG deg5) for Port 2 (24cm below gravel surface)');
title('BTC (SG deg5) for Port 2 (36cm below gravel surface)');

% savefig('2_1_FilterPlot.fig');
% savefig('2_2_FilterPlot.fig');
savefig('2_3_FilterPlot.fig');

%% (5) Save filtered data in format suitable to be imported into BTCcals_2016 
%      (See BTCextract_lara_2016 for format) 
Filter(:,1) = P1(:,1);           
Filter(:,2) = SGfilt_d5;                          
Filter(:,3) = P1(:,3);           
assignin('base', ['F1_' num2str(f)], Filter);     % Renames filtered matrix as F1_6##

% save('2_1_BTC_F1', 'F1_623');     
% save('2_2_BTC_F1', 'F1_624');   
save('2_3_BTC_F1', 'F1_625'); 
