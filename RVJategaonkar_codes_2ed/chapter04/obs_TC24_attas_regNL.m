function y = obs_TC24_attas_regNL(t, x, u, param, bXparV)

% Function to compute the output variables (i.e., RHS of observation equations) 
% test_case = 24 -- Aerodynamic force and moment coefficients, multiple time segments (NZI=3),
%                   longitudinal and lateral-directional motion
%                   states  - no state variables for regression analysis
%                   outputs - V, alpha, beta, phi, theta, psi, h
%                   inputs  - ax, ay, az, p, q, r, (pdot, qdot, rdot)
% Observation equations (6.76) and (6.78);  Nonlinear regression model (drag polar)
%
% Chapter 4: Output Error Method
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA

% Control inputs
de   = u( 1);                % Elevator deflection
da   = u( 2);                % Aileron deflection
dr   = u( 3);                % Rudder deflection
p    = u( 4);                % Roll rate
q    = u( 5);                % Pitch rate
r    = u( 6);                % Yaw rate
al   = u( 7);                % Angle of attack
be   = u( 8);                % Angle of sideslip
vtas = u( 9);                % True airspeed
% rho  = u(10);              % density of air (reqd for data pre-processing only)
% qbar = 0.5*rho*vtas*vtas;  % dynamic pressure (reqd for data pre-processing only)
% FengL= u(11);              % engine thrust, left (reqd for data pre-processing only)
% FengR= u(12);              % engine thrust, right (reqd for data pre-processing only)

sRef   = 64.0;               % m2 (wing area)
lRef   = 3.159;              % m  (wing chord), reference length for longitudinal motion
bRef   = 10.75;              % m  (half the wing span), ref. length for lateral-directional
lambda = 7.22;               % -  aspect ratio


% Parameters
CD0  = param( 1);
efak = param( 2);
CY0  = param( 3);
CYbe = param( 4);
CL0  = param( 5);
CLal = param( 6);
Cl0  = param( 7);
Clbe = param( 8);
Clp  = param( 9);
Clr  = param(10);
Clda = param(11);
Cm0  = param(12);
Cmal = param(13);
Cmq  = param(14);
Cmde = param(15);
Cn0  = param(16);
Cnbe = param(17);
Cnp  = param(18);
Cnr  = param(19);
Cndr = param(20);

% Normalization, Eq. (6.77)
pn = p*bRef/vtas;
qn = q*lRef/vtas;
rn = r*bRef/vtas;

% Observation equations; Eqs. (6.76) and (6.78)

% Longitudinal motion CD, CL, Cm
CL   = CL0 + CLal*al;
y(1) = CD0 + CL^2/(efak*pi*lambda);
y(2) = CL;
y(3) = Cm0 + Cmal*al + Cmq*qn + Cmde*de;

% Lateral-directional motion: CY, CL_ac, CN_ac
y(4) = CY0 + CYbe*be;
y(5) = Cl0 + Clbe*be + Clp*pn + Clr*rn + Clda*da;
y(6) = Cn0 + Cnbe*be + Cnp*pn + Cnr*rn + Cndr*dr;

% y must be a column vector
y = y';

return
%end of function
