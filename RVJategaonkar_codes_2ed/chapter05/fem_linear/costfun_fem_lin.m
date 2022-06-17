function [currentcost, R, RI, Y, SXtilde, SXhat, SZmY, Phi, Chi] = ...
                                   costfun_fem_lin(Amat, Bmat, Cmat, Dmat, BX, BY, ...
                                                   Ndata, Ny, Nu, Nx, dt, ...
                                                   x0, Uinp, Z, param, Kgain)

% Compute cost function for the filter error method, the covariance matrix of the
% measurement noise and its inverse, and the model outputs through state estimation.
% Simulation implies computation of state variables. 
% For linear systems it is done by state transition matrix
%
% Chapter 5: Filter Error Method
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA
%
% Inputs:
%    Amat          system state matrix
%    Bmat          state input matrix
%    Cmat          state observation matrix
%    Dmat          input matrix
%    BX            lumped bias parameters of state equations
%    BY            lumped bias parameters of output equations
%    Ndata         number of data points
%    Ny            number of output variables
%    Nu            number of input variables
%    Nx            number of state variables
%    dt            sampling time
%    x0            initial conditions (=0 for linear systems with lumped bias parameters)
%    Uinp          measured inputs (Ndata,Nu) 
%    Z             measured outputs (Ndata,Ny)
%    param         parameter vector
%    Kgain         Kalman filter gain matrix
%
% Outputs:
%    currentcost   Value of current cost function (determinant of R)
%    R             covariance matrix
%    RI            inverse of covariance matrix
%    Y             computed (model) outputs (Ndata,Ny)
%    SXtilde       array of predicted state variables (Ndata,Nx)
%    SXhat         array of corrected state variables (Ndata, Nx)
%    SZmY          array of residuals (Ndata,Ny)
%    Phi           state transiton matrix (Nx,Nx)
%    Chi           integral of state transition matrix


% State transition matrix and its integral by Taylor series expansion
% phi_expm = expm(Amat*dt)
Phi = eye(Nx);
Chi = eye(Nx)*dt;
for k=1:12,
    Phi = Phi + (Amat^k)*(dt^k)/(factorial(k));                      % Eq. (3.38)
    Chi = Chi + (Amat^k)*(dt^(k+1))/(factorial(k+1));                % Eq. (3.39)
end   

% State estimation by Kalman filter
xt = x0;
for k=1:Ndata,
    u1 = Uinp(k,1:Nu)';  
    y  = Cmat*xt + Dmat*u1 + BY;                                     % Eq. (5.6)
    Y(k,:) = y';
    SXtilde(k,:) = xt';
    
    zmy = Z(k,:) - Y(k,:); 
    xh  = xt + Kgain*zmy';                                           % Eq. (5.7)
    SZmY(k,:)  = zmy;
    SXhat(k,:) = xh';

    if  k < Ndata,
        u2   = Uinp(k+1,1:Nu)';
        uavg = (u1 + u2) / 2;
        xt   = Phi*xh + Chi*Bmat*uavg + Chi*BX;                      % Eq. (5.5)
    end
end

% estimate covariance matrix R; determinant and inverse of R
R = zeros(Ny);
for k=1:Ndata,
    delta = Z(k,:) - Y(k,:); 
    delta = delta(:);
    R     = R + delta * delta';
end
R    = diag(diag(R)/Ndata);                                          % Eq. (5.11)
detr = det(R);
RI   = inv(R);
currentcost = det(R);
%currentcost = det(R)*Ndata^size(R(:,1),1);

return
% end of function
