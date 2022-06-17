function [state_eq, obser_eq, Nx, Ny, Nu, NparSys, Nparam, NparID, Nminmax, dt, ...
             Ndata, Nzi, izhf, t, Z, Uinp, param, parFlag, param_min, param_max,...
             x0, iArtifStab, StabMat, LineSrch, parFlagX0, NX0ID, ...
                               bXpar, parFlagBX, NbX, NBXID] = mDefCase06(test_case)

% Definition of model, flight data, initial values etc. 
% test_case = 6 -- Unstable aircraft, short period, OEM
% variables:       states  - w, q
%                  outputs - az, w, q
%                  inputs  - de, w, q
%
% LS/OEM RegStartup method for unstable aircraft - Short period model
% test_case=6 is similar to test_case=8. The changes are in the state and
% observation equations. Measured values of w and q are used as u(2) and u(3).
%
% Chapter 4: Output Error Method
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA
%
% Inputs
%    test_case    test case number
%
% Outputs
%    state_eq     function to code right hand sides of state equations       
%    obser_eq     function to code right hand sides of observation equations
%    Nx           number of states 
%    Ny           number of observation variables
%    Nu           number of input (control) variables
%    NparSys      number of system parameters
%    Nparam       total number of system and bias parameters
%    NparID       total number of parameters to be estimated (free parameters)
%    Nminmax      number of lower and upper bounds
%    dt           sampling time
%    Ndata        total number of data points for Nzi time segments
%    Nzi          number of time segments (maneuvers) to be analyzed simultaneously
%    izhf         cumulative index at which the maneuvers end when concatenated
%    t            time vector
%    Z            observation variables: Data array of measured outputs (Ndata,Ny)
%    Uinp         input variables: Data array of measured input (Ndata,Nu)
%    param        initial starting values for unknown parameters (aerodynamic derivatives) 
%    parFlag      flags for free and fixed parameters
%    param_min    lower bounds on parameters
%    param_max    upper bounds on parameters
%    x0           initial conditions on state variables
%    iArtifStab   integer flag to invoke artificial stabilization
%                 = 0: No artificial stabilization
%                 > 0: Artificial stabilization (needs definition of StabMat)
%    StabMat      artificial stabilization matrix; (Nx,Ny); nonzero only for iArtifStab>0
%    LineSrch     flag for line search option in the Gauss-Newton method
%    parFlagX0    flags for free and fixed initial conditions
%    NX0ID        total number of initial conditons to be estimated (free x0's)
%    bXpar        bias parameters for each time segment
%    parFlagBX    flags for free and fixed bXpar
%    NbX          number of bias parameter per time segment (includes both fixed and free)
%    NBXID        total number of free (to be estimated) bias parameters
%

% Constants
d2r = pi/180;
r2d = 180/pi;

%----------------------------------------------------------------------------------------
% Model definition
state_eq   = 'xdot_TC06_uAC_RegSt';     % function for state equations       
obser_eq   = 'obs_TC06_uAC_RegSt';      % function for observation equations
Nx         = 2;                         % Number of states 
Ny         = 3;                         % Number of observation variables
Nu         = 3;                         % Number of input (control) variables
NparSys    = 6;                         % number of system parameters
Nparam     = NparSys;                   % Total number of system and bias parameters
dt         = 0.05;                      % sampling time
iArtifStab = 0;                         % No artificial stabilization
LineSrch   = 0;                         % Line search option (=0, No line search, 
                                        %                     =1, Line search)

disp(['Test Case = ', num2str(test_case)]);
disp('Unstable aircraft, short period, LS/OEM - Regression Startup')

%----------------------------------------------------------------------------------------
% Load flight data for Nzi time segments to be analyzed and concatenate 
load -ascii ..\flt_data\unStabAC_sim.asc;
Nzi  = 1;
data = unStabAC_sim;     

% Number of data points
Ndata = size(data,1);
izhf  = Ndata;

% Generate new time axis
t = [0:dt:Ndata*dt-dt]';

% Observation variables az, w q
Z = [data(:,6) data(:,3) data(:,4)];

% Input variables de, w, q
Uinp = [data(:,5)  data(:,3)  data(:,4)];

% Initial starting values for unknown parameters (aerodynamic derivatives) 
param = [-1.22871D+00; -1.47680;     -4.20491D+00; ... 
          1.16197D-01; -2.70670D+00; -1.87718D+01 ];
     
% Define lower and upper bounds for the parameters to be estimated
param_min(1:Nparam,1) = -Inf;          % default values for Unconstrained optimization
param_max(1:Nparam,1) =  Inf;

% Determine the number of lower and upper bounds
if isempty( find(param_min~=-Inf)  |  find(param_max~=Inf) ) ~=0 ,
   Nminmax = 0; 
else
   Nminmax = size( find ( diff( sort([find(param_min~=-Inf); find(param_max~=Inf)]) ) ), 1) + 1; 
end

% Flag for free and fixed parameters
parFlag = [1;  0;  1; ...
           1;  1;  1];

% Total number of free parameters
NparID = size(find(parFlag~=0),1); 

% Initial conditions w0, q0
x0 = [0.0; 0.0];

% Flags for free and fixed initial conditions
parFlagX0(:,1) =[0;  0]; 
if Nzi > 1 
    for iz=2:Nzi, parFlagX0(:,iz) = parFlagX0(:,1); end
end

% Total number of free initial conditions
NX0ID = size(find(parFlagX0~=0),1);


% Bias parameters bXpar and Flags for free and fixed bXpar
bXpar     = [ ];
parFlagBX = [ ];

% Number of bias parameter per time segment (includes both fixed and free)
% and the total number of free bias parameters
if isempty( bXpar ) ~=0 ,
    NbX   = 0; 
    NBXID = 0;
else
    NbX   = size(bXpar(:,1),1);
    NBXID = size(find(parFlagBX~=0),1);
end


% Artificial stabilization matrix
StabMat = zeros(Nx,Ny);               



 




