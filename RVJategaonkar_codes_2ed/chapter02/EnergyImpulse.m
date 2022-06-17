% Compute energy spectra of input signal Impulse (Rectangular pulse)
%
% Chapter 2: Data Gathering 
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% published by AIAA, Reston, VA 20191, USA

clear all;
close all;

%--------------------------------------------------------------------------
dt1 = 0.4;                                        % time step
V   = [0.4];                                      % amplitude
[w,E1] = EnergySpectrum(V,dt1,0.01,12.5,100);     % energy spectrum

%--------------------------------------------------------------------------
dt2 = 0.8;
V   = [0.4];
[w,E2] = EnergySpectrum(V,0.8,0.01,12.5,100);

%--------------------------------------------------------------------------
dt3 = 1.2;
V   = [0.4];
[w,E3] = EnergySpectrum(V,1.2,0.01,12.5,100);

%--------------------------------------------------------------------------
% Plot with x axis in rad/s  --  (Figure 2.5)
plot(w,E1,'b', w,E2,'r', w,E3,'m');
axis([0 12, 0 0.30]);
xlabel('frequency, (rad/s)'); ylabel('E');
legend('dt = 0.4 s','dt = 0.8 s','dt = 1.2 s',1);
