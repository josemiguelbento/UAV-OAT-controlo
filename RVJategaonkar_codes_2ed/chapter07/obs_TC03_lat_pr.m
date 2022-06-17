function y = obs_TC03_lat_pr(ts, x, u, param)

% Chapter 7: Recursive Parameter Estimation 
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% by Ravindra V. Jategaonkar
% published by AIAA, Reston, VA 20191, USA
%
% Function to compute the observation variables (i.e., RHS of observation equations): 
% test_case = 3: Lateral-directional motion, nx=2, ny=2, nu=3, test aircraft ATTAS
%                states  - p, r
%                outputs - p, r
%                inputs  - aileron, rudder, beta 
% Observation equation (7.98)

p = x(1);
r = x(2);

y(1) = p;
y(2) = r;

% y must be a column vector
y = y';

return
%end of function
