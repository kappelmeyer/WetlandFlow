% Append flowtest data at hourly intervals
clear
clc
load C:/users/aylward/Desktop/MATLAB/Final/Hydraulics2/2_2_BTC_F1.mat       
load C:/users/aylward/Desktop/MATLAB/Final/Hydraulics2/2_2_BTCpoints.mat    % variable name: 'points'
                                                                            % additional time steps for RTD tail
                                                                            % calculated from exponential function in BTCtailfit.m
% Flowtest data start = datenum([2016 05 02 16 52 00]);
% Flowtest data end = datenum([2016 05 11 07 41 10]);
% Flowtest end (theoretical) = 563,4335 hours = 23,4764 days = 23 days 11 hours 26 minutes
%                            = datenum([2016 05 26 04 18 00])

f = 624; 
F1 = eval(['F1_' num2str(f)]);
% F1 (P1_624) is a 74402 x 3 matrix
% F1(:,1) = DateNum
% F1(:,2) = [uranine]
% F1(:,3) = hrs since injection

[x,y] = size(F1);
a = x + points;
% A1(:,1) = DateNum
% A1(:,2) = conc.
% A1(:,3) = hrs after injection
A1 = zeros(a,2);
for n = 1:x;
    A1(n,1) = F1(n,1);            
    A1(n,2) = F1(n,2);  
    A1(n,3) = F1(n,3);
end
for m = x+1 : a;
    A1(m,1) = A1(m-1,1) + 1;
    A1(m,2) = 122.7*exp(-0.02897*A1(m,1));
    A1(m,3) = A1(m-1,3) + 1;
end

save('2_2_BTC_A1', 'A1')

figure(1)
plot(A1(:,1), A1(:,2)); hold on
title('RTD with exponential tail');
xlabel('Time since injection (hrs)');
ylabel('[Uranine] (ppb)')
savefig('2_2_RTDtailfit.fig')
