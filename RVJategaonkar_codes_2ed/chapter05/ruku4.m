function x = ruku4(state_eq, ts, x, dt, u1, u2, param, Nx)

% Subroutine for integration of state equations by Runge-Kutta 4th order
%
% Chapter 3: Model Postulates and Simulation
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA

dt2 = 0.5*dt;
xdt = zeros(Nx,1);

xdt = feval(state_eq, ts, x, u1, param);
rk1 = xdt*dt2;

u12 = (u1 + u2) / 2;    % average of u(k) and u(k+1) 
x1  = x + rk1;
xdt = feval(state_eq, ts, x1, u12, param);
rk2 = dt2*xdt;

x1  = x + rk2;
xdt = feval(state_eq, ts, x1, u12, param);
rk3 = dt2*xdt;

x1  = x + 2*rk3;
xdt = feval(state_eq, ts, x1, u2, param);
rk4 = dt2*xdt;

x   = x + (rk1 + 2.0*(rk2+rk3) + rk4)/3;

return
% end of subroutine
