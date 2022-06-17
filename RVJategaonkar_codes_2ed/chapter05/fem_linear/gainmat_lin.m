function [Kgain, Pcov] = gainmat_lin(Amat, Cmat, Fmat, Nx, Ny, Nu, Nparam,...
                                                 dt, param, xt, Uinp, RI)

% Solve steady state Riccati equation for P:
% AP + PA' - PC'Rinv CP/dt + FF' = 0 using Potter's method;
% and compute Kalman gain matrix
%
% Chapter 5: Filter Error Method
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA
%
% Filter error method for linear systems (ml_fem_linear)
%
% Inputs:
%    Amat          system state matrix
%    Cmat          state observation matrix
%    Fmat          process noise distribution matrix
%    Nx            number of state variables
%    Ny            number of output variables
%    Nu            number of input variables
%    Nparam        total number of parameters to be estimated 
%    dt            sampling time
%    param         parameter vector
%    xt            state vector
%    Uinp          measured inputs (Ndata,Nu) 
%    RI            inverse of covariance matrix
%
% Outputs:
%    Kgain         Kalman filter gain matrix
%    Cmat          linearized observation matrix


%-------------------------------------------------------------------------------- 
% Form the Hamiltonian matrix
FFT  = Fmat * Fmat';
CRIC = Cmat' * RI * Cmat / dt;
ham  = [Amat -FFT; -CRIC -Amat'];                          % Eq. (5.15)

% Compute eigenvalues and eigenvectors of the Hamiltonian matrix
[eigVec, eigVal] = eig(ham);

% Sort eigVal in ascending order; get indices of eigenvalues with +ve real parts
[eigValN, Is] = sort( diag( real(eigVal) ) );

% Eigenvectors corresponding to eigenvalues with positive real part
for ix=1:Nx, 
    eigVecN(:,ix) = eigVec(:,Is(Nx+ix)); 
end

% Partitioning of the matrix of eigenvectors, with eigenvectors corresponding
% to eigenvalues with positive real parts in the left partition.
X11 = eigVecN(1:Nx,1:Nx);
X21 = eigVecN(Nx+1:Nx+Nx,1:Nx);

% Solution to Riccati equation
Pcov = real(-X11 * inv(X21));                              % Eq. (5.17)

% Compute Kalman gain matrix 
Kgain = Pcov * Cmat' * RI;                                 % Eq. (5.8)

return
% end of function
