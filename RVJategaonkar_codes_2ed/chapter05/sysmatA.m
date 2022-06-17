function Amat = sysmatA(state_eq, Nx, Nparam, x, delx, u, param, ts)

% Linearized state matrix A by central difference approximation
% 
% Chapter 5: Filter Error Method
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA
%
% Inputs:
%    state_eq      function coding the state equations
%    Nx            number of state variables
%    Nparam        total number of parameters appearing in the postulated model
%    x             state vector (Nx)
%    delx          Perturbations to compute approximations of system matrices
%    u             input vector (Nu)
%    param         parameter vector (Nparam)
%    ts            time vector
%
% Outputs:
%    Amat          Linearized system matrix (Nx,Nx)


xin  = x;
xdt3 = zeros(Nx,1);
xdt4 = zeros(Nx,1);

for ix=1:Nx
    zip1 = xin(ix);
    del2 = 2*delx(ix);
   
    xin(ix) = zip1 + delx(ix);
    xdt3    = feval(state_eq, ts, xin, u, param);

    xin(ix) = zip1 - delx(ix);
    xdt4    = feval(state_eq, ts, xin, u, param);
   
    Amat(:,ix) = (xdt3 - xdt4) / del2;           % Eq. (5.50)
     
    xin(ix) = zip1;
end

return
% end of subroutine
