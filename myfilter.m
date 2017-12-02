function [F1] = myfilter(E1)
% Applies the Savitsky-Golay (SG) filter to smooth the extracted data
%  SG is a generalized, moving-average filter
%     It performs an unweighted, linear, least-squares fit using a polynomial (whose degree can be specified)
%        Higher degree polynomials capture the heights and widths of narrow peaks more accurately, but perform poorly when smoothing broad peaks
%  SG is often used for spectroscopic data 
%     It is effective at preserving higher moments, but less successful at rejecting noise

% Savitzky-Golay Filter:
%   yy = smooth(x, y, span, 'sgolay', degree)
%   **span must be odd (default 5)
%   **degree must be less than span (default 2)
%   x = E1(:,3) => time (hrs since injection)
%   y = E1(:,2) => [Uranine] (ppb)

SGfilt_d5 = smooth(E1(:,2), 1500, 'sgolay', 5);     % span = 1500; degree = 5
SGfilt_d5(SGfilt_d5 < 0) = 0;

F1(:,1) = E1(:,1);       % time (DateNum)     
F1(:,2) = SGfilt_d5;     % [Uranine] (ppb)                          
F1(:,3) = E1(:,3);       % time (hrs since inj)           