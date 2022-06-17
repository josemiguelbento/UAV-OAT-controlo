function y = obs_TC06_uAC_RegSt(ts, x, u, param, bXparV)

% Function to compute the state derivatives (i.e., RHS of state equations)
% Definition of model, flight data, initial values etc. 
% test_case = 6 -- Unstable aircraft, short period, OEM
% variables:       states  - w, q
%                  outputs - az, w, q
%                  inputs  - de
%
% LS/OEM RegStartup method for unstable aircraft - Short period model
% test_case=6 is similar to test_case=8. The changes are in the state and
% observation equations. Measured values of w and q are used as u(2) and u(3).
%
% Chapter 4: Output Error Method
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA

fak = 0.0;

w   = x(1);
q   = x(2);

eta = u(1) + fak*w;
wm  = u(2);
qm  = u(3);

zw    = param(1);
zq    = param(2);
zeta  = param(3);
% mw    = param(4);
% mq    = param(5);
% meta  = param(6);

az = zw*wm + zq*qm + zeta *eta;

y(1) = az;
y(2) = w;
y(3) = q;

% y must be a column vector
y = y';

return
% end of function
