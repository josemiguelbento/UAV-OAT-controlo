function Cmat = sysmatC(obser_eq, Ny, Nx, Nparam, x, delx, u, param, ts)

% Measurement matrix C by linearization by central difference approximation
% 
% Chapter 5: Filter Error Method
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA
%
% Inputs:
%    obser_eq      function coding the observation equations
%    Ny            number of output variables
%    Nx            number of state variables
%    Nparam        total number of parameters appearing in the postulated model
%    x             aumented state vector (Nx)
%    delx          Perturbations to compute approximations of system matrices
%    u             input vector (Nu)
%    param         parameter vector (Nparam)
%    ts            time vector
%
% Outputs:
%    Cmat          Linearized observation matrix

for ix=1:Nx 
    zip1 = x(ix);
    del2 = 2*delx(ix);
   
    x(ix) = zip1 + delx(ix);
    y3   = feval(obser_eq, ts, x, u, param);

    x(ix) = zip1 - delx(ix);
    y4   = feval(obser_eq,ts, x, u, param);
   
    Cmat(:,ix) = (y3 - y4) / del2;               % Eq. (5.51)

    x(ix) = zip1;
end

return
% end of subroutine
