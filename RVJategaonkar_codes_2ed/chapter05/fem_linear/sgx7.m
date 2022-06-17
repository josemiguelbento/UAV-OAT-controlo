function gradX = sgx7(Nparam, NBET, gradX, Kgain, gradY, gradK, zmy)

% Compute the state sensitivity matrix d(xhat)/d(theta); equation (5.25)
%
% Chapter 5: Filter Error Method
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA
%
% Inputs:
%     Nparam      Total number of unknown parameters
%     NBET        Number of unknown parameters
%     gradX       Gradient of state vector d(xtilde)/d(theta), (Nx,Nparam)
%     Kgain       Kalman gain matrix, (Nx,Ny)
%     gradY       Sensitivity matrix d(ytilde)/d(theta), (Ny,Nparam)
%     gradK       Gradient of gain matrix 
%     zmy         Residuals (Ny)
%
% Outputs:
%     gradX       Gradient of state vector d(xhat)/d(theta), (Nx,Nparam)
%


% Compute the state sensitivity matrix d(xhat)/d(theta); equation (5.25)
gradX = gradX - Kgain*gradY;

for ip=1:NBET,
    gradX(:,ip) = gradX(:,ip) + gradK(:,:,ip)*zmy';  
end

return
