% Program to compute magnitude responses of various differentiator filters
%
% Chapter 2: Data Gathering 
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% published by AIAA, Reston, VA 20191, USA


% Define Frequency range
Omega = [0: 0.0005:3.5];       

% Define coefficients and compute frquency response

%----------------------------------------------------------------------
% Ideal differentiator
F_Ideal = Omega;

%----------------------------------------------------------------------
% standard Central difference formula
nOrder = 1;
dCoeff(1) = 0.5;
Fndiff_CD = Comp_FreqResp_diff(nOrder, dCoeff, Omega);                      

%----------------------------------------------------------------------
% ndiff_Filter02: 2nd order (Five data points central difference, eqs. 2.17-2.19)
nOrder = 2;
dCoeff(1) =  0.666666667;
dCoeff(2) = -0.083333333;
Fndiff_Filter02 = Comp_FreqResp_diff(nOrder, dCoeff, Omega);                      

%----------------------------------------------------------------------
% ndiff_Filter04:  4th order (Nine data points central difference, eqs. 2.17-2.19)
nOrder = 4;
dCoeff(1) =  0.800000000;
dCoeff(2) = -0.200000000;
dCoeff(3) =  0.038095238;
dCoeff(4) = -0.003571428;
Fndiff_Filter04 = Comp_FreqResp_diff(nOrder, dCoeff, Omega);     

%----------------------------------------------------------------------
% ndiff_Filter08:  8th order (Seventeen data points central difference, eqs. 2.17-2.19)
dCoeff(8) = - 0.00000971250971;
dCoeff(7) =   0.00017760017759;
dCoeff(6) = - 0.00155400155390;
dCoeff(5) =   0.00870240870185;
dCoeff(4) = - 0.03535353535135;
dCoeff(3) =   0.11313131312500;
dCoeff(2) = - 0.31111111109862;
dCoeff(1) =   0.88888888887637;
Fndiff_Filter08 = Comp_FreqResp_diff(nOrder, dCoeff, Omega);     

%----------------------------------------------------------------------
% ndiff_Lanczos_p2n5:  Lanczos, low-noise Lanczos differentiator, 2nd order
% polynomial, 5 data points (eq. 2.21)
nOrder = 2;
dCoeff(1) =  0.1;
dCoeff(2) =  0.2;
FLanczos_p2n5 = Comp_FreqResp_diff(nOrder, dCoeff, Omega);                      

%----------------------------------------------------------------------
% ndiff_Lanczos_p2n9:  Lanczos, low-noise Lanczos differentiator, 2nd order
% polynomial, 9 data points (eq. 2.22)
nOrder = 4;
dCoeff(1) =  0.01666666666667;
dCoeff(2) =  0.03333333333333;
dCoeff(3) =  0.05000000000000;
dCoeff(4) =  0.06666666666667;
FLanczos_p2n9 = Comp_FreqResp_diff(nOrder, dCoeff, Omega);                      

%----------------------------------------------------------------------
% ndiff_PavelH_p2n5:  Holoborodko smooth noise-robust differentiator, 
% 5 data points (eq. 2.23)
nOrder = 2;
dCoeff(1) =  0.250;
dCoeff(2) =  0.125;
FPavelH_p2n5 = Comp_FreqResp_diff(nOrder, dCoeff, Omega); 

%----------------------------------------------------------------------
% ndiff_PavelH_p2n9:  Holoborodko smooth noise-robust differentiator, 
% 9 data points (eq. 2.23)
nOrder = 4;
dCoeff(1) =  0.109375;
dCoeff(2) =  0.109375;
dCoeff(3) =  0.046875;
dCoeff(4) =  0.0078125;
FPavelH_p2n9 = Comp_FreqResp_diff(nOrder, dCoeff, Omega);                      

%----------------------------------------------------------------------
% 15-point Spencer filter followed by differentiator ndiff_Filter08
dCoeff(7) = - 3.0;
dCoeff(6) = - 6.0;
dCoeff(5) = - 5.0;
dCoeff(4) =   3.0;
dCoeff(3) =  21.0;
dCoeff(2) =  46.0;
dCoeff(1) =  67.0;
dCoeff    = dCoeff/320.0;
g0        =  74.0/320.0;
FR_mag_s15 = Comp_FreqResp_filter(7, g0, dCoeff, Omega);
FR_mag_s15 = abs(FR_mag_s15);

% Smooth + ndiff_Filter08
FR_smSp15_diff08 = FR_mag_s15.*Fndiff_Filter08;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Henderson filter (filter length 9 terms)
dCoeff( 4) = -0.04072398190045;
dCoeff( 3) = -0.00987248046072;
dCoeff( 2) =  0.11846976552859;
dCoeff( 1) =  0.26655697243933;
g0         =  0.33113944878651;
FR_mag_h09 = Comp_FreqResp_filter(4, g0, dCoeff, Omega); 
FR_mag_h09 = abs(FR_mag_h09);
% Smooth_Henderson09 + ndiff_Filter08
FR_smh09_diff08 = FR_mag_h09.*Fndiff_Filter08;

% Henderson filter (filter length 13 terms)
dCoeff( 6) = -0.01934984520124;
dCoeff( 5) = -0.02786377708978;
dCoeff( 4) =  0.0;
dCoeff( 3) =  0.06549178375804;
dCoeff( 2) =  0.14735651345558;
dCoeff( 1) =  0.21433674684449;
g0         =  0.24005715646583;
FR_mag_h13 = Comp_FreqResp_filter(6, g0, dCoeff, Omega); 
FR_mag_h13 = abs(FR_mag_h13);
% Smooth_Henderson13 + ndiff_Filter08
FR_smh13_diff08 = FR_mag_h13.*Fndiff_Filter08;

%----------------------------------------------------------------------
% Plot magnitude response
OmegaN = Omega/2/pi;                 % Normalized frequency

figure(1)
plot(OmegaN, F_Ideal,         'k', ...
     OmegaN, Fndiff_Filter08, 'b--', ...
     OmegaN, FPavelH_p2n5,    'y',   OmegaN, FPavelH_p2n9, 'm', ...
     OmegaN, FR_smSp15_diff08,'r',   OmegaN, FR_smh13_diff08, 'k--', ...
     OmegaN, FR_smh09_diff08, 'b--', 'Linewidth',1.5), ...
      xlim ([0 0.5]), ylim ([0 0.8]), grid,
      xlabel('{\omega /2\pi}')
      ylabel('\midH(\omega)\mid')
h = legend('Ideal', 'ndiff_Filter08', ...
                    'ndiff_PavelH_p2n5', 'ndiff_PavelH_p2n9',...
                    'SmSp15+ndiff08', 'SmHe13+ndiff08', 'SmHe09+ndiff08', 2);
set(h,'Interpreter','none');  
title('Fig. 2.14 Magnitude responses of various smooth noise-robust differentiators')

figure(2)
plot(OmegaN, F_Ideal,         'k', ...
     OmegaN, Fndiff_Filter08, 'k--', ...
     OmegaN, FPavelH_p2n5,    'k-.',     OmegaN, FPavelH_p2n9, 'k--', ...
     OmegaN, FR_smSp15_diff08,'k--', OmegaN, FR_smh13_diff08, 'k-.', ...
     OmegaN, FR_smh09_diff08, 'k--', 'Linewidth',1.5), ...
      xlim ([0 0.5]), ylim ([0 0.8]), grid,
      xlabel('{\omega /2\pi}')
      ylabel('\midH(\omega)\mid')
h = legend('Ideal', 'ndiff_Filter08', ...
                    'ndiff_PavelH_p2n5', 'ndiff_PavelH_p2n9',...
                    'SmSp15+ndiff08', 'SmHe13+ndiff08', 'SmHe09+ndiff08', 2);
set(h,'Interpreter','none');  
title('Fig. 2.14 Magnitude responses of various smooth noise-robust differentiators')
