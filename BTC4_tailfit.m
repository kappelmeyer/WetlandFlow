%% Fit an exponential tail to tracer flowtest data and extrapolate to [Uranine = 0]
%  Determine the time designating the end of the flow test
clear
clc
% load C:/users/aylward/Desktop/MATLAB/Final/NSS/Hydraulics2/2_1_BTC_F1.mat     % 623 for port #, depth 1
load C:/users/aylward/Desktop/MATLAB/Final/NSS/Hydraulics2/2_2_BTC_F1.mat     % 624 for port #, depth 2
% load C:/users/aylward/Desktop/MATLAB/Final/NSS/Hydraulics2/2_3_BTC_F1.mat     % 625 for port #, depth 3 

% f = 623;
f = 624;
% f = 625;

F1 = eval(['F1_' num2str(f)]);
% F1(:,1) = DateNum
% F1(:,2) = [uranine]
% F1(:,3) = hrs since injection
X = F1(:,3);
Y = F1(:,2);

% Fit one-term exponential decay function to tail of RTD
% Locate section of RTD tail by visual inspection from ExtractPlot.fig
%%
% % Port 2_1
% t = X(x:end);
% C = Y(x:end);
% f = fit(t,C, 'exp1');
% disp('exp1 parameters')
% disp(f)
% 
% % c = a*exp(b*t)
% % => t = [ln(a) - ln(c)]/b
% % At what time will c = 0.0001
% % a = ;
% % b = ;
% t_end_hrs = (log(a) - log(0.0001))/abs(b);
% t_end_days = t_end_hrs/24;

%%
% % Port 2_2
t = X(68337:end);
C = Y(68337:end);
f = fit(t,C, 'exp1');
disp('exp1 parameters')
disp(f)

% c = a*exp(b*t)
% => t = [ln(a) - ln(c)]/b
% At what time will c = 0.0001
a = 122.7;
b = -0.02897;
t_end_hrs = (log(a) - log(0.0001))/abs(b);
t_end_days = t_end_hrs/24;

%%
% % Port 2_3
% t = X(66960:end);
% C = Y(66960:end);
% f = fit(t,C, 'exp1');
% disp('exp1 parameters')
% disp(f)
% 
% % c = a*exp(b*t)
% % => t = [ln(a) - ln(c)]/b
% % At what time will C = 0.0075
% a = 1.384;
% b = -0.009386;
% t_end_hrs = (log(a) - log(0.0075))/abs(b);
% t_end_days = t_end_hrs/24;

%%
figure(41)
plot(f,t,C); hold on
xlabel('Time since injection (hrs)')
ylabel(' [Uranine] (ppb)')
title('Exponential Decay of RTD tail (one-term)')
hold off

points = round(t_end_hrs - t(end,1));
% save('2_1_BTCpoints', 'points') 
save('2_2_BTCpoints', 'points') 
% save('2_3_BTCpoints', 'points') 
