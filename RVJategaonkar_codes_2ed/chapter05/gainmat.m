function [Kgain, Cmat] = gainmat (state_eq, obser_eq, Nx, Ny, Nu, Nparam,...
                                  dt, ts, param, parFlag, xt, Uinp, RI)

% Solve steady state Riccati equation for P:
% AP + PA' - PC'Rinv CP/dt + FF' = 0 using Potter's method;
% and compute Kalman gain matrix
%
% Chapter 5: Filter Error Method
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USAA
%
% Inputs:
%    state_eq      function coding the state equations
%    obser_eq      function coding the observation equations
%    Nx            number of state variables
%    Ny            number of output variables
%    Nu            number of input variables
%    Nparam        total number of parameters to be estimated 
%    dt            sampling time
%    ts            time vector
%    param         parameter vector
%    parFlag       flags for free and fixed parameters (=1, free, 0: fixed)
%    xt            state vector
%    Uinp          measured inputs (Ndata,Nu) 
%    RI            inverse of covariance matrix
%
% Outputs:
%    Kgain         Kalman filter gain matrix
%    Cmat          linearized observation matrix


%-------------------------------------------------------------------------------- 
% Linearized system and observation matrices
delx = [zeros(Nx,1) + 1.0e-04]'; 
u    = Uinp(1,1:Nu);  
Amat = sysmatA(state_eq, Nx, Nparam, xt, delx, u, param, ts);        % Eq. (5.50)  
Cmat = sysmatC(obser_eq, Ny, Nx, Nparam, xt, delx, u, param, ts);    % Eq. (5.51)

% Process noise distribution matrix from unknown parameter vector
Fmat = diag([param(Nparam-Nx+1:Nparam)]);
FFT  = Fmat * Fmat';

%-------------------------------------------------------------------------------- 
% Form the Hamiltonian matrix
CRIC = Cmat' * RI * Cmat / dt;
ham  = [Amat -FFT; -CRIC -Amat'];                                    % Eq. (5.15)

% Compute eigenvalues and eigenvectors of the Hamiltonian matrix
[eigVec, eigVal] = eig(ham);

% Sort eigVal in ascending order; get indices of eigenvalues with +ve real parts
[eigValN, Is] = sort( diag( real(eigVal) ) );

% Eigenvectors corresponding to eigenvalues with positive real part
for i1=1:Nx, 
    eigVecN(:,i1) = eigVec(:,Is(Nx+i1)); 
end

% Partitioning of the matrix of eigenvectors, with eigenvectors corresponding
% to eigenvalues with positive real parts in the left partition.
E11 = eigVecN(1:Nx,1:Nx);                                            % Eq. (5.16)
E21 = eigVecN(Nx+1:Nx+Nx,1:Nx);

% Solution to Riccati equation
pcov = real(-E11 * inv(E21));                                        % Eq. (5.17)

%%%%%%% Matlab - Control Toolbox /LTI function
% % Transposed equation is solved, hence transpose of A and C necessary
% Rdt = inv(RI)*dt;
% [pcov, Ll, Gg, report] = care(Amat', Cmat', FFT, Rdt);

%-------------------------------------------------------------------------------- 
% Compute Kalman gain matrix 
Kgain = pcov * Cmat' * RI;                                           % Eq. (5.48)

return
% end of function
