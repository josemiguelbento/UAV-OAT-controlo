function [state_eq, obser_eq, Nx, Ny, Nu, NparSys, Nparam, NparID, Nxp, dt, Ndata,...
          t, Z, Uinp, param, parFlag, xa0, delxa, rr, qq, pa0, parOEM] = mDefCase03(test_case)

% Chapter 7: Recursive Parameter Estimation 
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% by Ravindra V. Jategaonkar
% published by AIAA, Reston, VA 20191, USA
%
% Definition of model, flight data, initial values etc. 
% test_case = 3 -- Lateral-directional motion n=2, m=2, p=3, ATTAS Aircraft
%                 states  - p, r
%                 outputs - p, r
%                 inputs  - da, dr  
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
%    Nxp          total number of states (=system states + parameters, i.e. Nx + NparID)
%    dt           sampling time
%    Ndata        total number of data points for Nzi time segments
%    t            time vector
%    Z            observation variables: Data array of measured outputs (Ndata,Ny)
%    Uinp         input variables: Data array of measured input (Ndata,Nu)
%    param        initial starting values for unknown parameters (aerodynamic derivatives) 
%    parFlag      flags for free and fixed parameters
%    xa0          starting values for the augmented state vector (system states + parameters)
%    delxa        perturbations to compute approximations of system matrices 
%    rr           measurement noise covariance matrix - R0(Ny): only diagonal terms
%    qq           process noise covariance matrix - diagonal qq(Nxp).
%                 (For the chioce of qq, see the Chapetr7 and README.txt)
%    pa0          initial state propagation error covariance matrix - diagonal pcov(Nxp): 
%    parOEM       estimates obtained from OEM method (only for plot purposes)


% Constants
d2r   = pi/180;
r2d   = 180/pi;

%----------------------------------------------------------------------------------------
% Model definition
state_eq = 'xdot_TC03_lat_pr';     % Function for state equations       
obser_eq = 'obs_TC03_lat_pr';      % Function for observation equations
Nx       = 2;                      % Number of system states
Ny       = 2;                      % Number of observation variables
Nu       = 3;                      % Number of input (control) variables
NparSys  = 12;                     % Number of system parameters
Nparam   = NparSys;                % Total number of parameters to be estimated
dt       = 0.04;                   % Sampling time

disp(['Test Case = ', num2str(test_case)]);
disp('Lateral-directional motion - ATTAS: Nx=2, Ny=2, Nu=3')

%----------------------------------------------------------------------------------------
% Load flight data
load ..\flt_data\fAttasAilRud1;
load ..\flt_data\fAttasAilRud2;
data = [fAttasAilRud1; fAttasAilRud2];

% Number of data points
Ndata = size(data,1);

% Generate new time axis
t = [0:dt:Ndata*dt - dt]';

% Observation variables p, r
Z = [data(:,7)*d2r data(:,9)*d2r]; 

% Input variables dela, delr, beta 
Uinp = [(data(:,29)-data(:,28))*0.5*d2r  data(:,30)*d2r  data(:,14)*d2r ];
    
% Initial starting values for unknown parameters (aerodynamic parameters):
% Lp, Lr, Ldla, Ldlr, Lbeta, L0, Np, Nr, Ndla, Ndlr, Nbeta, N0
param = [-3.53744e+00  6.75534e-01 -4.93279e+00  0.73334e+00 -4.34076e+00  6.50204e-03...
         -0.86939e-01 -1.69526e-01 -1.92049e-01 -0.74855e+00  2.05155e+00  1.98767e-02]';

% Flag for free and fixed parameters
parFlag = [1;  1;  1;  1;  1;  1;...
           1;  1;  1;  1;  1;  1];
% Number of free parameters (to be estimated)
NparID = size(find(parFlag~=0),1);
% Total number of states (system states +  free parameters)
Nxp = Nx + NparID;

% Initial conditions   
x0   = [Z(1,1) Z(1,2)]';

% Augmented state vector:
xa0  = [x0; param(find(parFlag~=0))];

% Perturbations to compute approximations of system matrices
delxa = [zeros(Nxp,1)+1.0e-04]; 

% Measurement noise covariance matrix - R0(Ny): only diagonal terms
rr   = [1.36843164e-05 1.05365580e-06]';
     
% Process noise covariance matrix - Only diagonal terms
qq(1:Nx,1)     = 1.0e-7;               % for system states; 
qq(Nx+1:Nxp,1) = [zeros(NparID,1)];    % for system parameters
    
% Initial State propagation error covariance matrix - pcov(Nxp): Only diagonal terms
% pa0   = [zeros(Nxp,1)+1.0e+01]; 
pa0(1:Nx,1)     = 1.0e+1;     % p0 for system states
pa0(Nx+1:Nxp,1) = 1.0e+1;     % p0 for parameters
    
% Reference parameter values from ml_oem for plot --
% (generated by running /FVSysID/chapter04/ml_oem for test_case=3):
parOEM = [-2.06748  1.02929 -6.30585  1.1452 -3.84437  0.013848...
          -0.18385 -0.48560 -0.39121 -1.7609  3.03138  0.034585];

  return
% end of function
