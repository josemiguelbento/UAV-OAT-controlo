function [param, x0, bXpar] = parDecomp(Nparam, Nx, Nzi, NbX, paramX0BX)

% Decompose paramX0 into param, x0, and bXpar
%
% Chapter 4: Output Error Method
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA
%
% Inputs:
%    Nparam        total number of system parameters in the postulated model
%    Nx            number of state variables
%    Nzi           number of time segments being analyzed simultaneously
%    NbX
%    paramX0BX     vector of system parameters, initial conditons and bias parameters
%
% Outputs:
%    param         vector of system parameters
%    x0            initial conditions
%    bXpar         bias parameters


% System Parameters param
param = paramX0BX(1:Nparam);

% Initial conditions x0:
for kzi=1:Nzi,
    x0(:,kzi) = paramX0BX(Nparam+(kzi-1)*Nx+1:Nparam+kzi*Nx);
end

% Bias parameters bXpar:
NparNzi = Nparam+Nzi*Nx;
for kzi=1:Nzi,
    bXpar(:,kzi) = paramX0BX(NparNzi+(kzi-1)*NbX+1:NparNzi+kzi*NbX);
end

return
% end of function
