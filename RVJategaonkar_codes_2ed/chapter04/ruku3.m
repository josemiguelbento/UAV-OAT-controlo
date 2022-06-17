function x = ruku3(state_eq, ts, x, dt, u1, u2, param, Nx, bXparV)

% Subroutine for integration of state equations by Runge-Kutta 3rd order
%
% Chapter 3: Model Postulates and Simulation
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA

global rk_IntStp  tCur

dt3 = dt/3;
xdt = zeros(Nx,1);

% interval beginning
rk_IntStp = false;
tCur      = ts;

xdt = feval(state_eq, ts, x, u1, param);
rk1 = xdt;

% third-interval
rk_IntStp = true;
tCur      = ts + dt3;
u13 = u1 + (u2-u1)/3;         % interpolated between u(k) and u(k+1) 
x1  = x + rk1*dt3;
xdt = feval(state_eq, ts, x1, u13, param);
rk2 = xdt;

% two-third-interval
tCur = ts + 2*dt3;

x1  = x + rk2*dt3*2;
u23 = u1 + (u2-u1)*2/3;       % interpolated between u(k) and u(k+1) 
xdt = feval(state_eq, ts, x1, u23, param);
rk3 = xdt;

% 
x   = x + (rk1 + 3.0*rk3)*dt/4;

rk_IntStp = false;
tCur      = ts;

return
% end of subroutine
