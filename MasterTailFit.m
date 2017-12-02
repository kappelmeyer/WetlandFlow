%% MasterTailFit.m
% Fits an exponential tail to the experimental data
%    Run this script if flow test was terminated too early or if tail was completed manually
%    Determines 'theoretical' end of flow test
 
% Fits an exponential tail (one-term exponential decay function) to flowtest data
%    y = a.e^(-b.x)
%    Then extrapolates to [Uranine] = 0ppb to determine t_end
       
% User instructions for this section:
% 1. Load correct data file
% 2. Section (1.1): Enter % of tail data points to be used for the tail fit
%                   into 'inf_find' OR determine by visual inspection from
%                   figure (3) in MasterDataProc.m
% 3. Section (1.2): Enter x co-ordinate (INDEX) of 'inf_find' into 'ind' 
% 4. Run script until _____Break 1______
% 5. Enter the values of the fit parameters 'a' and 'b' in section (1.3) 
%    (they will be displayed to the Workspace)
% 6. Repeat run until section (1) until satisfied with tail fit
% 7. Run section (2) to check plot of tail fit
% 8. Run section (3) to save F1 matrix

%% (1) Exponential Tail Fit
close all
clear all
% => 
load C:/users/aylward/Desktop/MATLAB/Final2017/7iii_BTC_E1
            
% (1.1) Exponential Curve Fit
   E1(1,3) = 0;
   X = E1(:,3);     % time (hrs since inj)
   Y = E1(:,2);     % [Uranine] (ppb)

% => Determine from figure (3) in MasterDataProc.m (use +/- the final 50% of
%       data points after the peak)
%    Position = (270.3; 6.0541)
%    DataIndex = 97217
               
% =>   Enter x co-ordinate (INDEX) of ind_find:
       ind = 97217;
       t = X(ind:end);
       C = Y(ind:end);
       params = fit(t,C, 'exp1');
       disp('exp1 parameters')
       disp(params)
               
% (1.2) Plot tail data with exponential curve 
        figure(12)
        plot(params,t,C);
        xlabel('Time since injection (hrs)')
        ylabel('[Uranine] (ppb)')
        title('Exponential Decay of RTD tail (one-term)')
               
%______________________________________BREAK 1__________________________________________________
              
% (1.3) Determine flowtest end time
%        C = a*exp(b*t)
%        -> t = [ln(a) - ln(c)]/b
%        At what time will C = 0.01?
% =>
               a = 195.1;
% =>
               b = -0.01276;
               
               t_end_hrs = (log(a) - log(0.01))/abs(b);
               t_term = X(end,1);
               [x,y] = size(E1);
               t_term_ind = x;
               total_points = round(t_end_hrs)*360;         % no. of 10s intervals        
               points = total_points - x;            

%% (2) Append experimental flow test data at 10s intervals
%      Add data points for RTD tail using exponential function determined in section (1)
       [A1] = append(E1, points, a, b);
% =>
        save('7iii_BTC_A1', 'A1')
%       A1(:,1) = time (hrs since injection)
%       A1(:,2) = [Uranine] (ppb)
       
% (2.1) Plot RTD with extended tail
        figure(21)
        plot(A1(:,1), A1(:,2), 'm-'); hold on
        xlabel('Time since injection (hrs)');
        ylabel('[Uranine] (ppb)')
% =>    Specify domain and range:
        xlim([0 800])
        ylim([0 14])
% => 
        title('BTC with exponential tail - Port 7iii');
% => 
        savefig('7iii_TailFitPlot.fig')   

%% (3)  Applies the Savitsky-Golay (SG) filter to smooth the extracted data
%       Applies the Savitsky-Golay (SG) filter to smooth the extracted data
%       SG is a generalized, moving-average filter
%          It performs an unweighted, linear, least-squares fit using a polynomial (whose degree can be specified)
%          Higher degree polynomials capture the heights and widths of narrow peaks more accurately, 
%          but perform poorly when smoothing broad peaks
%       SG is often used for spectroscopic data 
%          It is effective at preserving higher moments, but less successful at rejecting noise

% (3.1) Apply Savitzky-Golay Filter:
%       yy = smooth(x, y, span, 'sgolay', degree)
%       ** span must be odd (default 5)
%       ** degree must be less than span (default 2)
%       x = A1(:,1) => time (hrs since injection)
%       y = A1(:,2) => [Uranine] (ppb)

        SGfilt_d5 = smooth(A1(:,2), 1500, 'sgolay', 5);     % span = 1500; degree = 5
        SGfilt_d5(SGfilt_d5 < 0) = 0;
        F1(:,1) = A1(:,1);                                  % time (hrs since inj)         
        F1(:,2) = SGfilt_d5;                                % [Uranine] (ppb)
% =>
        save('7iii_BTC_F1', 'F1')

% (3.2) Plot Filtered Data
        figure(3)
        plot(A1(:,1), A1(:,2), 'g.'); hold on
        plot(F1(:,1), F1(:,2), 'm-', 'LineWidth', 1.25); hold off
        legend('Raw data', 'Filtered data (SG deg5)', 'Location', 'northeast');
        xlabel('Time since injection (hr)');
        ylabel('[Uranine] (ppb)')
% =>    Specify domain and range:
%       xlim([0 220])
%       ylim([0 30])
% =>
        title('BTC for Port 7iii');
% =>
        savefig('7iii_FilterPlot.fig');
