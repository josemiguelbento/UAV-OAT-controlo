function [state_eq, obser_eq, Nx, Ny, Nu, NparSys, Nparam, NparID, dt, Ndata, ...
                   t, Z, Uinp, param, parFlag, x0, iSD, SDyError] = mDefCase04(test_case)

% Definition of model, flight data, initial values etc. 
% test_case = 4 -- Longitudinal motion: HFB-320 Aircraft
% Nonlinear model in terms of non-dimensional derivatives as function of
% variables in the stability axes (V, alfa):   
%                  states  - V, alpha, theta, q
%                  outputs - V, alpha, theta, q, qdot, ax, az
%                  inputs  - de, thrust  
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
state_eq   = 'xdot_TC04_hfb_lon';        % Function for state equations       
obser_eq   = 'obs_TC04_hfb_lon';         % Function for observation equations
Nx         = 4;                          % Number of states 
Ny         = 7;                          % Number of observation variables
Nu         = 2;                          % Number of input (control) variables
NparSys    = 11;                         % Number of system parameters
Nparam     = NparSys + Nx;               % Total number of parameters to be estimated
dt         = 0.1;                        % Sampling time
iSD        = 0;                          % Initial R option (default; 0) 

disp(['Test Case = ', num2str(test_case)]);
disp('Longitudinal motion, nonlinear model -- HFB-320: Nx=4, Ny=7, Nu=2')

%----------------------------------------------------------------------------------------
% Load flight data for Nzi time segments to be analyzed and concatenate 
load -ascii ..\flt_data\hfb320_1_10.asc;
data = hfb320_1_10;     

% Number of data points
Ndata = size(data,1);
izhf  = Ndata;

% Generate new time axis
t = [0:dt:Ndata*dt-dt]';

% Observation variables V, alpha, theta, q, qdot, ax, az
Z = [data(:,5) data(:,6) data(:,7) data(:,8) data(:,9) data(:,10) data(:,11)];

% Input variables de, thrust
Uinp = [data(:,2) data(:,4)];

% Initial starting values for unknown parameters (aerodynamic derivatives) 
% CD0, CDV, CDAL, CL0, CLV, CLAL, CM0, CMV, CMAL, CMQ, CMDE,f11, f22, f33, f44                                                 
param = [ 5.67516D-03;  7.72612D-03;  6.74256D-01; ...
         -3.18267D-01;  2.60317D-01;  5.37576D+00; ...
          4.98218D-02;  1.89182D-02; -4.98586D-01; -2.58439D+01; -9.90687D-01; ...
          2.00000D-02;  2.00000D-03;  2.00000D-02;  2.00000D-02];

% Flags for free and fixed parameters
   parFlag = [1; 1; 1;...
               1; 1; 1;...
               1; 1; 1; 1; 1;...
               1; 1; 1; 1];
       
% Total number of free parameters
NparID = size(find(parFlag~=0),1); 

% Initial conditions on state variables V, alpha, theta, q
x0 = [1.06023E+02; 1.11685E-01; 1.04887E-01; -3.32659E-03];

% Initial R: Default (iSD=0) or specified as standard-deviations of output errors 
SDyError = [];
% SDyError = zeros(Ny,1);
% iSD = 1;
% SDyError = [.....]';     % if iSD=1, specify SD for Ny outputs
