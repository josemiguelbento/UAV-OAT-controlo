function [kGain, pcov] = kGainPcov(pcov, u0u1, lamda)

% Compute the Kalman gain matrix and update the covariance matrix
%
% Chapter 8: Artificial Neural Networks
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA
%

% Compute the Kalman gain, Eq. (41a) and (42a) respectively 
kGain = pcov*u0u1 / (lamda + u0u1'*pcov*u0u1);

% Compute the covariance matrix, Eq. (41b) and (42b) respectively 
pcov = (pcov - kGain*u0u1'*pcov) / lamda;

return
% end of function
