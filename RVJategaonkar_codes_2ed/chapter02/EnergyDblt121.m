% Compute energy spectra for Impulse, Doublet, 3-2-1-1 and M3-2-1-1
%
% Chapter 2: Data Gathering 
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% published by AIAA, Reston, VA 20191, USA

clear all;
close all;

%--------------------------------------------------------------------------
% Doublet
V   = [0.6 -0.6];                                 % amplitudes
dt1 = 0.6;                                        % time step
[w,E1] = EnergySpectrum(V,dt1,0.01,12.5,100);

V   = [0.6 -0.6];
dt2 = 0.8;
[w,E2] = EnergySpectrum(V,dt2,0.01,12.5,100);

V   = [0.6 -0.6];
dt3 = 1.2;
[w,E3] = EnergySpectrum(V,dt3,0.01,12.5,100);

%--------------------------------------------------------------------------
% 121-signal
V     = [0.32 -0.32 -0.32 0.32];                  % amplitudes
dt121 = 0.3;                                      % time step
[w,E4] = EnergySpectrum(V,dt121,0.01,12.5,100);

%--------------------------------------------------------------------------
plot(w,E1/dt1^2, 'b',  w,E2/dt2^2, 'r',  w,E3/dt3^2,'g',  w,E4/dt121^2, 'm');
axis([0 12, 0 1]);
xlabel('frequency, (rad/s)'); ylabel('E/\Deltat2');