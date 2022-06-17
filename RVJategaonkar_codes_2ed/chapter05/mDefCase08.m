function [state_eq, obser_eq, Nx, Ny, Nu, NparSys, Nparam, NparID, dt, Ndata, ...
                   t, Z, Uinp, param, parFlag, x0, iSD, SDyError] = mDefCase08(test_case)

% Definition of model, flight data, initial values etc. 
% test_case = 8 -- Unstable aircraft, short period, Filter error method
% variables:       states  - w, q
%                  outputs - az, w, q
%                  inputs  - de
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
d2r = pi/180;
r2d = 180/pi;

%----------------------------------------------------------------------------------------
% Model definition
state_eq   = 'xdot_TC08_uAC';          % Function for state equations       
obser_eq   = 'obs_TC08_uAC';           % Function for observation equations
Nx         = 2;                        % Number of states 
Ny         = 3;                        % Number of observation variables
Nu         = 1;                        % Number of input (control) variables
NparSys    = 6;                        % Number of system parameters
Nparam     = NparSys + Nx;             % Total number of parameters to be estimated
dt         = 0.05;                     % Sampling time
iSD        = 0;                        % Initial R option (default; 0) 

disp(['Test Case = ', num2str(test_case)]);
disp('Unstable aircraft, short period: Nx=2, Ny=3, Nu=1')

%----------------------------------------------------------------------------------------
% Load flight data for Nzi time segments to be analyzed and concatenate 
load -ascii ..\flt_data\unStabAC_sim.asc;
data = unStabAC_sim;     

% Number of data points
Ndata = size(data,1);

% Generate new time axis
t = [0:dt:Ndata*dt-dt]';

% Observation variables az, w, q
Z = [data(:,6) data(:,3) data(:,4)];

% Input variables de
Uinp = [data(:,5)];

% Initial starting values for unknown parameters (aerodynamic derivatives) 
param = [-1.22871D+00; -1.47680D+00; -4.20491D+00;...
          1.16197D-01; -2.70670D+00; -1.87718D+01;...
          5.00000D-06;  5.00000D-06 ];

% Flags for free and fixed parameters
parFlag = [1; 0; 1; ...           % Zq fixed
           1; 1; 1; ...
           0; 0];                 % Last two parameters are held fixed
                                  % (Simulated data with no process noise being analyzed)
       
% Total number of free parameters
NparID = size(find(parFlag~=0),1); 

% Initial conditions w0, q0
x0 = [0.0; 0.0];

% Initial R: Default (iSD=0) or specified as standard-deviations of output errors 
SDyError = [];
% SDyError = zeros(Ny,1);
% iSD = 1;
% SDyError = [.....]';     % if iSD=1, specify SD for Ny outputs
