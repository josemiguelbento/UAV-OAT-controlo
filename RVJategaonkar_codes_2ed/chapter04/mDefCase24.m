function [state_eq, obser_eq, Nx, Ny, Nu, NparSys, Nparam, NparID, Nminmax, dt, ...
             Ndata, Nzi, izhf, t, Z, Uinp, param, parFlag, param_min, param_max,...
             x0, iArtifStab, StabMat, LineSrch, parFlagX0, NX0ID, ...
                               bXpar, parFlagBX, NbX, NBXID] = mDefCase24(test_case)

% Definition of model, flight data, initial values etc. 
% test_case = 24 -- Estimation of aerodynamic parameters by least squares method
%                   Nonlinear model and multiple time segments (NZI=3),
%                   (same as test_case=23, except of CD modeling)
%                   longitudinal and lateral-directional motion
%                   states  - --
%                   outputs - CD, CL, Cm, CY, Cl, Cn (Aero coefficients)
%                   inputs  - de, da, dr, p, q, r, al, be, V, rho, fnl, fnr
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
d2r  = pi/180;
r2d  = 180/pi;
ft2m = 0.3048;

%----------------------------------------------------------------------------------------
% Model definition
% state_eq   = 'xdot_attas_reg';           % function for state equations       
state_eq   = [];                         % function for state equations       
obser_eq   = 'obs_TC24_attas_regNL';     % function for observation equations
Nx         = 0;                          % Number of states 
Ny         = 6;                          % Number of observation variables
Nu         = 14;                         % Number of input (control) variables
NparSys    = 20;                         % number of system parameters
Nparam     = NparSys;                    % Total number of system and bias parameters
dt         = 0.04;                       % sampling time
iArtifStab = 0;                          % No artificial stabilization
LineSrch   = 0;                         % Line search option (=0, No line search, 
                                        %                     =1, Line search)

disp(['Test Case = ', num2str(test_case)]);
disp('Aerodynamic model applying NL-Regression, ATTAS, longituidnal and lateral motion')

%----------------------------------------------------------------------------------------
% Load flight data for Nzi time segments to be analyzed and concatenate 
load ..\flt_data\fAttasElv1;
load ..\flt_data\fAttasAil1;
load ..\flt_data\fAttasRud1;
Nzi   = 3;
data  = [fAttasElv1; fAttasAil1; fAttasRud1];

% Number of data points
Nts1  = size(fAttasElv1,1);
Nts2  = size(fAttasAil1,1);
Nts3  = size(fAttasRud1,1);
izhf  = [Nts1; Nts1+Nts2; Nts1+Nts2+Nts3];
Ndata = size(data,1);

% Generate new time axis
t = [0:dt:Ndata*dt-dt]';

% Observation variables ax, ay, az, p, q, r ==> CD, CY, CL, Cl, Cm, Cn
ZAccel = [data(:, 2)       data(:, 3)       data(:, 4)...
          data(:, 7)*d2r   data(:, 8)*d2r   data(:, 9)*d2r];

% % Generate pdot, qdot and rdot by numerical differentiation of p, q, r
% [pDot, qDot, rDot] = ndiff_pqr(Nzi, izhf, dt, data(:,7), data(:,8), data(:,9));

% Input variables de, da, dr, p, q, r, al, be, V, rho, fnl, fnr, al/aldot, Mach
Uinp = [data(:,22)*d2r (data(:,29)-data(:,28))*0.5*d2r  data(:,30)*d2r...
        data(:, 7)*d2r  data(:, 8)*d2r  data(:, 9)*d2r...
        data(:,13)*d2r  data(:,14)*d2r  data(:,15)...
        data(:,34)      data(:,37)      data(:,38)...
        data(:,13)*d2r  data(:,31)];

% Data preprocessing to compute aerodynamic force and moment coefficients:
[Z, Uinp] = umr_reg_attas(ZAccel, Uinp, Nzi, izhf, dt, test_case);

% Initial starting values for unknown parameters (aerodynamic derivatives) 
param = zeros(Nparam,1);
% param(2) = [1];              % efak (efak parameter must be nonzero to avoid divide by zero)
% param(6) = [5];              % CLal
param(1:2) = [0.03 1];         % CD0, efak (efak parameter must be nonzero)
param(5:6) = [0.2 5];          % CL0, CLal

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
parFlag = ones(Nparam,1);

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
