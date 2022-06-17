function grdK = gradK (Nx, Ny, Nparam, NK, NBET, NC, Cmat, RI, Pcov, gradP)

% Compute the gradients of the Kalman gain matrix, Eq. (5.26)
% GrdK = gradP * C' * RI + P * gradC' * RI
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
%     Nx            Number of state variables
%     Ny            Number of observation variables
%     Nparam        Number of parameters to be estimated
%     NK            Number of parameters affecting gain matrix
%     NBET          Number of parameters appearing in A, B, C, D matrices
%     NC            Number of free parameters in C-Matrix
%     Cmat          Observation matrix, (Ny,Nx) 
%     RI            Inverse of the covariance matrix of innovations, (Ny,Ny) 
%     Pcov          Covariance matrix of state prediction error, (Nx,Nx)
%     gradP         Gradient of Pcov, (Nx,Nx,Nparam) 
%
% Outputs:
%     grdK(i,j,k)   Gradient of Kalman gain matrix; (Nx,Ny,Nk)
%


%--------------------------------------------------------------------------------------
global iC  kC  jC  Cbet

if  NC ~= 0,
    
    % gradP*C*RI, (i.e. first term of Eq. 5.26)
    for IP=1:NBET,
        grdK(:,:,IP) = gradP(:,:,IP)*Cmat'*RI;
    end
    
    % P*gradC'*RI (i.e. second term of Eq. 5.26); 
    % needs to be done only for elements of C-matrix
    for kk=1:NC,
        I2 = jC(kk);
        if  I2 > 0 & I2 <= NBET,
            I1 = iC(kk);
            I3 = kC(kk);
            gradC = zeros(Ny,Nx);
            gradC(I1,I3) = 1;
            grdK(:,:,I2) = grdK(:,:,I2) + Pcov*gradC'*RI;
        end
    end
    
end

return
% end of function
