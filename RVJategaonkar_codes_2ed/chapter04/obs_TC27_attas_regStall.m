function y = obs_TC27_attas_regStall(t, x, u, param, bXparV)

% Function to compute the output variables (i.e., RHS of observation equations) 
% Example: Quasi-steady stall model (longitudinal motion)
% Nonlinear regression model 
%
% Chapter 4: Output Error Method
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA


% State variables - no state variables for regression analysis

% Control inputs
de     = u( 1);              % Elevator deflection
q      = u( 5);              % Pitch rate
al     = u( 7);              % Angle of attack
vtas   = u( 9);              % True airspeed
alDot  = u(13);              % Alpha-Dot
Mach   = u(14);              % Mach number
lRef   = 3.159;              % wing chord, reference length for longitudinal motion
lambda = 7.22;               % aspect ratio
RhStar = 15;                 % distance elevator - wing

% Parameters
CD0  = param( 1);
Efak = param( 2);
CL0  = param( 3);
CLal = param( 4);
CLMa = param( 5);
Cm0  = param( 6);
Cmal = param( 7);
Cmq  = param( 8);
Cmde = param( 9);
CLde = -Cmde*lRef/RhStar;

% Parameters for stall model
A1     = param(10);
AlStar = param(11);
Tau2   = param(12);
CD_X0  = param(13);
CM_X0  = param(14);

% Normalization
qn = q*lRef/vtas;

% Basic lift, drag and pitching moment coefficients
CL   = CL0 + (CLal + CLMa*Mach)*al + CLde*de;
CD   = CD0 + CL^2/(Efak*pi*lambda);
CM25 = Cm0 + Cmal*al + Cmq*qn + Cmde*de;

% Stall hysteresis
if  alDot > 0,
    Tau2n = 0;
else
    Tau2n = Tau2*lRef/vtas;
end

X0      = 0.5 * (1 - tanh( A1*(al-Tau2n*alDot-AlStar) ));
X0Fak   = (0.5 * (1 + sqrt(X0)))^2;
DCAHyst = CLal*al*(X0Fak-1);

CL   = CL   + DCAHyst;
CD   = CD   + CD_X0*(1-X0);
CM25 = CM25 + CM_X0*(1-X0);

% Observations (dependent variables)
y(1) = CD;
y(2) = CL;
y(3) = CM25;

% y must be a column vector
y = y';

return
%end of function
