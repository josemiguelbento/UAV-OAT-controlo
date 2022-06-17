function x = ruku2(state_eq, ts, x, dt, u1, u2, param, Nx, bXparV)

% Subroutine for integration of state equations by Runge-Kutta 2nd order
%
% Chapter 3: Model Postulates and Simulation
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA

global rk_IntStp  tCur

xdt = zeros(Nx,1);

% Beginning of interval
rk_IntStp = false;
tCur      = ts;

xdt = feval(state_eq, ts, x, u1, param);
rk1 = xdt*dt;

% End of interval
rk_IntStp = true;
tCur      = ts + dt;

x1  = x + rk1;
xdt = feval(state_eq, ts, x1, u2, param);
rk2 = xdt*dt;

% 
x   = x + (rk1 + rk2)/2;

rk_IntStp = false;
tCur      = ts;

return
% end of subroutine
