function iError = mDefCHK_fem(test_case, Nx, Ny, Nu, NparSys, Nparam, NparID, ...
                                     param, parFlag, x0, iSD, SDyError)

% Check model defined in mDefCase** 
%
% Chapter 5: Filter Error Method
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA
%
% Inputs:
%    test_case     test case number
%    Nx            number of state variables
%    Ny            number of output variables
%    Nu            number of input variables
%    NparSys       number of system parameters
%    Nparam        total number of parameters appearing in the postulated model
%    NparID        number of unknown parameters being estimated
%    param         parameter vector (Nparam)
%    parFlag       flags for free and fixed parameters (=1, free parameter, 0: fixed)
%    x0            initial conditions
%    iSD           initial R option (default; 0)
%    SDyError      standard-deviations of output errors 
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

if size(x0,1) ~= Nx
    disp('The number intial conditons x0 is not Nx.')
    iError = 1;
end

if iSD ~= 0,
    if size(SDyError,1) ~= Nx,
        disp('The standard-deviations of output errors SDyError is not Ny.')
        iError = 1;
    end
end

if iError ~= 0,
    disp('Error termination')
end

return
% end of function
