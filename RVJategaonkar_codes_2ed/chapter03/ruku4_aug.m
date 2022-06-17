function xa = ruku4_aug(state_eq, ts, xa, dt, u1, u2, param, Nx, Nxp, Nparam)

% Integration of augmented state equations by Runge-Kutta 4th order.
% *** version for EKF, UKF and EFRLS ****
%
% This is a modified version of ruku4.m, extended to integrate the augmented
% state vector xa=[x param], where the first derivatives of the system states,
% xa(1:Nx), are computed in the state equations 'state_eq', and those of the
% parameters, xa(Nx+1:Nx+Nparam), being zero.
%
% Chapter 3: Model Postulates and Simulation
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA


dt2  = 0.5*dt;
xadt = zeros(Nxp,1);

% param(1:Nparam,1) = xa(Nx+1:Nx+Nparam);        % because xdots for parameters are
                                                 % zero, this assignment is not necessary
xadt(1:Nx) = feval(state_eq, ts, xa, u1, param);
rk1 = xadt*dt2;

u12 = ( u1 + u2 )/2;                             % average of u(k) and u(k+1) 
xa1 = xa + rk1;
% param(1:Nparam,1) = xa1(Nx+1:Nx+Nparam);       % see foregoing comment
xadt(1:Nx) = feval(state_eq, ts, xa1, u12, param);
rk2 = dt2*xadt;

xa1 = xa + rk2;
% param(1:Nparam,1) = xa1(Nx+1:Nx+Nparam);       % see foregoing comment
xadt(1:Nx) = feval(state_eq, ts, xa1, u12, param);
rk3 = dt2*xadt;

xa1 = xa + 2*rk3;
% param(1:Nparam,1) = xa1(Nx+1:Nx+Nparam);       % see foregoing comment
xadt(1:Nx) = feval(state_eq, ts, xa1, u2, param);
rk4 = dt2*xadt;

xa  = xa + (rk1 + 2.0*(rk2+rk3) + rk4)/3;

return
% end of subroutine
