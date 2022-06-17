% To generate multistep input  signal of specified time steps and input amplitudes;
% and to compute the power spectral density using psd function:
% (needs signal processing toolbox of Matlab).
% 
% Chapter 2: Data Gathering 
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% published by AIAA, Reston, VA 20191, USA
%
% Inputs:
%     V        Vector with amplitudes of step signals
%     dtSig    Length of one time step in seconds
%     t0       Apply input signal starting at t = t0
%     T        Time vector
%
% Outputs:
%     sig      Time history of the input signal
%     f        Frequencies [1/s]
%     PSDsig   Energy spectrum


function [sig, f, PSDsig] = inputSigPSD(V, dtSig, t0, T);

%--------------------------------------------------------------------------
% get the sampling time
ntime = length(T);
dt    = (T(end)-T(1)) / (ntime-1);

%--------------------------------------------------------------------------
% Generate time history of input signal 
sig = zeros(t0/dt,1)';
for k=1:size(V,2)
    sig = [sig ones(length([0:dt:(dtSig-dt)]),1)'*V(k)];
end
sig = [sig zeros(1,length(T)-length(sig))];

%--------------------------------------------------------------------------
% Compute power spectral density
% Nf    = 2^14;       % frequency points: fft at Nf/2+1 frequencies, default value
Nf    = length(sig);  %256;       % frequency points: fft at Nf/2+1 frequencies, default value
Omega = 1/dt*2*pi;    % sampling frequency [rad/sec]

% Power Spectral Density:
% [PSDsig,f] = psd(sig, Nf, Omega, rectwin(Nf));     % rectangular window
[PSDsig,f] = psd(sig, Nf, Omega, boxcar(Nf));     % boxcar window

return