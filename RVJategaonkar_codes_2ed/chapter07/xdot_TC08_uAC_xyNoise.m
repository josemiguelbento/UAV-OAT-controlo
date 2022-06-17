function xdot = xdot_TC08_uAC_xyNoise(ts, x, u, param, xNoise)

% Function to compute the state derivatives (i.e., RHS of state equations)
% test_case = 8 -- Unstable aircraft, short period, Output error method
% variables:       states  - w, q
%                  outputs - az, w, q
%                  inputs  - de
%
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% by Ravindra V. Jategaonkar
% published by AIAA, Reston, VA 20191, USA

fak = 0.0;
u0  = 44.5695;

w   = x(1);
q   = x(2);

eta = u(1) + fak*w;

zw    = param(1);
zq    = param(2);
zeta  = param(3);
mw    = param(4);
mq    = param(5);
meta  = param(6);

xdot(1) = zw*w  + u0*q + zq*q  + zeta*eta + xNoise(1);
xdot(2) = mw*w  +        mq*q  + meta*eta + xNoise(2);
    
% xdot must be a column vector
xdot = xdot';

return
% end of function
