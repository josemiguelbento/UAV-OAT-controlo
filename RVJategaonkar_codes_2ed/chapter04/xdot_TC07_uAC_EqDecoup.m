function xdot = xdot_TC07_uAC_EqDecoup(ts, x, u, param, bXparV)

% Function to compute the state derivatives (i.e., RHS of state equations)
% test_case = 7 -- Unstable aircraft, short period, Equation Decoupling method
% variables:       states  - w, q
%                  outputs - az, w, q
%                  inputs  - de
%
% Equation decoupling method for unstable aircraft - Short period model
%
% Chapter 4: Output Error Method
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA

fak = 0.0;
u0  = 44.5695;

w   = x(1);
q   = x(2);

eta = u(1) + fak*w;
wm  = u(2);
qm  = u(3);

zw    = param(1);
zq    = param(2);
zeta  = param(3);
mw    = param(4);
mq    = param(5);
meta  = param(6);

% Off-diagonal terms with measured states
xdot(1) = zw*w  + u0*q + zq*qm + zeta*eta;
xdot(2) = mw*wm +        mq*q  + meta*eta;

% xdot must be a column vector
xdot = xdot';

return
% end of function
