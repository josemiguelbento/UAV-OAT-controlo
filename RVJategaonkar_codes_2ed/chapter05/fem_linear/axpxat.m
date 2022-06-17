function gradP = axpxat(Nx, Nk, I2, CH, eVec, E2, E3, gradP)

% To solve the matrix (Lyapunov) equation AX + XA' = B, where A is symmetric
%
% Inputs:
% Nx             Number of state variables
% Nk             Number of parameters affecting gain matrix
% I2             Index of the parameters
% CH             = GrdA*P - P*C'*RI*GrdC*P/dt + GrdF*F', (Nx,Nx);  Eq. (5.xx)
% eVec
% E2
% E3             Inverse of eigenvectors of transformed matrix 
%
% Outputs:
% gradP(i,j,I2)  Gradient of P for the I2-th parameter; (Nx,NX,.)
%
% Chapter 5: Filter Error Method
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA
%
% Filter error method for linear systems (ml_fem_linear)

%--------------------------------------------------------------------------
% Compute inv(T) * (CH+CH') * inv(T')
E4 = (CH + CH')*E3;               % (CH+CH')*inv(T')
E4 = eVec\E4;                     % inv(T) * (CH+CH') * inv(T')      % Eq. (5.32)
%E4 = inv(eVec)*E4;               % inv(T) * (CH+CH') * inv(T')

% Solve the Lyapunov equation AX + XA' = B;
% Since A is diagonal, solution is simply Xij = bij/(aii+ajj)
for i=1:Nx, 
    for j=1:Nx, 
        E5(i,j) = E4(i,j) / (E2(i,i)+E2(j,j));                       % Eq. (5.33)
    end
end

% Gradient of P by back-transformation
E5 = eVec*E5*eVec';                                                  % Eq. (5.34)

% Load the solution in gradP for index I2:
gradP(:,:,I2) = -E5;

return
% end of axpxat

