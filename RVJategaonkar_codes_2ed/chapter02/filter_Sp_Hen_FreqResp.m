% Program to compute magnitude responses of Spencer, Henderson and 
% other simple running average filters
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
c0        =  74.0/320.0;
FR_mag_s15 = Comp_FreqResp_filter(7, c0, dCoeff, Omega); 
FR_mag_s15 = abs(FR_mag_s15);

%----------------------------------------------------------------------
% 21-Point Spencer Filter, Eq. (2.15)
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
c0        =  60.0/350.0;
FR_mag_s21 = Comp_FreqResp_filter(10, c0, dCoeff, Omega); 
FR_mag_s21 = abs(FR_mag_s21);

%----------------------------------------------------------------------
% % Henderson filter (filter length 7 terms)
% dCoeff( 3) = -0.05874125874126;
% dCoeff( 2) =  0.05874125874126;
% dCoeff( 1) =  0.29370629370629;
% c0         =  0.41258741258741;
% FR_mag_h07 = Comp_FreqResp_filter(3, c0, dCoeff, Omega); 
% FR_mag_h07 = abs(FR_mag_h07);

%----------------------------------------------------------------------
% Henderson filter (filter length 9 terms)
dCoeff( 4) = -0.04072398190045;
dCoeff( 3) = -0.00987248046072;
dCoeff( 2) =  0.11846976552859;
dCoeff( 1) =  0.26655697243933;
c0         =  0.33113944878651;
FR_mag_h09 = Comp_FreqResp_filter(4, c0, dCoeff, Omega); 
FR_mag_h09 = abs(FR_mag_h09);

%----------------------------------------------------------------------
% Henderson filter (filter length 13 terms)
dCoeff( 6) = -0.01934984520124;
dCoeff( 5) = -0.02786377708978;
dCoeff( 4) =  0.0;
dCoeff( 3) =  0.06549178375804;
dCoeff( 2) =  0.14735651345558;
dCoeff( 1) =  0.21433674684449;
c0         =  0.24005715646583;
FR_mag_h13 = Comp_FreqResp_filter(6, c0, dCoeff, Omega); 
FR_mag_h13 = abs(FR_mag_h13);

%----------------------------------------------------------------------
% Henderson filter (filter length 21 terms)
dCoeff(10) = -0.00557029177719;
dCoeff( 9) = -0.01345481105601;
dCoeff( 8) = -0.01761357083696;
dCoeff( 7) = -0.01289565007706;
dCoeff( 6) =  0.00311906983571;
dCoeff( 5) =  0.02962788020785;
dCoeff( 4) =  0.06303804299543;
dCoeff( 3) =  0.09795617465467;
dCoeff( 2) =  0.12842263078987;
dCoeff( 1) =  0.14913595833662;
c0         =  0.15646913385413;
FR_mag_h21 = Comp_FreqResp_filter(10, c0, dCoeff, Omega); 
FR_mag_h21 = abs(FR_mag_h21);

% %----------------------------------------------------------------------
% % Henderson filter (filter length 23 terms)
% dCoeff(11) = -0.00427825789339;
% dCoeff(10) = -0.01091811414392;
% dCoeff( 9) = -0.01568694560908;
% dCoeff( 8) = -0.01452747571624;
% dCoeff( 7) = -0.00494789825931;
% dCoeff( 6) =  0.01343000956098;
% dCoeff( 5) =  0.03893289087466;
% dCoeff( 4) =  0.06830331732397;
% dCoeff( 3) =  0.09739547099899;
% dCoeff( 2) =  0.12194895108277;
% dCoeff( 1) =  0.13831793780529;
% c0         =  0.14406022795054;
% FR_mag_h23 = Comp_FreqResp_filter(11, c0, dCoeff, Omega); 
% FR_mag_h23 = abs(FR_mag_h23);

%----------------------------------------------------------------------
figure(1)
OmegaN = Omega/2/pi;
plot(OmegaN,FR_mag_s15, 'k', OmegaN, FR_mag_s21, 'k--', ...
     OmegaN,FR_mag_h09, 'b', ...
     OmegaN,FR_mag_h13, 'm', OmegaN,FR_mag_h21, 'g', 'Linewidth', 2); 
     xlim ([0 0.5]), ylim ([0 1.0]), grid
     xlabel('\omega/2\pi')
     ylabel('\midH(\omega)\mid')
     legend('Spencer 15-points', 'Spencer 21-points', ...
            'Henderson 09-points', ...
            'Henderson 13-points', 'Henderson 21-points')
     title ('Fig. 2.12: Magnitude responses of Spencer and Henderson filters')

figure(2)
plot(OmegaN,FR_mag_s15, 'k', OmegaN, FR_mag_s21, 'k--', ...
     OmegaN,FR_mag_h09, 'k--', ...
     OmegaN,FR_mag_h13, 'k-.', OmegaN,FR_mag_h21, 'k-.', 'Linewidth', 2); 
     xlim ([0 0.5]), ylim ([0 1.0]), grid
     xlabel('\omega/2\pi')
     ylabel('\midH(\omega)\mid')
     legend('Spencer 15-points', 'Spencer 21-points', ...
            'Henderson 09-points', ...
            'Henderson 13-points', 'Henderson 21-points')
     title ('Fig. 2.12: Magnitude responses of Spencer filters')

%----------------------------------------------------------------------
% A few other simple, running average filters

% 3 data points
dCoeff( 1) = 1/3.0;
c0         = 1/3.0;
FR_mag_N3 = Comp_FreqResp_filter(1, c0, dCoeff, Omega); 

% 5 data points
dCoeff( 2) = 1/5.0;
dCoeff( 1) = 1/5.0;
c0         = 1/5.0;
FR_mag_N5 = Comp_FreqResp_filter(2, c0, dCoeff, Omega); 

% 7 data points
dCoeff( 3) = 1/7.0;
dCoeff( 2) = 1/7.0;
dCoeff( 1) = 1/7.0;
c0         = 1/7.0;
FR_mag_N7 = Comp_FreqResp_filter(3, c0, dCoeff, Omega); 

% 9 data points
dCoeff( 4) = 1/9.0;
dCoeff( 3) = 1/9.0;
dCoeff( 2) = 1/9.0;
dCoeff( 1) = 1/9.0;
c0         = 1/9.0;
FR_mag_N9 = Comp_FreqResp_filter(4, c0, dCoeff, Omega); 


figure(3)
Omega=Omega/2/pi;
% plot(Omega,FR_mag_N3,'k'); grid
plot(Omega,FR_mag_N3,'k', Omega,FR_mag_N5,'b',...
     Omega,FR_mag_N7,'m', Omega,FR_mag_N9,'g', 'Linewidth', 2);
     xlim ([0 0.5]), ylim ([-0.4 1.0]), grid
     xlabel('\omega/2\pi')
     legend('3 data points', '5 data points', '7 data points', '9 data points')
     title ('Magnitude responses of simple running average filters')
          
%----------------------------------------------------------------------
