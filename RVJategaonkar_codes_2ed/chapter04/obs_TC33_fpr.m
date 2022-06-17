function y = obs_TC33_fpr(t, x, u, param, bXparV)

% Function to compute the output variables (i.e., RHS of observation equations) 
% test_case = 33 -- Flight path reconstruction, multiple time segments (NZI=3),
%                   longitudinal and lateral-directional motion
%                   states  - u, v, w, phi, theta, psi, h
%                   outputs - V, alpha, beta, phi, theta, psi, h
%                   inputs  - ax, ay, az, p, q, r, (pdot, qdot, rdot)
% Observation equations (10.12) 
% 
% ****** Estimation of Time delays in three variables **********
%
% Chapter 4: Output Error Method
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA


global nTdMx
global xWS_al  tNewX_al  iNewX_al
global xWS_be  tNewX_be  iNewX_be
% global xWS_phi  tNewX_phi  iNewX_phi
% global xWS_the  tNewX_the  iNewX_the
global xWS_psi  tNewX_psi  iNewX_psi

% Define maximum number of time points for delay matrix
nTdMx     = 40;

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

% Time delay in phi, theta, and psi
tDelay_al = param(11);
tDelay_be = param(12);
% tDelay_phi = param(11);
% tDelay_the = param(12);
tDelay_psi = param(13);

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



% Time delay in alpha, beta and psi
alNBTz = alNB;
[alNBTz, xWS_al, tNewX_al, iNewX_al] = ...
    timeDelay(alNBTz, tDelay_al, xWS_al, tNewX_al, iNewX_al, nTdMx);

beNBTz = beNB;
[beNBTz, xWS_be, tNewX_be, iNewX_be] = ...
    timeDelay(beNBTz, tDelay_be, xWS_be, tNewX_be, iNewX_be, nTdMx);

psiTz = psi;
[psiTz, xWS_psi, tNewX_psi, iNewX_psi] = ...
    timeDelay(psiTz, tDelay_psi, xWS_psi, tNewX_psi, iNewX_psi, nTdMx);


% Observation equations, Eqs. (10.12)

% Flow variables V, alpha, beta
y(1) = sqrt(uV.^2 + vV.^2 + wV.^2);
y(2) = f_al*alNBTz + b_al;             % Time delays alpha
y(3) = f_be*beNBTz + b_be;             % Time delays beta
% Attitude angles
y(4) = phi;
y(5) = theta;
y(6) = psiTz;                          % Time delayed psi
% pressure altitude
y(7) = h;

% y must be a column vector
y = y';

return
%end of function
