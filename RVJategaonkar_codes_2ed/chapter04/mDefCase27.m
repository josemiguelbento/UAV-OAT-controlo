function [state_eq, obser_eq, Nx, Ny, Nu, NparSys, Nparam, NparID, Nminmax, dt, ...
             Ndata, Nzi, izhf, t, Z, Uinp, param, parFlag, param_min, param_max,...
             x0, iArtifStab, StabMat, LineSrch, parFlagX0, NX0ID, ...
                               bXpar, parFlagBX, NbX, NBXID] = mDefCase27(test_case)

% Definition of model, flight data, initial values etc. 
% test_case = 27;                        
% Attas Regression NL -- Quasi-steady Stall -- longitudinal mode only
%                 states  - -- (regression model, no state equations)
%                 outputs - V, alpha, theta, q, qdot, ax, az
%                 inputs  - de, da, dr, p, q, r, al, be, V, rho, fnl, fnr, al/aldot, Mach
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
% state_eq   = 'xdot_attas_reg';           % function for state equations  (Dummy)              
state_eq   = [];                         % function for state equations  (Dummy)              
obser_eq   = 'obs_TC27_attas_regStall';  % function for observation equations
Ny         = 3;                          % Number of observation variables
Nx         = 0;                          % Number of system states
Nu         = 14;                         % Number of input (control) variables
NparSys    = 14;                         % number of system parameters
Nparam     = NparSys;                    % Total number of system and bias parameters
dt         = 0.04;                       % sampling time
iArtifStab = 0;                          % No artificial stabilization
LineSrch   = 0;                         % Line search option (=0, No line search, 
                                        %                     =1, Line search)

disp(['Test Case = ', num2str(test_case)]);
disp('Quasi-Steady stall ATTAS; NL-Regression, longitudinal motion')

%----------------------------------------------------------------------------------------
% Load flight data for Nzi time segments to ba anylzed and concatenate 

load -ascii ..\flt_data\fAttas_qst01.asc;
load -ascii ..\flt_data\fAttas_qst02.asc;
Nzi   = 2;
data  = [fAttas_qst01; fAttas_qst02];

% Number of data points
Nts1  = size(fAttas_qst01,1);
Nts2  = size(fAttas_qst02,1);
izhf  = [Nts1; Nts1+Nts2];
Ndata = size(data,1);

% Generate new time axis
t = [0:dt:Ndata*dt-dt]';

% Observation variables ax, ay, az, p, q, r ==> CD, CY, CL, Cl, Cm, Cn
ZAccel = [data(:, 2)      data(:, 3)      data(:, 4) ...
          data(:, 7)*d2r  data(:, 8)*d2r  data(:, 9)*d2r ];

% Input variables de, da, dr, p, q, r, al, be, V, rho, fnl, fnr, al/aldot, Mach
Uinp = [data(:,22)*d2r (data(:,29)-data(:,28))*0.5*d2r  data(:,30)*d2r ...
        data(:, 7)*d2r  data(:, 8)*d2r  data(:, 9)*d2r ...
        data(:,13)*d2r  data(:,14)*d2r  data(:,15) ...
        data(:,34)      data(:,37)      data(:,38) ...
        data(:,13)*d2r  data(:,31)];

% Compute aerodynamic force and moment coefficients (for regression model only)
[Z, Uinp] = umr_reg_attas(ZAccel, Uinp, Nzi, izhf, dt, test_case);

% Initial starting values for unknown parameters (aerodynamic derivatives) 
param = [0.05;  1; ...                       % CD0, efak (efak parameter must be nonzero)
         0.25;  5;      0; ...               % CL0, CLal, CLMach
         0.22; -1.2;  -11;  -1.8; ...        % Cm0, Cmal, Cmq, Cmde
         35;    0.29;  21;   0.05;  -0.1];   % A1, AlStar, Tau2, CD_X0, CM_X0 

% Define lower and upper bounds for the parameters to be estimated
param_min(1:Nparam,1) = -Inf;          % default values for Unconstrained optimization
param_max(1:Nparam,1) =  Inf;

% Determine the number of lower and upper bounds
if isempty( find(param_min~=-Inf)  |  find(param_max~=Inf) ) ~=0 ,
   Nminmax = 0; 
else
   Nminmax = size( find ( diff( sort([find(param_min~=-Inf); find(param_max~=Inf)]) ) ), 1) + 1; 
end

% Flags for free and fixed parameters
parFlag = ones(Nparam,1);
% parFlag = [1;  1; ...
%            1;  1;  1; ...
%            1;  1;  1;  1; ...
%            1;  1;  1;  1;  1];

% Total number of free parameters
NparID = size(find(parFlag~=0),1); 

% Initial conditions
x0 = [];

% Flags for free and fixed initial conditions
parFlagX0 =[ ]; 

% Total number of free initial conditions
NX0ID = 0;


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

 

    





