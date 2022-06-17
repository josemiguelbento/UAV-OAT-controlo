function y = obs_TC08_uAC(ts, x, u, param)

% Chapter 7: Recursive Parameter Estimation 
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% by Ravindra V. Jategaonkar
% published by AIAA, Reston, VA 20191, USA
%
% Function to compute the observation variables: longitudinal (short-period) motion
% test_case = 8  -- Unstable aircraft, short period, 
% variables:        states  - w, q
%                   outputs - az, w, q
%                   inputs  - de
%
% This function is used for several test cases
% test_case =  7 -- Unstable aircraft, short period, Equation Decoupling method
% test_case =  8 -- Unstable aircraft, short period, ouput error method
% test_case =  9 -- Unstable aircraft, short period, stabilized ouput error method
% test_case = 10 -- Unstable aircraft, short period, Eigenvalue transformation

fak = 0.0;

w   = x(1);
q   = x(2);

eta = u(1) + fak*w;

zw    = param(1);
zq    = param(2);
zeta  = param(3);
% mw    = param(4);
% mq    = param(5);
% meta  = param(6);

az = zw*w + zq*q + zeta *eta;

y(1) = az;
y(2) = w;
y(3) = q;

% y must be a column vector
y = y';

return
% end of function
