% Compute energy spectrum of an arbitrary multistep input signal (Equation 2.8).
%
% Chapter 2: Data Gathering 
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% published by AIAA, Reston, VA 20191, USA
%
% function [w,E] = EnergySpectrum(V,dt,wa,we,nw)
% Inputs: 
%           V   Vector with amplitudes of step signals
%           dt  Length of one time step in seconds
%           wa  Starting frequency
%           we  Final frequency
%           nw  Number of frequency points (default=100)
% Outputs:
%           w   Frequencies [1/s]
%           E   Energy spectrum
%


function [w,E] = energie(V,dt,wa,we,nw)

% Check Parameters
if nargin < 4
    disp('ERROR: Missing Parameters');
    return;
end

if dt <= 0
    disp('ERROR: dt smaller than 0');
    return;
end

if we <= wa
    disp('ERROR: Final frequency smaller than starting frequency');
    return;
end

if nargin == 4
    nw = 100;
end

if nw < 2
    disp('ERROR: Too few Frequency values');
    return;
end

% Initialization
n = length(V);                    % Number of time steps
w = linspace(wa, we, nw);         % Frequency in 1/s

% Computation of Energy for specified frequency range
E = V*V';
for j=1:n-1
    E = E + 2 * cos(j*w*dt) .* (V(1:n-j) * V(1+j:n)');
end

if w(1) == 0
    E(1)     = E(1)*dt^2;         % Limit value of (1-cos(w*dt)/w^2)*2 for w->0 = dt^2
    E(2:end) = 2 * E(2:end) .* (1 - cos(w(2:end)*dt)) ./ (w(2:end).^2);
else
    E = 2 * E .* (1 - cos(w*dt)) ./ (w.^2);
end

return;
