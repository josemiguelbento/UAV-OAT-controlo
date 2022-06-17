function y = obs_fpr(t, x, u, param, bXparV)

% Function to compute the output variables (i.e., RHS of observation equations) 
% test_case = 22 -- Flight path reconstruction, multiple time segments (NZI=3),
%                   longitudinal and lateral-directional motion
%                   states  - u, v, w, phi, theta, psi, h
%                   outputs - V, alpha, beta, phi, theta, psi, h
%                   inputs  - ax, ay, az, p, q, r, (pdot, qdot, rdot)
% Observation equations (10.12)
%
% Chapter 4: Output Error Method
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA

% State variables
uV    = x(1);
vV    = x(2);
wV    = x(3);
phi   = x(4);
theta = x(5);
psi   = x(6);
h     = x(7);

% Parameters
% b_ax  = param(1);
% b_ay  = param(2);
% b_az  = param(3);
b_p   = param(4);
b_q   = param(5);
b_r   = param(6);

% Scale factor and bias for angle of attack and angle of sideslip
% f_al = 1;
% b_al = 0;
% f_be = 1;
% b_be = 0;

f_al = param(7);
b_al = param(8);
f_be = param(9);
b_be = param(10);

% correct control inputs (accelerations and angular rates) for measurement offsets
p  = u(4) - b_p;
q  = u(5) - b_q;
r  = u(6) - b_r;

% Velocity components at NoseBoom, Eq. (10.13)
xNBCG = 13.080;
yNBCG = -0.010;
zNBCG = -0.027;
uNB   = uV - r*yNBCG + q*zNBCG;
vNB   = vV - p*zNBCG + r*xNBCG;
wNB   = wV - q*xNBCG + p*yNBCG;
alNB  = atan2(wNB,uNB);
beNB  = atan2(vNB,uNB);

% Observation equations, Eqs. (10.12)

% Flow variables V, alpha, beta
y(1) = sqrt(uV.^2 + vV.^2 + wV.^2);
y(2) = f_al*alNB + b_al;
y(3) = f_be*beNB + b_be;
% Attitude angles
y(4) = phi;
y(5) = theta;
y(6) = psi;
% pressure altitude
y(7) = h;

% y must be a column vector
y = y';

return
%end of function
