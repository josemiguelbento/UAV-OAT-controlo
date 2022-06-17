function [KGPert, gradKC] = gainmatPert(state_eq, obser_eq, Nx, Ny, Nu, Nparam,...
                                        dt, ts, param, par_del, parFlag, xt, Uinp,...
                                        RI, Kgain, Cmat)

% Compute gain matrices KGPert for perturbed parameters and gradients of KC.
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
%    Nx            number of state variables
%    Ny            number of output variables
%    Nu            number of input variables
%    Nparam        total number of parameters to be estimated 
%    dt            sampling time
%    ts            time vector
%    param         parameter vector
%    par_del       parameter perturbations
%    parFlag       flags for free and fixed parameters (=1, free, 0: fixed)
%    xt            state vector
%    Uinp          measured inputs (Ndata,Nu) 
%    RI            inverse of covariance matrix
%    Kgain         Kalman gain matrix
%    Cmat          linearized observation matrix
%
% Outputs:
%    KGPert        Kalman gain matrices for perturbed parameters
%    gradKC        gradients of KC


%-------------------------------------------------------------------------------- 
KC   = Kgain*Cmat;

iPar = 0;
% loop for the total number of parameters (free and fixed)
for ip=1:Nparam,
    
    if  parFlag(ip) > 0,               % compute Pertubed gain only for free parameters
        iPar = iPar + 1;

        % Remember original parameter value, and perturb one parameter at a time
        zz1 = param(ip);
        param(ip) = zz1 + par_del(ip);
    
        % Compute gain matrix for the perturbed parameters
        [KG, CmatP] = gainmat(state_eq, obser_eq, Nx, Ny, Nu, Nparam,...
                                        dt, ts, param, parFlag, xt, Uinp, RI);

        % Store gain matrices for perturbed parameters
        KGPert(:,:,iPar) = KG;
    
        % Compute gradient of KC-diagonal (required in the function kcle1)
        gradKC(:,iPar) = diag( (KG*CmatP - KC) ) / par_del(ip);
    
        % Restore back the parameter value
        param(ip) = zz1;
    end

end

return
% end of function
