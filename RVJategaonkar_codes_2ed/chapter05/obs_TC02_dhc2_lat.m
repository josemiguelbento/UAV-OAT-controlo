function y = obs_TC02_dhc2_lat(ts, x, u, param)

% Function to compute the observation variables (i.e., RHS of observation equations): 
% test_case = 2: Lateral-directional motion, nx=2, ny=5, nu=3, 
%                Simulated data with process noise
%                states  - p, r
%                outputs - pdot, rdot, ay, p, r
%                inputs  - aileron, rudder, v 
% Observation equation (5.84)
%
% Chapter 5: Filter Error Method
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA

p    = x(1);
r    = x(2);

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

Yp    = param(11);
Yr    = param(12);
Yda   = param(13);
Ydr   = param(14);
Yv    = param(15);

% BX1   = param(16);
% BX2   = param(17);

BY1   = param(18);
BY2   = param(19);
BY3   = param(20);
BY4   = param(21);
BY5   = param(22);

dela  = u(1);
delr  = u(2);
vk    = u(3);

pdot = Lp*p + Lr*r + Lda*dela + Ldr*delr + Lv*vk;
    
rdot = Np*p + Nr*r + Nda*dela + Ndr*delr + Nv*vk;

ay   = Yp*p + Yr*r + Yda*dela + Ydr*delr + Yv*vk;

y(1) = pdot + BY1;
y(2) = rdot + BY2;
y(3) = ay   + BY3;
y(4) = p    + BY4;
y(5) = r    + BY5;

% y must be a column vector
y = y';

return
% end of function
