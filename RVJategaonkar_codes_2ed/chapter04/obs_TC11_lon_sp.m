function y = obs_TC11_lon_sp(ts, x, u, param, bXparV)

% Function to compute the observation variables: short-period motion
% test_case = 11: Short period motion, nx=2, ny=2, nu=1, test aircraft ATTAS
%                 states  - alpha, q
%                 outputs - alpha, q
%                 inputs  - de 
%
% Chapter 4: Output Error Method
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA

alfa = x(1);
q    = x(2);

y(1) = alfa;
y(2) = q;

% y must be a column vector
y = y';

return
% end of function
