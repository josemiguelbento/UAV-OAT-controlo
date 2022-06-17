% Compute energy spectra of doublet input
%
% Chapter 2: Data Gathering 
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% published by AIAA, Reston, VA 20191, USA

clear all;
close all;

%--------------------------------------------------------------------------
dt1 = 0.6;                                        % time step
V   = [0.6 -0.6];                                 % Amplitudes
[w1,E1] = EnergySpectrum(V,dt1,0.01,12.5,100);    % energy spectrum

%--------------------------------------------------------------------------
dt2 = 0.8;
V   = [0.6 -0.6];
[w2,E2] = EnergySpectrum(V,dt2,0.01,12.5,100);

%--------------------------------------------------------------------------
dt3 = 1.2;
V = [0.6 -0.6];
[w3,E3] = EnergySpectrum(V,dt3,0.01,12.5,100);

%--------------------------------------------------------------------------
% Plot with x axis in rad/s  --  (Figure 2.6)
figure(1)
plot(w1,E1,'b',  w2,E2,'r',  w3,E3,'m');
axis([0 12, 0 1.2]);
xlabel('frequency, (rad/s)'); ylabel('Energy');
legend('dt = 0.6 s','dt = 0.8 s','dt = 1.2 s',1);

% Plot with x-axis in rad/s and Y-axis normalized energy
figure(2)
plot(w1,E1/dt1^2,'b',  w2,E2/dt2^2,'r',  w3,E3/dt3^2,'m');
axis([0 12, 0 1.0]);
xlabel('frequency, (rad/s)'); ylabel('Normalized energy (E/\Deltat^2)');
legend('dt = 0.6 s','dt = 0.8 s','dt = 1.2 s',1);

% Plot with x axis as normalized frequency (omega*dt)
w1 = w1 * dt1;
w2 = w2 * dt2;
w3 = w3 * dt3;
figure(3)
plot(w1,E1/dt1^2,'b', w2,E2/dt2^2,'r', w3,E3/dt3^2,'m');
axis([0 5, 0 1.0]);
xlabel('normalized frequency (Omega*dt)'); ylabel('E/\Deltat^2');
legend('dt = 0.6 s','dt = 0.8 s','dt = 1.2 s',1);
