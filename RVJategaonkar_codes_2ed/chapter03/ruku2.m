function x = ruku2(state_eq, ts, x, dt, u1, u2, param, Nx)

% Subroutine for integration of state equations by Runge-Kutta 2nd order
%
% Chapter 3: Model Postulates and Simulation
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA

xdt = zeros(Nx,1);

% Beginning of interval
xdt = feval(state_eq, ts, x, u1, param);
rk1 = xdt*dt;

% End of interval
x1  = x + rk1;
xdt = feval(state_eq, ts, x1, u2, param);
rk2 = xdt*dt;

x   = x + (rk1 + rk2)/2;

return
% end of subroutine
