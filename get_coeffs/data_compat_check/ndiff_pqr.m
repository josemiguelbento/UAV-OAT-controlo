function [pDot, qDot, rDot] = ndiff_pqr(Nzi, izhf, dt, p, q, r) 

% Generate pdot, qdot, rdot by differentiation of p, q, r
%
% Chapter 4: Output Error Method
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA
%
% Function to compute the state derivatives (i.e., RHS of state equations) 
% Example: Flight Path Reconstruction

% filter signals before differentiation
pSm = smoothMulTS(p, Nzi, izhf);
qSm = smoothMulTS(q, Nzi, izhf); 
rSm = smoothMulTS(r, Nzi, izhf); 

% numerical differentiation
pDot = ndiff_Filter08(pSm, Nzi, izhf, dt);
qDot = ndiff_Filter08(qSm, Nzi, izhf, dt); 
rDot = ndiff_Filter08(rSm, Nzi, izhf, dt); 

return
