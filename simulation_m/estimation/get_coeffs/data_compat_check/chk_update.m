function [nBounds, i_State, delPar, param, paramX0BX] = ...
                   chk_update(Nminmax, nBounds, Nparam, NparID, i_State, ...
                              parFlag, delPar, param, param_min, param_max, ...
                              integMethod, state_eq, obser_eq, Ndata, ...
                              Ny, Nu, Nzi, Nx, dt, times, x0, Uinp, Z, ...
                              izhf, iArtifStab, StabMat, LineSrch, ...
                              paramX0BX, parFlagX0, NbX, parFlagBX) 

% Active set strategy for bounded-variable GN method
%
% Chapter 4: Output Error Method
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA
%
% Inputs:
%    Nminmax       number of parameters fro which bounds are specified
%    nBounds       number of parameters hitting the bounds
%    Nparam        total number of parameters appearing in the postulated model
%    NparID        total number of parameters to be estimated
%    i_State       active set
%    parFlag       flags for free and fixed parameters(=1, free; 0=, fixed)
%    delPar        parameter increment (delta-Theta)
%    param         parameter vector
%    param_min     lower bounds
%    param_max     upper bounds
%    integMethod   integration method
%    state_eq      function for the state equations
%    obser_eq      function for the observation equations
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
%    LineSrch      flag for line search option in the Gauss-Newton method
%    paramX0BX     vector of system parameters and initial conditions
%    parFlagX0     flags for free and fixed initial conditions
%    NbX
%    parFlagBX
%
% Outputs:
%    nBounds       number of parameters hitting the bounds
%    i_State       active set
%    delPar        parameter update (delta-Theta) 
%    param         parameter vector


%--------------------------------------------------------------------------
TRUE   = 1;  
FALSE  = 0;
Lbound = FALSE;

% To be done only when min/max values are specified for at least one
if Nminmax ~= 0,
    
    % Set the search directions to zero for variables in the active set. delPar are
    % computed in "improv" for Npar_free; Arrange them appropriately for Nparam
    % parameters using i_State; and then fill up with  x0 and bX:
    delPar = parFillup(Nparam, Nx, Nzi, i_State, parFlag, parFlagX0, delPar, ...
                       NbX, parFlagBX);

    % Check for bounds (presently only for system parameters)
    for ip=1:Nparam,
        
        % Check whether min and max values are finite or not.
        if isfinite(param_min(ip)) ~= 0  |  isfinite(param_max(ip)) ~= 0, 

            % Check new parameter value for lower bound: 
            if param(ip)+delPar(ip) < param_min(ip), 
            
                % Set param to lower bound, the search direction delPar to zero,
                % and index i_State to -1; increment the counter nBounds
                param(ip)   = param_min(ip);
                delPar(ip)  = 0;
                i_State(ip) = -1;
                nBounds     = nBounds + 1;

            % Check new parameter value for upper bound: 
            elseif param(ip)+delPar(ip) > param_max(ip), 

                % Set param to upper bound, the search direction delPar to zero, 
                % and index i_State to one; increment nBounds by one. 
                param(ip)   = param_max(ip);
                delPar(ip)  = 0;
                i_State(ip) = 1;
                nBounds     = nBounds + 1;
            end
            
        end
        
    end  % end of for ip=1:Nparam loop

    paramX0BX(1:Nparam) = param;

    % To control line search, set Lbound if any parameter hits the bounds
    if isempty(find(i_State~=0)) == 0, Lbound = TRUE; end

end  % end of if (Nminmax ~= 0)

%--------------------------------------------------------------------------
% Line search:
% In the case of bounded-variable GN method, line search is necessary when 
% the parameters hit the bounds. This case is automatically covered through
% setting of 'Lbound'. In the case min/max values are specified (i.e. 
% Nminmax>0), but the parameters are within the permissible ranges, then 
% i_States would all be zero and accordingly Lbound will be false. In such
% a case, if necessary, line case can be optionally invoked through the flag
% 'Line_Srch'. Usually, BVGN without line search works well, because the
%  intermediate divergences are mostly eliminated, through min/max limits.

if Lbound | LineSrch ~= 0, 

    % Get starting parameter values in dummy vector, and compute cost value
    pardup = paramX0BX; 
    
    [FMIN, R, RI, Y] = costfun_oem(integMethod, state_eq, obser_eq, Ndata,...
                                   Ny, Nu, Nzi, Nx, times, x0, Uinp, Z, izhf,...
                                   iArtifStab, StabMat, Nparam, pardup, NbX); 

    % Initialize variables for line search routine
    alfa  = 1.0D0;           % initial step size
    maxFA = 10;              % maxfa maximum no. of iterations
    iFA   = 0;               % number of function calls
    epsF  = 1.0e-4;          % eps for cost function (prsenetly fixed)               
    epsX  = 1.0e-3;          % eps for variation in parameter values

    % one-dimensional search along the given direction delPar
    [pardup, iFA, FMIN] = ...
             minf_quad(FMIN, pardup, delPar, alfa, iFA, maxFA, ...
                       epsF, epsX, integMethod, state_eq, obser_eq, ...
                       Ndata, Ny, Nu, Nzi, Nx, times, x0, Uinp, Z,...
                       izhf, iArtifStab, StabMat, Nparam, NbX);
                   
    % Parameter updates (Note: minf_quad yields updated parameter vector)
    delPar = pardup - paramX0BX;

end    % end of if (Lbound)

%--------------------------------------------------------------------------
% Check for bounds once again after line search:
% Line search along the GN-directions should normally lead to small corrections,
% and in most of the cases should be within the permissible bounds. However,
% this is not guaranteed. In some cases, it is possible that the line search
%  may lead parameter values violating the bounds. The min/max values are
%  considered as hard bounds, and hence check once again.

if Nminmax ~= 0  &  Lbound, 
    
    for ip=1:Nparam,
        
        if isfinite(param_min(ip)) ~= 0  |  isfinite(param_max(ip)) ~= 0, 
            
            if param(ip)+delPar(ip) < param_min(ip),
                param(ip)   = param_min(ip);
                delPar(ip)  =  0;
                i_State(ip) = -1;
                nBounds     = nBounds + 1;
            elseif param(ip)+delPar(ip) > param_max(ip), 
                param(ip)   = param_max(ip);
                delPar(ip)  = 0;
                i_State(ip) = 1;
                nBounds     = nBounds + 1;
            end 
            
        end
        
    end  % end of ip=1:Nparam loop
    
    paramX0BX(1:Nparam) = param;
  
end  % end of if Nminmax ~= 0  &  Lbound


return
% end of function

