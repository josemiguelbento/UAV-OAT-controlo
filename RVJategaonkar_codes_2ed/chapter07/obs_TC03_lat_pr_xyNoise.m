function y = obs_TC03_lat_pr_xyNoise(ts, x, u, param, yNoise)

% Chapter 7: Recursive Parameter Estimation 
% Second Edition
% by Ravindra V. Jategaonkar
% published by AIAA, Reston, VA 20191, USA
%
% Function to compute the observation variables (i.e., RHS of observation equations): 
% test_case = 3: Lateral-directional motion, nx=2, ny=2, nu=3, test aircraft ATTAS
%                states  - p, r
%                outputs - p, r
%                inputs  - aileron, rudder, beta 
% Observation equation (7.98) + noise variables

p = x(1);
r = x(2);

y(1) = p + yNoise(1);
y(2) = r + yNoise(2);

% y must be a column vector
y = y';

return
%end of function
