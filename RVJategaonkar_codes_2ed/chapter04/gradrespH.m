function [H, XGST] = gradrespH(iPar, kk, kend, Nx, Nu, paramp, par_del_iPar, dt,...
                               H, XGST, Z, Y, Uinp, obser_eq, state_eq, ts, ...
                               iArtifStab, StabMat, integMethod, bXparV)

% Compute response gradients H, i.e., dy/dTheta
%
% Chapter 4: Output Error Method
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USAA
%
% Inputs:
%    iPar          index of the free parameter being varied
%    kk            index of the data point being processed
%    kend          index of the data point at which the current time segment being
%                  processed ends
%    Nx            number of state variables
%    Nu            number of input variables
%    paramp        prturbed parameter vector
%    par_del_iPar  perturbation for the parameter being varied
%    dt            sampling time
%    H             response gradinets 
%    XGST          work space to store propagated perturbed states for 
%                  re-initialization
%    Z             measured outputs (Ndata,Ny)
%    Y             computed (model) outputs for unperturbed parameters (Ndata,Ny)
%    Uinp          measured inputs (Ndata,Nu) 
%    obser_eq      function coding the observation equations
%    state_eq      function coding the state equations
%    ts            time at data point kk
%    iArtifStab    flag for artificial stabilization
%    StabMat       artificial stabilization matrix
%    integMethod   integration method
%    bXparV
%
% Outputs:
%    H             response gradinets 
%    XGST          work space to store propagated perturbed states for 
%                  re-initialization


u1 = Uinp(kk,1:Nu)';
if  Nx > 0,
    xp = XGST(:,iPar);                 % get correct xp for continuation
else
    xp = [ ];
end

% Compute outputs, Eq. (4.11), for pertubed parameters
ys  = feval(obser_eq, ts, xp, u1, paramp, bXparV); 

% artificial stabilization
if  iArtifStab > 0 &  Nx > 0,
    zmy = Z(kk,:) - ys'; 
    xp  = xp + StabMat*zmy';           % Equation (9.37)
end

if  kk < kend  &  Nx > 0,
    u2 = Uinp(kk+1,1:Nu)';
    % Integrate perturbed state eqs., Eq. (4.10), for perturbed params
    xp = feval(integMethod, state_eq, ts, xp, dt, u1, u2, paramp, Nx, bXparV);
end

q1 = ys' - Y(kk,:);
H(:,iPar) = q1'/par_del_iPar;          % response gradients, Eq. (4.33)

if  Nx > 0,
    XGST(:,iPar) = xp;                 % store xp to re-initiatiation
end

return
%end of function