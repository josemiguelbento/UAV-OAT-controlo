function [F, G] = gradFG(Ny, Nparam, NparID, Ndata, Nu, Nx,...
                         dt, Z, Y, RI, param, par_del, parFlag, state_eq, Uinp, obser_eq,...
                         times, x0, Kgain, KgainPert)

% compute the information matrix (i.e, matrix of of second gradients) F 
% and the gradient vector G:
%
% Chapter 5: Filter Error Method
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA
%
% Inputs:
%    Ny            number of output variables
%    Nparam        total number of parameters appearing in the postulated model
%    NparID        number of unknown parameters being estimated
%    Ndata         number of data points
%    Nu            number of input variables
%    Nx            number of state variables
%    dt            sampling time
%    Z             measured outputs (Ndata,Ny)
%    Y             computed (model) outputs for unperturbed parameters (Ndata,Ny)
%    RI            inverse of covariance matrix
%    param         parameter vector
%    par_del       parameter perturbations for numerical approximation of response gradients
%    parFlag       flags for free and fixed parameters (=1, free parameter, 0: fixed)
%    state_eq      function coding the state equations
%    Uinp          measured inputs (Ndata,Nu) 
%    obser_eq      function coding the observation equations
%    times         time vector
%    x0            initial conditions
%    Kgain         Kalman filter gain matrix
%    KGPert        Kalman gain matrices for perturbed parameters
%
% Outputs:
%    F             information matrix 
%    G             gradient vector 


%--------------------------------------------------------------------------------------
% Simulation for nominal parameter values:
% Array Y contains system responses for unperturbed parameters 

% Create cell array for perturbed responses for NparID parameters
YP = cell(NparID, 1);

% generate perturbed parameter simulations and store in cell array "YP"
iPar = 0;
for ip=1:Nparam,
    
    if  parFlag(ip) > 0,               % compute Pertubed responses only for free parameters
        iPar = iPar + 1;

        paramp    = param;
        paramp(ip) = paramp(ip) + par_del(ip);
        xp = x0;
    
        for kk=1:Ndata,
            u1 = Uinp(kk,1:Nu)';  
            ys = feval(obser_eq, times, xp, u1, paramp);             % Eq. (5.54)
            ypk(kk,:) = ys'; 

            zmy = Z(kk,:) - ypk(kk,:);
            xh  = xp + KgainPert(:,:,iPar) * zmy';                   % Eq. (5.55)

            if  kk < Ndata,
                u2 = Uinp(kk+1,1:Nu)';
                xp = ruku4(state_eq,times,xh,dt,u1,u2,paramp,Nx);    % Eq. (5.53)
            end
        end
    
        YP{iPar} = struct('time', times, 'yps', ypk);  
    end
    
end;

%--------------------------------------------------------------------------------------
% Initialize F, G and Q to zero
F = zeros(NparID);
G = zeros(NparID, 1);
Q = zeros(Ny, NparID);

% Compute F and G
for kk=1:length(times),
    
    iPar = 0;
    for ip=1:Nparam,
        if  parFlag(ip) > 0,                % compute for free parameters only
            iPar = iPar + 1;
            q    = YP{iPar}.yps(kk,:) - Y(kk,:);
            Q(:,iPar) = q'/par_del(ip);
        end
    end

    zmy = Z(kk,:) - Y(kk,:); 
    zmy = zmy(:);
    F   = F + Q' * RI * Q;                  % Eq. (5.59)
    G   = G - Q' * RI * zmy;                % Eq. (5.60)
    
end

return
% end of function
