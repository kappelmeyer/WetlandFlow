function [C1] = cal(Uranine_mv, Temperature, c_cal_Uranine, ind_ura, ind_blank)
% Calibrates experimental data (Uranine mV signals)
% Converts Uranine mV signal to corresponding Uranine conc. (ppb)  
% Plots calibrated conc.
calib_conc = c_cal_Uranine; 
blank = mean(Uranine_mv(ind_blank));
L1_ura = mean(Uranine_mv(ind_ura));   
 
C1 = zeros(length(Temperature),1);                         
    for i = 1:length(Temperature)
        Raw_signals_minusblank = (Uranine_mv - blank)';     
        coeff1 = (L1_ura-blank(1))/calib_conc;
        C1(i,:) = (coeff1\Raw_signals_minusblank(:,i))';     
    end
C1(C1 < 0) = 0;                          % Sets -ve conc. to zero