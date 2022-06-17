function y = obs_TC03_lat_pr(ts, x, u, param, bXparV)

% Function to compute the observation variables (i.e., RHS of observation equations): 
% test_case = 3: Lateral-directional motion, nx=2, ny=2, nu=3, test aircraft ATTAS
%                states  - p, r
%                outputs - p, r
%                inputs  - aileron, rudder, beta 
% Observation equation (7.98)
%
% Chapter 4: Output Error Method
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA

p = x(1);
r = x(2);

y(1) = p;
y(2) = r;

% y must be a column vector
y = y';

return
%end of function
