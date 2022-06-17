function xdot = xdot_TC10_uAC_EigT(ts, x, u, param, bXparV)

% Function to compute the state derivatives (i.e., RHS of state equations)
% test_case = 10 -- Unstable aircraft, short period, Equation decoupling method
% variables:       states  - w, q
%                  outputs - az, w, q
%                  inputs  - de
%
% test_case=10 is similar to the test_case = 8; except for multiplication of
% Z and Uinp with eigTransf=exp(-0.7*t);
%
% Chapter 4: Output Error Method
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA


fak   = 0.0;
u0    = 44.5695;

% Eignevalue used in the data transformation (see mDefCase10.m)
sigmaT = 0.7;

w   = x(1);
q   = x(2);

eta = u(1) + fak*w;

zw    = param(1);
zq    = param(2);
zeta  = param(3);
mw    = param(4);
mq    = param(5);
meta  = param(6);

% Caveat: The state equations are to be programmed according to Eq. (9.28).
% i.e., xdot =(A-sigmaT*I)*xtilde + B*Utilde, where Utilde is available
% from the data pre-processing and xtilde is the state variable in the
% present case (correspodning to tranformed system).
% Only diagonal elements of original A-matrix are to be modified.
% In the present case the diagonal elements are zw and mq.

xdot(1) = (zw-sigmaT)*w  + u0*q + zq         *q  + zeta*eta;

xdot(2) =  mw        *w  +        (mq-sigmaT)*q  + meta*eta;
    
% xdot must be a column vector
xdot = xdot';

return
% end of function
