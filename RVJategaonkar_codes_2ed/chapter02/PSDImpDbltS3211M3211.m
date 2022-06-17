% Compute power spectral densities of input signals:
% Impulse, Doublet, 3-2-1-1 and Modified 3-2-1-1
%
% This function computes power spectral densities of input signals using the
% function psd (needs signal processing toolbox of Matlab).
%
% Using the function "InputSigPSD" a general multistep input can be
% generated and its psd computed and plotted. It is necessary to specify
% the following input parameters
% Inputs:
%     V       Vector with amplitudes of step signals (both, amplitudes and number
%             of steps are defined by V)
%     dtSig   Length of one time step in seconds
%     t0      apply input signal starting at t = t0
%     T       Time vector
% Outputs:
%     sig     Time history of the input signal
%     f       Frequencies [1/s]
%     PSDsig  Energy spectrum
%
% Chapter 2: Data Gathering 
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% published by AIAA, Reston, VA 20191, USA

clear all;
close all;

t0 = 1;                      % apply input signal starting at t = t0
T  = [0:.1:10];             % Time vector

%--------------------------------------------------------------------------
% 3211-Signal
dt3211 = 0.3;                                      % time step
V      = [0.3 0.3 0.3 -0.3 -0.3 0.3 -0.3];         % amplitudes
[sig3211, f3211, PSD3211] = inputSigPSD(V, dt3211, t0, T);

%--------------------------------------------------------------------------
% Modified 3211-signal
dtM3211 = 0.3;                                     % time step
V       = [0.24 0.24 0.24 -0.36 -0.36 0.33 -0.33]; % amplitudes (0.8, 1.2, 1.1, 1.1)
[sigM3211, fM3211, PSDM3211] = inputSigPSD(V, dtM3211, t0, T);

%--------------------------------------------------------------------------
% Doublet
% The time step of doublet is obtained as follows:
% Assuming a dt3211 = 0.3, leads to omega*dt3211 = 1.6 (Eq. 2.11), which means
% omega = 1.6/0.3. Now from Eq. (2.9), Omega*dt11 = 2.3, the time step for the
% doublet input is given by: 2.3*0.3/1.6 = 0.4312.
dt11 = 0.43;                                       % time step
V    = [0.6 -0.6];                                 % amplitudes
[sig11, f11, PSD11] = inputSigPSD(V, dt11, t0, T);

%--------------------------------------------------------------------------
% Pulse
dt10 = 2.1;                                        % time step
V    = [1.0];                                      % amplitude
[sig10, f10, PSD10] = inputSigPSD(V, dt10, t0, T);

%--------------------------------------------------------------------------
% Plot input signals and their psd
figure(1)
plot(T,sig10,'b', T,sig11,'r', T,sig3211,'k', T,sigM3211,'m');
grid;
legend('Impulse', 'Doublet', '3211', 'Modified 3211', 1);

figure(2)
wn = f3211*dt3211;
plot(wn,PSD10/dt10^2,'b', wn,PSD11/dt11^2,'r',...
     wn,PSD3211/dt3211^2,'k', wn,PSDM3211/dtM3211^2,'m')
% axis([0 5, 0 0.7]); grid;
axis([0 5, 0 1.2]); grid;
xlabel('normalized frequency'); ylabel('Normalized PSD');
legend('Impulse', 'Doublet', '3211', 'Modified 3211', 1);
