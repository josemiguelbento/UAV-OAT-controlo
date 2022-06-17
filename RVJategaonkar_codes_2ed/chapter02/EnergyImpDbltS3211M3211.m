% Compute energy spectra for Impulse, Doublet, 3-2-1-1 and Modified 3-2-1-1
%
% This program computes power spectral densities of input signals
% using Eq. (2.8) of Chapter 2:
%
% Using the function "EnergySpectrum" a spectrum of any general multistep
% input can be calculated and plotted.
% The following input parameters are necessary for EnergySpectrum:
% Inputs: 
%     V        Vector with amplitudes of step signals (both, amplitudes and number
%              of steps are defined by V)
%     dtSig    Length of one time step in seconds
%     wa       Starting frequency
%     we       Final frequency
%     nw       Number of frequency points (default=100)
%
% Outputs:
%     w        Frequencies [1/s]
%     E        Energy spectrum
% 
% Chapter 2: Data Gathering 
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% published by AIAA, Reston, VA 20191, USA

clear all;
close all;

%--------------------------------------------------------------------------
% 3-2-1-1 Signal
dt3211 = 1;                                        % time step (1 sec dt)
V      = [0.3 0.3 0.3 -0.3 -0.3 0.3 -0.3];         % amplitudes
[w3,E3] = EnergySpectrum(V,dt3211,0.01,20,1000);

%--------------------------------------------------------------------------
% Modified 3-2-1-1 signal
dtM3211 = 1;                                       % time step
V       = [0.24 0.24 0.24 -0.36 -0.36 0.33 -0.33]; % amplitudes (0.8, 1.2, 1.1, 1.1)
[w4,E4] = EnergySpectrum(V,dtM3211,0.01,20,1000);

%--------------------------------------------------------------------------
% Doublet
% The time step of doublet is obtained as follows:
% Assuming a dt3211 = 1, leads to omega*dt3211 = 1.6 (Eq. 2.11), which means
% omega = 1.6/1. Now from Eq. (2.9), Omega*dt11 = 2.3, the time step for the
% doublet input is given by: 2.3/1.6 = 1.4375.
dt11 = 1.44;                                       % time step
V    = [0.6 -0.6];                                 % amplitudes
[w2,E2] = EnergySpectrum(V,dt11,0.01,20,1000);

%--------------------------------------------------------------------------
% Pulse
dt1 = 7;                                           % time step (same total duration)
V   = [1.0];                                       % amplitude
[w1,E1] = EnergySpectrum(V,dt1,0.0001,20,1000);

%--------------------------------------------------------------------------
% plot
wn = w3*dt3211;
plot(wn,E1/dt1^2,'b', wn,E2/dt11^2,'r', wn,E3/dt3211^2,'k', wn,E4/dtM3211^2,'m'); grid;
axis([0 5, 0 1.2]);
xlabel('normalized frequency'); ylabel('E/\Deltat2');
legend('Impulse', 'Doublet', '3211', 'Modified 3211', 1);
