function iError = mDefCHK_oem(Nx, Ny, Nu, NparSys, Nparam, NparID, Nzi, Nminmax, iOptim,...
                                     param, parFlag, param_min, param_max, x0, iArtifStab, StabMat)

% Check model defined in mDefCase** 
%
% Chapter 4: Output Error Method
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA
%
% Inputs:
%    Nx            number of state variables
%    Ny            number of output variables
%    Nu            number of input variables
%    NparSys       number of system parameters
%    Nparam        total number of parameters appearing in the postulated model
%    NparID        number of unknown parameters being estimated
%    Nzi           number of time segments being analyzed simultaneously
%    Nminmax
%    iOptim
%    param         parameter vector (Nparam)
%    parFlag       flags for free and fixed parameters (=1, free parameter, 0: fixed)
%    param_min
%    param_max
%    x0            Initial conditions
%    iArtifStab    flag for artificial stabilization
%    StabMat       artificial stabilization matrix
%
% Outputs:
%   iError         Error flag

%----------------------------------------------------------------------------------------
iError = 0;

if Nparam < NparSys,
    disp('Wrong specification of Nparam or NparSys: Nparam less than NparSys?')
    iError = 1;
end

if size(param,1) ~= Nparam,
    disp('The number of parameter values (i.e size of param) and Nparam do not match.')
    iError = 1;
end

if size(param,1) ~= size(parFlag,1),
    disp('The number of parameter values (param) and parameter flags (parFlag) do not match.')
    iError = 1;
end

if size(param_min) ~= Nparam  |  size(param_max) ~= Nparam, 
    disp('The number of lower or upper bounds (param_min or param_max) and Nparam do not match.')
    iError = 1;
end

if sum ( find(param < param_min  |  param > param_max) ),
    disp('The initial parameter values (param) are not within the specified lower or upper bounds Param_min/max.')
    iError = 1;
end

if isempty( find(param_min~=-Inf)  |  find(param_max~=Inf) ) ==0  &  iOptim ~= 1,
    disp(' ')
    disp('Inadmissible combination of the optimization method and an option of parameter bounds.')
    disp('Lower and upper bounds have been specified for the parameters.')
    disp('iOptim is set to 2, selecting Levenberg-Marquardt optimization method.')
    disp('The present software does not cater to this combination.')
    disp('Constrained optimization subject to lower and upper bounds is possible only with the')
    disp('Gauss-Newton optimization method.')
    disp(' ')
    disp('To apply bounded-variable Gauss-Newton method, set iOptim = 1 in the main program ml_oem and also')
    disp('define the lower and upper bounds on the parameters in the model definition function mDefCasexx.m')
    iError = 1;
end

if isempty(x0) == 0,         % only if x0 is not empty (to cover LS test cases)
    if size(x0,1) ~= Nx
        disp('The number intial conditons x0 is not Nx.')
        iError = 1;
    end

    if size(x0,2) ~= Nzi
        disp(['Number of time segments being analyzed simultaneously Nzi =' num2str(Nzi)])
        disp('The number intial conditons x0 are not specified for Nzi time segments.')
        iError = 1;
    end
end

if iArtifStab ~= 0,
    if size(StabMat,1) ~= Nx  |  size(StabMat,2) ~= Ny,
        disp('The artificial stabilization matrix StabMat is not (Nx,Ny).')
        iError = 1;
    end
end

if iError ~= 0,
    disp('Error termination')
end

return
% end of function
