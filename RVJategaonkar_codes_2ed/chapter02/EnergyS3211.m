% Compute energy spectrum for 3-2-1-1 input
%
% Chapter 2: Data Gathering 
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% published by AIAA, Reston, VA 20191, USA

clear all;
close all;

%--------------------------------------------------------------------------
% 3211-Signal
dt3211 = 0.3;                                      % time step
V      = [0.3 0.3 0.3 -0.3 -0.3 0.3 -0.3];         % amplitudes
[w3,E3] = EnergySpectrum(V,dt3211,0.0,20,100);

%--------------------------------------------------------------------------
% plot
figure,plot(w3,E3/dt3211^2,'m');
axis([0 12, 0 1]);
xlabel('frequency, (rad/s)'); ylabel('E/\Deltat2');
