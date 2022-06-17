function [currentcost, R, RI, Y] = costfun_fem (state_eq, obser_eq, Ndata, Ny, Nu, Nx,...
                                                dt, times, x0, Uinp, Z, param, Kgain)

% Compute cost function for the filter error method, the covariance matrix of the
% measurement noise and its inverse, and the model outputs through state estimation.
% Simulation implies computation of state variables by numerical integration.
%
% Chapter 5: Filter Error Method
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA
%
% Inputs:
%    state_eq      function coding the state equations
%    obser_eq      function coding the observation equations
%    Ndata         number of data points
%    Ny            number of output variables
%    Nu            number of input variables
%    Nx            number of state variables
%    dt            sampling time
%    times         time vector
%    x0            initial conditions
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


% perform simulation for the current parameter values
xt = x0;
for kk=1:Ndata,
    u1 = Uinp(kk,1:Nu)';  
    yt = feval(obser_eq, times, xt, u1, param);       % output variables, Eq. (5.46)
    Y(kk,:) = yt';
    
    zmy = Z(kk,:)-Y(kk,:); 
    xh  = xt + Kgain * zmy';                          % corrected states, Eq. (5.47)

    if  kk < Ndata,
        u2 = Uinp(kk+1,1:Nu)';
        xt = ruku4(state_eq, times, xh, dt, u1, u2, param, Nx); % predicted states by
    end                                                         % integration of Eq. (5.45)
end

%--------------------------------------------------------------------------
% estimate covariance matrix R; determinant and inverse of R
R = zeros(Ny);
for kk=1:Ndata,
    delta = Z(kk,:) - Y(kk,:); 
    delta = delta(:);
    R     = R + delta * delta';        % Eq. (5.11) or (5.40)
end;

% determinant and inverse of R
R    = diag(diag(R)/Ndata);            % covariance matrix R, Eq. (4.15)
detr = det(R);                         % determinant of R
RI   = inv(R);                         % Inverse of R
currentcost = det(R);

return
% end of function
