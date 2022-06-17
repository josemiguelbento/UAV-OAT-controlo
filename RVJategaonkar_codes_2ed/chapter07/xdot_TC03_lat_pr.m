function xdot = xdot_TC03_lat_pr(ts, x, u, param)

% Function to compute the state derivatives (i.e., RHS of state equations) 
% test_case = 3: Lateral-directional motion, nx=2, ny=2, nu=3, test aircraft ATTAS
%                states  - p, r
%                outputs - p, r
%                inputs  - aileron, rudder, beta 
% State equation (7.97)
%
% Chapter 7: Recursive Parameter Estimation 
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% by Ravindra V. Jategaonkar
% published by AIAA, Reston, VA 20191, USA

p     = x(1);
r     = x(2);

Lp    = param(1);
Lr    = param(2);
Ldla  = param(3);
Ldlr  = param(4);
Lbeta = param(5);
L0    = param(6);
Np    = param(7);
Nr    = param(8);
Ndla  = param(9);
Ndlr  = param(10);
Nbeta = param(11);
N0    = param(12);

dela  = u(1);
delr  = u(2);
beta  = u(3);

xdot(1) = Lp*p + Lr*r + Ldla*dela + Ldlr*delr + Lbeta*beta + L0;
    
xdot(2) = Np*p + Nr*r + Ndla*dela + Ndlr*delr + Nbeta*beta + N0;

% xdot must be a column vector
xdot = xdot';

return
% end of function
