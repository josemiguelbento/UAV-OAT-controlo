% Compute energy spectra for doublet and 3-2-1-1 inputs
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
% The time step of doublet is obtained as follows:
% Assuming a dt3211 = 1, leads to omega*dt3211 = 1.6 (Eq. 2.11), which means
% omega = 1.6/1 Now from Eq. (2.9), Omega*dt11 = 2.3, the time step for the
% doublet input is given by: 2.3*1/1.6 = 1.4375.
dt11 = 1.44;                                       % time step
V    = [0.6 -0.6];                                 % amplitudes
[w2,E2] = EnergySpectrum(V,dt11,0.01,20,1000);

%--------------------------------------------------------------------------
% 3211-Signal
dt3211 = 1;                                        % time step
V      = [0.3 0.3 0.3 -0.3 -0.3 0.3 -0.3];         % amplitudes
[w3,E3] = EnergySpectrum(V,dt3211,0.01,20,1000);

%--------------------------------------------------------------------------
% plot
plot(w2,E2/dt11^2,'b',  w3,E3/dt3211^2,'m');
axis([0 5, 0 1.2]); grid;
xlabel('frequency, (rad/s)'); ylabel('E/\Deltat2'); 