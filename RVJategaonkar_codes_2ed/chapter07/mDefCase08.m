function [state_eq, obser_eq, Nx, Ny, Nu, NparSys, Nparam, NparID, Nxp, dt, Ndata,...
          t, Z, Uinp, param, parFlag, xa0, delxa, rr, qq, pa0, parOEM] = mDefCase08(test_case)

% Chapter 7: Recursive Parameter Estimation 
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% by Ravindra V. Jategaonkar
% published by AIAA, Reston, VA 20191, USA
%
% Definition of model, flight data, initial values etc. 
% test_case = 8;                    % Unstable aircraft, short period, OEM
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
state_eq = 'xdot_TC08_uAC';        % Function for state equations       
obser_eq = 'obs_TC08_uAC';         % Function for observation equations
Nx       = 2;                      % Number of states 
Ny       = 3;                      % Number of observation variables
Nu       = 1;                      % Number of input (control) variables
NparSys  = 6;                      % Number of system parameters
Nparam   = NparSys;                % Total number of parameters to be estimated
dt       = 0.05;                   % Sampling time

disp(['Test Case = ', num2str(test_case)]);
disp('Unstable aircraft, short period, simulated data')

%----------------------------------------------------------------------------------------
% Load flight data; 
load -ascii ..\flt_data\unStabAC_sim.asc;
data = unStabAC_sim;     

% Number of data points
Ndata = size(data,1);
% Generate new time axis
t = [0:dt:Ndata*dt - dt]';

% Measured outputs az, w q;  measured inputs de
Z    = [data(:,6)  data(:,3)  data(:,4)];
Uinp = data(:,5);

% Initial starting values for unknown parameters (aerodynamic derivatives) 
param = [-1.22871D+00 -1.47680 -4.20491D+00  1.16197D-01 -2.70670D+00 -1.87718D+01]';

% Flag for free and fixed parameters
parFlag = [1;  0;  1; ...
           1;  1;  1];
% Number of free parameters (to be estimated)
NparID = size(find(parFlag~=0),1);
% Total number of states (system states +  free parameters)
Nxp    = Nx + NparID;

% Initial conditions   
x0   = [Z(1,2) Z(1,3)]';

% Augmented state vector:
xa0  = [x0; param(find(parFlag~=0))];

% Perturbations for numerical approximations of system matrices
delxa = [zeros(Nxp,1)+1.0e-06]; 

% Measurement noise covariance matrix - R0(Ny): only diagonal terms
rr   = [5.0e-8 5.0e-8 5.0e-8]';

% Process noise covariance matrix (diagonal terms only)
qq(1:Nx,1)     = 1.0e-9;               % for system states; 
qq(Nx+1:Nxp,1) = [zeros(NparID,1)];    % for system parameters

% Initial state propagation error covariance matrix - pcov(Nxp): only diagonal terms
pa0(1:Nx,1)     = 1.0e+1;     % p0 for system states
pa0(Nx+1:Nxp,1) = 1.0e+1;     % p0 for parameters

% parOEM contains estimates from OEM (RegStartUp, OEM test_case = 6)
parOEM = [-1.4249 -6.2632e+000  2.1635e-001 -3.7125e+000 -1.2769e+001];    

return
% end of function
