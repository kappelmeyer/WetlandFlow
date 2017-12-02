function [E1] = extract(DateNum, C1, P1I, P1S_ind, P1F)  
% Extracts BTC from full time series (starting @ time of injection)

C1(C1 < 0) = 0;                          % Sets -ve conc. to zero

for n = 1:P1S_ind
    C1(n,1) = 0;
end

[~,P1I_ind] = min(abs(DateNum-P1I));         
[~,P1F_ind] = min(abs(DateNum-P1F));          

E1(:,1) = DateNum(P1I_ind:P1F_ind);      % time (DateNum)
E1(:,2) = C1(P1I_ind:P1F_ind,:);         % [Uranine] (ppb)
E1(:,3) = (E1(:,1) - P1I).*24;           % time (hrs since inj)
end
