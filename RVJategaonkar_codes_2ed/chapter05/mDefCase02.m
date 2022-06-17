function [state_eq, obser_eq, Nx, Ny, Nu, NparSys, Nparam, NparID, dt, Ndata, ...
                   t, Z, Uinp, param, parFlag, x0, iSD, SDyError] = mDefCase02(test_case)

% Definition of model, flight data, initial values etc.
% test_case = 2: Lateral-directional motion, nx=2, ny=5, nu=3, 
%                Simulated data with process noise
%                states  - p, r
%                outputs - pdot, rdot, ay, p, r
%                inputs  - aileron, rudder, v 
%
% Chapter 5: Filter Error Method
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
%    dt           sampling time
%    Ndata        total number of data points for Nzi time segments
%    t            time vector
%    Z            observation variables: Data array of measured outputs (Ndata,Ny)
%    Uinp         input variables: Data array of measured input (Ndata,Nu)
%    param        initial starting values for unknown parameters (aerodynamic derivatives) 
%    parFlag      flags for free and fixed parameters
%    x0           initial conditions on state variables
%    iSD          Flag to specify optionally initial R (default; 0) 
%    SDyError     standard-deviations of output errors to compute initial covariance
%                 matrix R (required only for iSD ~= 0)
                       
                       
% Constants
d2r   = pi/180;
r2d   = 180/pi;

%----------------------------------------------------------------------------------------
% Model definition
state_eq   = 'xdot_TC02_dhc2_lat';      % Function for state equations       
obser_eq   = 'obs_TC02_dhc2_lat';       % Function for observation equations
Nx         = 2;                          % Number of states 
Ny         = 5;                          % Number of observation variables
Nu         = 3;                          % Number of input (control) variables
NparSys    = 15;                         % Number of system parameters
Nparam     = NparSys + Nx + Ny +Nx;      % Total number of parameters to be estimated
dt         = 0.05;                       % Sampling time
iSD        = 0;                          % Initial R option (default; 0) 

disp(['Test Case = ', num2str(test_case)]);
disp('Lateral motion, simulated data with turbulence: Nx=2, Ny=5, Nu=3')

%----------------------------------------------------------------------------------------
% Load flight data for Nzi time segments to be analyzed and concatenate 
load -ascii ..\flt_data\y13aus_da1.asc;     % flight data file
data = y13aus_da1;                          % Number of time segements (Maneuvers)     

% Number of data points
Ndata = size(data,1);

% Generate new time axis
t = [0:dt:Ndata*dt-dt]';

% Observation variables pdot, rdot, ay, p, r
Z = [data(:,12) data(:,13) data(:,14) data(:,15) data(:,16)];

% Input variables aileron, rudder, vk
Uinp = [data(:,17) data(:,18) data(:,19)];

% Initial starting values for unknown parameters (aerodynamic derivatives) 
param = [-6.7;    1.83;  -18.3;   0.43;   -0.114;...
         -0.906; -0.665; -0.66;  -2.82;   0.0069;... 
         -0.64;   1.30;  -1.40;   2.79;   -0.193;...
          0.08;  -0.089;...
          0.08;  -0.089;  0.044; -0.0034; -0.0015;... 
          0.02;   0.02 ];

% Flag for free and fixed parameters
parFlag = [1; 1; 1; 1; 1;...   
           1; 1; 1; 1; 1;...
           1; 1; 1; 1; 1;...
           1; 1;...
           1; 1; 1; 1; 1;...
           1; 1];
   
% Total number of free parameters
NparID = size(find(parFlag~=0),1); 

% Initial conditions on state variables p0, r0
x0 = [0; 0];

% Initial R: Default (iSD=0) or specified as standard-deviations of output errors 
SDyError = [];
% SDyError = zeros(Ny,1);
% iSD = 1;
% SDyError = [.....]';     % if iSD=1, specify SD for Ny outputs
