function y = obs_TC11_lon_sp_xyNoise(ts, x, u, param, yNoise)

% Chapter 7: Recursive Parameter Estimation 
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% by Ravindra V. Jategaonkar
% published by AIAA, Reston, VA 20191, USA
%
% Function to compute the observation variables: longitudinal (short-period) motion

alfa  = x(1);
q     = x(2);

% z0    = param(1);
% zalfa = param(2);
% zq    = param(3);
% zdele = param(4);
% m0    = param(5);
% malfa = param(6);
% mq    = param(7);
% mdele = param(8);
% 
% dele  = u(1);

y(1) = alfa + yNoise(1);
y(2) = q    + yNoise(2);

% y must be a column vector
y = y';

return
% end of function
