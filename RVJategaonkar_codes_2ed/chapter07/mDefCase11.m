function [state_eq, obser_eq, Nx, Ny, Nu, NparSys, Nparam, NparID, Nxp, dt, Ndata,...
          t, Z, Uinp, param, parFlag, xa0, delxa, rr, qq, pa0, parOEM] = mDefCase11(test_case)

% Chapter 7: Recursive Parameter Estimation 
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% by Ravindra V. Jategaonkar
% published by AIAA, Reston, VA 20191, USA
%
% Definition of model, flight data, initial values etc. 
% test_case = 11  --  Short period motion, n=2, m=2, p=1, ATTAS
%                     states  - alpha, q
%                     outputs - alpha, q
%                     inputs  - dele   
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
state_eq = 'xdot_TC11_lon_sp';     % Function for state equations                 
obser_eq = 'obs_TC11_lon_sp';      % Function for observation equations
Nx       = 2;                      % Number of states 
Ny       = 2;                      % Number of observation variables
Nu       = 1;                      % Number of input (control) variables
NparSys  = 8;                      % Number of system parameters
Nparam   = NparSys;                % Number of system parameters
dt       = 0.04;                   % Sampling time

disp(['Test Case = ', num2str(test_case)]);
disp('Short period motion - ATTAS: Nx=2, Ny=2, Nu=1')

%----------------------------------------------------------------------------------------
% Load flight data
load ..\flt_data\fAttasElv1;  
load ..\flt_data\fAttasElv2;  
data = [fAttasElv1; fAttasElv2];
Ndata1 = size(fAttasElv1,1);
Ndata2 = size(fAttasElv1,1);
    
% Number of data points
Ndata = size(data,1);

% Generate new time axis
t = [0:dt:Ndata*dt - dt]';

% Observation variables alpha, q
Z    = [data(:,13)*d2r data(:,8)*d2r];

% Input variable elevator deflection
Uinp = data(:,22)*d2r;

% Initial starting values for unknown parameters (aerodynamic derivatives) 
param = [-2.52504e-03 -2.13832e-01  2.78189e-02  1.66147e-01...
          2.71618e-01 -2.73646e+00 -1.08034e+00 -3.18940e+00]';

% Flag for free and fixed parameters
parFlag = [1;  1;  1;  1; ...
           1;  1;  1;  1];

% Number of free parameters (to be estimated)
NparID = size(find(parFlag~=0),1);
% Total number of states (system states +  free parameters)
Nxp = Nx + NparID;

% Initial conditions   
x0 = [Z(1,1) Z(1,2)]';

% Augmented state vector:
xa0 = [x0; param(find(parFlag~=0))];

% Perturbations to compute approximations of system matrices
delxa = [zeros(Nxp,1)+1.0e-04]; 

% Measurement noise covariance matrix - R0(Ny): only diagonal terms
rr = [4.10310101e-07 7.96755798e-07]';  
    
% Process noise covariance matrix - only diagonal terms
qq(1:Nx,1)     = 1.0e-7;               % for system states; 
qq(Nx+1:Nxp,1) = [zeros(NparID,1)];    % for system parameters
    
% Initial state propagation error covariance matrix - pcov(Nxp): only diagonal terms
pa0(1:Nx,1)     = 1.0e+1;     % p0 for system states
pa0(Nx+1:Nxp,1) = 1.0e+1;     % p0 for parameters

% parOEM contains estimates from OEM (/FVSYSID/Chapter4/ml_oem, (test_case = 11).
% This is for comparison purposes only.
parOEM = [-8.98779e-003  -4.83362e-001   1.04198e-001   6.76322e-001...
           4.75234e-001  -4.92651e+000  -2.00573e+000  -7.20806e+000];

   return
% end of function
