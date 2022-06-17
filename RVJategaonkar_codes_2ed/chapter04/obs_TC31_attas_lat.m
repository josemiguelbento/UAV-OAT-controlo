function y = obs_TC31_attas_lat(ts, x, u, param, bXparV)

% Function to compute the observation variables (i.e., RHS of observation equations): 
% test_case = 1: Lateral-directional motion, nx=2, ny=5, nu=3, test aircraft ATTAS
%                states  - p, r
%                outputs - pdot, rdot, ay, p, r
%                inputs  - aileron, rudder, beta 
% Observation equation (4.91)
%
% Chapter 4: Output Error Method
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA


global xWS  tNewX  iNewX  nTdMx

p    = x(1);
r    = x(2);

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

Yp    = param(11);
Yr    = param(12);
Yda   = param(13);
Ydr   = param(14);
Ybeta = param(15);

% BX1   = param(16);
% BX2   = param(17);

BY1   = param(18);
BY2   = param(19);
BY3   = param(20);
BY4   = param(21);
BY5   = param(22);

tDelay_r = param(23);        % Time delay in yaw aret r

dela  = u(1);
delr  = u(2);
beta  = u(3);

% Time delay in r 
rTz = r;
[rTz, xWS, tNewX, iNewX] = timeDelay(rTz, tDelay_r, xWS, tNewX, iNewX, nTdMx);

pdot = Lp*p + Lr*r + Lda*dela + Ldr*delr + Lbeta*beta;
    
rdot = Np*p + Nr*r + Nda*dela + Ndr*delr + Nbeta*beta;

ay   = Yp*p + Yr*r + Yda*dela + Ydr*delr + Ybeta*beta;

y(1) = pdot + BY1;
y(2) = rdot + BY2;
y(3) = ay   + BY3;
y(4) = p    + BY4;
y(5) = rTz  + BY5;
    
% y must be a column vector
y = y';

return
% end of function
