function y = obs_TC04_hfb_lon_xyNoise(ts, x, u, param, yNoise)

% Chapter 7: Recursive Parameter Estimation 
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% by Ravindra V. Jategaonkar
% published by AIAA, Reston, VA 20191, USA
%
% Function to compute the observation variables (i.e., RHS of observation equations): 
% test_case = 4 -- Longitudinal motion: HFB-320 Aircraft
% Nonlinear model in terms of non-dimensional derivatives as function of
% variables in the stability axes (V, alfa)   
%                  states  - V, alpha, theta, q
%                  outputs - V, alpha, theta, q, qdot, ax, az
%                  inputs  - de, thrust  
% Observation equations (5.88), (5.89), (5.87)

% State variables
VT    = x(1);
Alfa  = x(2);
The   = x(3);
Qrate = x(4);

% Input variables
de    = u(1);
Fe    = u(2);

% Parameters
CD0   = param( 1);
CDV   = param( 2);
CDAL  = param( 3);
CL0   = param( 4);
CLV   = param( 5);
CLAL  = param( 6);
CM0   = param( 7);
CMV   = param( 8);
CMAL  = param( 9);
CMQ   = param(10);
CMDE  = param(11);

% Geometry data
G0     =    9.80665D+0;
SBYM   =    4.0280D-3;
SCBYIY =    8.0027D-4;
FEIYLT =   -7.0153D-6;
V0     =  104.6700D+0;
RM     = 7472.0000D+0;
SIGMAT =    0.0524D+0;
RHO    =    0.7920D+0;
cbarH  =    1.215D0;

% Intermediate variables
QBAR   = 0.5D0 * RHO *x(1)^2;

CD    =  CD0 + CDV*VT/V0 + CDAL*Alfa;
CL    =  CL0 + CLV*VT/V0 + CLAL*Alfa;
SALFA =  sin(Alfa);
CALFA =  cos(Alfa);
CX    =  CL*SALFA - CD*CALFA;
CZ    = -CL*CALFA - CD*SALFA;

% Observations
y(1)  =  VT    + yNoise(1);
y(2)  =  Alfa  + yNoise(2);
y(3)  =  The   + yNoise(3);
y(4)  =  Qrate + yNoise(4);
y(5)  =  SCBYIY*QBAR * (CM0 + CMV*VT/V0 + CMAL*Alfa + CMQ*Qrate*cbarH/V0 + CMDE*de)...
              + FEIYLT*Fe  + yNoise(5);
y(6)  =  QBAR*SBYM*CX + Fe*cos(SIGMAT)/RM + yNoise(6);
y(7)  =  QBAR*SBYM*CZ - Fe*sin(SIGMAT)/RM + yNoise(7);

% y must be a column vector
y = y';

return
% end of function
