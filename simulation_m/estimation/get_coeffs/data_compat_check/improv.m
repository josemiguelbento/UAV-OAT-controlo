function [delPar, nBounds, i_State, paramX0BX] = ...
                   improv(F, G, Nparam, NparID, Nminmax, nBounds,...
                          param_min, param_max, param, i_State, parFlag,...
                          NX0ID, integMethod, state_eq, obser_eq, Ndata,...
                          Ny, Nu, Nzi, Nx, dt, times, x0, Uinp, Z,...
                          izhf, iArtifStab, StabMat, currentCost, LineSrch,...
                          paramX0BX, parFlagX0, NBXID, parFlagBX, NbX);

 % parameter update by Gauss-Newton method (unconstrained or 
% bounded-variable)
%
% Chapter 4: Output Error Method
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA
%
% Inputs:
%    F             information matrix 
%    G             gradient vector
%    Nparam        total number of parameters appearing in the postulated model
%    NparID        total number of parameters to be estimated
%    Nminmax       number of parameters fro which bounds are specified
%    nBounds       number of parameters hitting the bounds
%    param_min     lower bounds
%    param_max     upper bounds
%    param         parameter vector
%    i_State       active set
%    parFlag       flags for free and fixed parameters (=1, free; 0=, fixed)
%    NX0ID         total number of initial conditons to be estimated (free x0's)
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
%    iArtifStab    flag for artificial stabilization
%    StabMat       artificial stabilization matrix
%    currentCost   current cost function value
%    LineSrch      flag for line search option in the Gauss-Newton method
%    paramX0BX     vector of system parameters and initial conditions
%    parFlagX0    flags for free and fixed initial conditions
%    parFlagBX
%
% Outputs:
%    delPar        parameter update (delta-Theta) 
%    nBounds       number of parameters hitting the bounds
%    i_State       active set


% global dt        % required for timeDelay function (14.01.2009)

%--------------------------------------------------------------------------
if Nminmax == 0,
    
    % Unconstrained optimization
    
    % delPar = -inv(F) * G;            % using inverse of matrix
    % delPar = - F \ G;                % Using matrix division operator: 
    % Using Cholesky factorization: 
    uptF   = chol(F);                  % Upper triangular F = uptF'*uptF 
    delPar = -uptF \ (uptF'\G);        % Eq. (4.29); Delta-Theta

    % Line search option - Optional (see Chapter 4, Section X.B).
    if (LineSrch ~= 0),
        
        pardup = paramX0BX;
        % delPar are for free parameters only (NparID - nBounds); Arrange them
        % appropriately for Nparam parameters using parFlags; and then fill up 
        % with those for x0 and bX
        delParFull = parFillup(Nparam, Nx, Nzi, i_State, parFlag, parFlagX0, ...
                               delPar, NbX, parFlagBX);

        % Initialize variables for line search routine
        FMIN   = currentCost;          % current cost function value
        alfa   = 1.0D0;                % initial step size
        maxFA  = 10;                   % maxfa maximum no. of iterations
        iFA    = 0;                    % number of function calls
        epsF   = 1.0e-4;               % eps for cost function value               
        epsX   = 1.0e-3;               % eps for variation in parameter values

        % one-dimensional search along the given direction delPar
        [pardup, iFA, FMIN] = ...
             minf_quad(FMIN, pardup, delParFull, alfa, iFA, maxFA, epsF, epsX, ...
                       integMethod, state_eq, obser_eq, ...
                       Ndata, Ny, Nu, Nzi, Nx, times, x0, Uinp, Z,...
                       izhf, iArtifStab, StabMat, Nparam, NbX);
                   
        % minf_quad yields updated parameter vector; 
        % Compute parameter improvement delParFull and purged delPar for free
        % parameters (required in ml_oem / parUpdate)
        delParFull = pardup - paramX0BX;
        delPar = delParPurge(delParFull, Nparam, Nx, Nzi, i_State, parFlag, ...
                             parFlagX0, NbX, parFlagBX);

    end 

else
    
    % Constrained optimization subject to simple (lower and upper) bounds
    
    % Check optimality conditions for the variables in the active set -
    % if they are not met, drop those variables from the active set.
    [nBounds, i_State] = chk_lub_opt(Nparam, nBounds, G, i_State);
    
    % Pack the information matrix F and the gradient vector G
    i1  = find( ~i_State(find(parFlag)) );       % get the appropriate indices
    ixf = NparID;
    for iz=1:Nzi, 
        for ix=1:Nx, 
            if parFlagX0(ix,iz) > 0, 
                ixf=ixf+1; 
                i1=[i1; ixf]; 
            end; 
        end; 
    end
    for iz=1:Nzi, 
        for ix=1:NbX, 
            if parFlagBX(ix,iz) > 0, 
                ixf=ixf+1; 
                i1=[i1; ixf]; 
            end; 
        end; 
    end
    F_free = F(i1,i1);
    G_free = G(i1);

    % Compute the parameter improvement vector for free parameters
    % using Cholesky factorization: 
    uptF_free = chol(F_free);                         % Upper triangular F_free
    delPar    = -uptF_free \ (uptF_free'\G_free);     % Eq. (4.29); Delta-Theta

    % Active set strategy:
    [nBounds, i_State, delPar, param, paramX0BX] = ...
                chk_update(Nminmax, nBounds, Nparam, NparID, i_State, parFlag,...
                           delPar, param, param_min, param_max,...
                           integMethod, state_eq, obser_eq, Ndata,...
                           Ny, Nu, Nzi, Nx, dt, times, x0, Uinp, Z,...
                           izhf, iArtifStab, StabMat, LineSrch, ...
                           paramX0BX, parFlagX0, NbX, parFlagBX);

    delPar = delParPurge(delPar, Nparam, Nx, Nzi, i_State, parFlag, ...
                         parFlagX0, NbX, parFlagBX);

end
    
return       
% end of function
