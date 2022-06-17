function [grd2J, grd1J] = gradxy_lin(Nx, Nu, Ny, Nparam, NBET, Ndata, ...
                                     Uinp, SXtilde, SXhat, SZmY, Cmat, Kgain, ...
                                     gradK, RI, Phi, Chi)

% Compute the gradients of the state variables gradXT(i,j) = dxtilde(i)/dtheta(j)
%
% Chapter 5: Filter Error Method
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA
%
% Filter error method for linear systems (ml_fem_linear)
%
% Inputs
%     Nx          Number of state variables
%     Nu          Number of input variables
%     Ny          Number of observation variables
%     Nparam      Total number of parameters
%     NBET        Number of unknown derivatives (parameters appearing in A, B, C, D matrices)
%     Ndata       Number of data points
%     Uinp        Array of inputs (data matrix)
%     SXtilde     Array of predicted state variables (Ndata,Nx) 
%     SXhat       Array of corrected state variables (Ndata,Nx)
%     SZmy        Array of residuals (Ndata,Ny)
%     Cmat        State observation matrix
%     Kgain       Kalman gain matrix
%     gradK       Gradient of K
%     RI          Inverse of measurement noise covariance matrix
%     Phi         State transition matrix
%     Chi         Integral of Phi
%
% Outputs
%     grd2J       Second gradient of cost function (information matrix)
%     grd1J       First gradient of cost function
%


%--------------------------------------------------------------------------------------
grd1J = zeros(Nparam,1);
grd2J(1:Nparam,1:Nparam) = 0;
kk  = 1;
kzi = 1;
nzi = 1;

while kzi <= nzi;
    k1  = Ndata;
    gradX(1:Nx,1:Nparam) = 0;
    
    xh  = SXhat(kk,:);
    xt  = SXtilde(kk,:);
    zmy = SZmY(kk,:);
    u1  = Uinp(kk,1:Nu);  
    
    [gradY, grd1J, grd2J] = gradFG_lin(Ny, Nx, Nu, Nparam, Ndata,  nzi, kzi, kk, ...
                                       xh, xt, u1, Uinp, Cmat, Kgain, Phi, Chi, ...
                                       gradX, gradK, RI, zmy, grd1J, grd2J);

    gradX = sgx7(Nparam, NBET, gradX, Kgain, gradY, gradK, zmy);

    
    kk = kk + 1;

    while kk <= k1;

        x12 = ( SXhat(kk-1,:) + SXtilde(kk,:) )/2;              % average
        xt  = SXtilde(kk,:);
        u12 = ( Uinp(kk-1,1:Nu) + Uinp(kk,1:Nu) ) / 2;          % average of u(k+1) and u(k)
        u1  = Uinp(kk,1:Nu);
        zmy = SZmY(kk,:);
        
        % Compute gradient dXtilde/dTheta, Eq. (19) of FB 87-20
        gradX = sgl7(Nx, x12, u12, Phi, Chi, gradX);

        % Compute gradient dYtilde/dTheta, Eq. (20) of FB 87-20
        [gradY, grd1J, grd2J] = gradFG_lin(Ny, Nx, Nu, Nparam, Ndata,  nzi, kzi, kk,...
                                           xh, xt, u1, Uinp, Cmat, Kgain, Phi, Chi, ...
                                           gradX, gradK, RI, zmy, grd1J, grd2J);

        gradX = sgx7(Nparam, NBET, gradX, Kgain, gradY, gradK, zmy);
                
        kk = kk + 1;
        
    end

    kzi = kzi + 1;
end
    
return
