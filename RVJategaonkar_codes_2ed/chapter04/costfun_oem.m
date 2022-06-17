function [currentcost, R, RI, Y] = costfun_oem (integMethod, state_eq, obser_eq, Ndata,...
                                                Ny, Nu, Nzi, Nx, times, x0, Uinp, Z,...
                                                izhf, iArtifStab, StabMat,...
                                                Nparam, paramX0BX, NbX) 
                                            
% Compute cost function for the output error method, the covariance matrix and
% its inverse, and the model outputs through simulation.
% Simulation implies computation of state variables by numerical integration.
%
% Chapter 4: Output Error Method
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA
%
% Inputs:
%    integMethod   integration method
%    state_eq      function coding the state equations
%    obser_eq      function coding the observation equations
%    Ndata         number of data points
%    Ny            number of output variables
%    Nu            number of input variables
%    Nzi           number of time segments being analyzed simultaneously
%    Nx            number of state variables
%    dt            sampling time
%    times         time vector
%    x0            initial conditions
%    Uinp          measured inputs (Ndata,Nu) 
%    Z             measured outputs (Ndata,Ny)
%    izhf          Cumulative index at which the concatenated time segments end
%    param         vector of system parameters
%    paramX0       vector of system parameters and initial conditons
%    iArtifStab    flag for artificial stabilization
%    StabMat       artificial stabilization matrix
%    Nparam        total number of parameters appearing in the postulated model
%    paramX0       vector of system parameters and initial conditions
%    NbX
%
% Outputs:
%    currentcost   Value of current cost function (determinant of R)
%    R             covariance matrix
%    RI            inverse of covariance matrix
%    Y             computed (model) outputs (Ndata,Ny)

%--------------------------------------------------------------------------

global kk  kzi  LF         % temp for tc05 model; reqd for timeDelay (22.01.2009)
global iPar  ts  dt        % required for timeDelay function (14.01.2009)
global rk_IntStp  tCur     % from integration functions (ruku*)

% Decompose paramX0 into param and x0
[param, x0, bXpar] = parDecomp(Nparam, Nx, Nzi, NbX, paramX0BX);

iPar = 0;                              % for unperturbed parameters iPar=0

LF = 1;                                % Starting index of 1st time segment
kzi = 0;
kk  = 1;

while kzi < Nzi;                       % Loop for Nzi time segments
    kzi  = kzi + 1;
    kend = izhf(kzi);
    if kzi > 1, LF = izhf(kzi-1) + 1; end   % Starting data-point index of the 
                                            % current time segment 
    
    if isempty(x0),
        x = x0;
    else
        x = x0(:,kzi);                 % get initial conditions for kzi-th segment 
    end                                
    
        if isempty(bXpar),
        bXparV = bXpar;
    else
        bXparV = bXpar(:,kzi);         % get bias parameters bX for kzi-th segment
    end                                

    while kk <= kend,                  % Loop for data points of kzi-th time segment
        ts   = times(kk);
        tCur =  ts;
        rk_IntStp = false;
      
        u1 = Uinp(kk,1:Nu)';
        y  = feval(obser_eq, ts, x, u1, param, bXparV);    % compute output variables, Eq. (4.11)
        Y(kk,:) = y';
    
        % artificial stabilization
        if  iArtifStab > 0,
            zmy = Z(kk,:) - y'; 
            x   = x + StabMat*zmy';    % Equation (9.37)
        end
    
        if  kk < kend  &  Nx > 0,
            u2 = Uinp(kk+1,1:Nu)';
            % Numerical integration of state equations, Eq. (4.10)
            x  = feval(integMethod, state_eq, ts, x, dt, u1, u2, param, Nx, bXparV);
        end
        kk = kk + 1;
        
    end                                % end of KK-loop for data points of kzi-th segment
end                                    % end of Nzi-loop for time segments

%--------------------------------------------------------------------------
% estimate covariance matrix R
R = zeros(Ny,Ny);
for kk=1:Ndata,
    delta = Z(kk,:) - Y(kk,:); 
    delta = delta(:);
    R     = R + delta * delta';
end;
% % Instead of foregoing kk-loop over 1:Ndata, follwoing simple statement can be used
% R = R + (Z - Y)'*(Z - Y);

% determinant and inverse of R
R    = diag(diag(R))/Ndata;            % covariance matrix R, Eq. (4.15)
detr = det(R);                         % determinant of R
RI   = inv(R);                         % Inverse of R
currentcost = detr;                    % cost function, Eq. (4.17)

return
% end of function
