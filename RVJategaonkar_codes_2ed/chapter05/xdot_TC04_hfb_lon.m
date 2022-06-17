function xdot = xdot_TC04_hfb_lon(ts, x, u, param)

% Function to compute the state derivatives (i.e., RHS of system state equations) 
% test_case = 4 -- Longitudinal motion: HFB-320 Aircraft
% Nonlinear model in terms of non-dimensional derivatives as function of
% variables in the stability axes (V, alfa)   
%                  states  - V, alpha, theta, q
%                  outputs - V, alpha, theta, q, qdot, ax, az
%                  inputs  - de, thrust  
% State equations (5.86), (5.87)
%
% Chapter 5: Filter Error Method
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA

% State variables
VT    = x(1);
Alfa  = x(2);
The   = x(3);
Qrate = x(4);

% Input variables
de    = u(1);
Fe    = u(2);

% Parameters
CD0  = param( 1);
CDV  = param( 2);
CDAL = param( 3);
CL0  = param( 4);
CLV  = param( 5);
CLAL = param( 6);
CM0  = param( 7);
CMV  = param( 8);
CMAL = param( 9);
CMQ  = param(10);
CMDE = param(11);

% Geometry data
G0     =    9.80665D+0;
SBYM   =    4.02800D-3;
SCBYIY =    8.00270D-4;
FEIYLT =   -7.01530D-6;
V0     =  104.67000D+0;
RM     = 7472.00000D+0;
SIGMAT =    0.05240D+0;
RHO    =    0.79200D+0;
        
% Intermediate variables
QBAR   = 0.5D0 * RHO *VT^2;                  

% Right sides of state equations (5.86)
VTdot = -SBYM*QBAR    * (CD0 + CDV*VT/V0 + CDAL*Alfa)...
                             + Fe*cos(Alfa + SIGMAT)/RM + G0*sin(Alfa - The);

Aldot = -SBYM*QBAR/VT * (CL0 + CLV*VT/V0 + CLAL*Alfa )...
                             - Fe*sin(Alfa + SIGMAT)/(RM*VT) + Qrate + G0*cos(Alfa - The)/VT;

Qdot  =  SCBYIY*QBAR  * (CM0 + CMV*VT/V0 + CMAL*Alfa...
                             + 1.215D0*CMQ*Qrate/V0 + CMDE*de ) + FEIYLT*Fe;

% State derivatives
xdot(1) = VTdot;
xdot(2) = Aldot;
xdot(3) = Qrate;
xdot(4) = Qdot;

% xdot must be a column vector
xdot = xdot';

return
% end of function
