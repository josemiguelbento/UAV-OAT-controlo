function xdot = xdot_TC02_dhc2_lat(ts, x, u, param)

% Function to compute the state derivatives (i.e., RHS of system state equations):
% test_case = 2: Lateral-directional motion, nx=2, ny=5, nu=3, 
%                Simulated data with process noise
%                states  - p, r
%                outputs - pdot, rdot, ay, p, r
%                inputs  - aileron, rudder, v 
% State equation (5.83)
%
% Chapter 5: Filter Error Method
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
Lv    = param(5);

Np    = param(6);
Nr    = param(7);
Nda   = param(8);
Ndr   = param(9);
Nv    = param(10);

% Yp    = param(11);
% Yr    = param(12);
% Yda   = param(13);
% Ydr   = param(14);
% Yv    = param(15);

BX1   = param(16);
BX2   = param(17);

dela  = u(1);
delr  = u(2);
vk    = u(3);

xdot(1) = Lp*p + Lr*r + Lda*dela + Ldr*delr + Lv*vk + BX1;

xdot(2) = Np*p + Nr*r + Nda*dela + Ndr*delr + Nv*vk + BX2;

% xdot must be a column vector
xdot = xdot';

return
% end of function
