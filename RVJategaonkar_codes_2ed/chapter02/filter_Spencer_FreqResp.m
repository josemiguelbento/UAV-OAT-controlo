% Program to compute magnitude responses of Spencer and other
% simple running average filters
%
% Chapter 2: Data Gathering 
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% published by AIAA, Reston, VA 20191, USA


% Define Frequency range
Omega = [0: 0.0005:3.5]; 

%----------------------------------------------------------------------
% 15-Point Spencer Filter, Eq. (2.13)
dCoeff(7) = -3.0;
dCoeff(6) = -6.0;
dCoeff(5) = -5.0;
dCoeff(4) =  3.0;
dCoeff(3) =  21.0;
dCoeff(2) =  46.0;
dCoeff(1) =  67.0;
dCoeff    =  dCoeff/320.0;
g0        =  74.0/320.0;
FR_mag_s15 = Comp_FreqResp_filter(7, g0, dCoeff, Omega); 

%----------------------------------------------------------------------
% 21-Point Spencer Filter, Eq. (2.14???)
dCoeff(10) = - 1.0;
dCoeff( 9) = - 3.0;
dCoeff( 8) = - 5.0;
dCoeff( 7) = - 5.0;
dCoeff( 6) = - 2.0;
dCoeff( 5) =   6.0;
dCoeff( 4) =  18.0;
dCoeff( 3) =  33.0;
dCoeff( 2) =  47.0;
dCoeff( 1) =  57.0;
dCoeff = dCoeff/350.0;
g0        =  60.0/350.0;
FR_mag_s21 = Comp_FreqResp_filter(10, g0, dCoeff, Omega); 

%----------------------------------------------------------------------
figure(1)
OmegaN = Omega/2/pi;
plot(OmegaN,FR_mag_s15, 'k', OmegaN, FR_mag_s21, 'k--', 'Linewidth', 2); 
     xlim ([0 0.5]), ylim ([-0.1 1.0]), grid
     xlabel('\omega/2\pi')
     legend('Spencer 15-point', 'Spencer 21-point')
     title ('Fig. 2.12: Magnitude responses of Spencer filters')

%----------------------------------------------------------------------
% A few other simple, running average filters

% 3 data points
dCoeff( 1) = 1/3.0;
g0         = 1/3.0;
FR_mag_N3 = Comp_FreqResp_filter(1, g0, dCoeff, Omega); 

% 5 data points
dCoeff( 2) = 1/5.0;
dCoeff( 1) = 1/5.0;
g0         = 1/5.0;
FR_mag_N5 = Comp_FreqResp_filter(2, g0, dCoeff, Omega); 

% 7 data points
dCoeff( 3) = 1/7.0;
dCoeff( 2) = 1/7.0;
dCoeff( 1) = 1/7.0;
g0         = 1/7.0;
FR_mag_N7 = Comp_FreqResp_filter(3, g0, dCoeff, Omega); 

% 9 data points
dCoeff( 4) = 1/9.0;
dCoeff( 3) = 1/9.0;
dCoeff( 2) = 1/9.0;
dCoeff( 1) = 1/9.0;
g0         = 1/9.0;
FR_mag_N9 = Comp_FreqResp_filter(4, g0, dCoeff, Omega); 


figure(2)
Omega=Omega/2/pi;
% plot(Omega,FR_mag_N3,'k'); grid
plot(Omega,FR_mag_N3,'k', Omega,FR_mag_N5,'b',...
     Omega,FR_mag_N7,'m', Omega,FR_mag_N9,'g', 'Linewidth', 2);
     xlim ([0 0.5]), ylim ([-0.4 1.0]), grid
     xlabel('\omega/2\pi')
     legend('3 data points', '5 data points', '7 data points', '9 data points')
     title ('Magnitude responses of simple running average filters')
          
%----------------------------------------------------------------------
