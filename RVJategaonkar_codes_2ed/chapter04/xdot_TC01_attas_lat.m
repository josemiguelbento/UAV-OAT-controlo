function xdot = xdot_TC01_attas_lat(ts, x, u, param, bXparV)

% Function to compute the state derivatives (i.e., RHS of system state equations): 
% test_case = 1: Lateral-directional motion, nx=2, ny=5, nu=3, test aircraft ATTAS
%                states  - p, r
%                outputs - pdot, rdot, ay, p, r
%                inputs  - aileron, rudder, beta 
% State equations (4.90)
%
% Chapter 4: Output Error Method
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA


p     = x(1);
r     = x(2);

Lp    = param(1);
Lr    = param(2);
Lda   = param(3);
Ldr   = param(4);
Lbeta = param(5);

Np    = param(6);
Nr    = param(7);
Nda   = param(8);
Ndr   = param(9);
Nbeta = param(10);

% Yp    = param(11);
% Yr    = param(12);
% Yda   = param(13);
% Ydr   = param(14);
% Ybeta = param(15);

BX1   = param(16);
BX2   = param(17);

dela  = u(1);
delr  = u(2);
beta  = u(3);

xdot(1) = Lp*p + Lr*r + Lda*dela + Ldr*delr + Lbeta*beta + BX1;

xdot(2) = Np*p + Nr*r + Nda*dela + Ndr*delr + Nbeta*beta + BX2;

% xdot must be a column vector
xdot = xdot';

return
% end of function