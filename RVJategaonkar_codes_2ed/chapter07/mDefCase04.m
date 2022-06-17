function [state_eq, obser_eq, Nx, Ny, Nu, NparSys, Nparam, NparID, Nxp, dt, Ndata,...
          t, Z, Uinp, param, parFlag, xa0, delxa, rr, qq, pa0, parOEM] = mDefCase04(test_case)

% Chapter 7: Recursive Parameter Estimation 
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% by Ravindra V. Jategaonkar
% published by AIAA, Reston, VA 20191, USA
%
% Definition of model, flight data, initial values etc. 
% test_case = 4 -- Longitudinal motion: HFB-320 Aircraft
% Nonlinear model in terms of non-dimensional derivatives as function of
% variables in the stability axes (V, alfa)   
%                  states  - V, alpha, theta, q
%                  outputs - V, alpha, theta, q, qdot, ax, az
%                  inputs  - de, qbar, thrust
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
state_eq   = 'xdot_TC04_hfb_lon';        % Function for state equations       
obser_eq   = 'obs_TC04_hfb_lon';         % Function for observation equations
Nx         = 4;                          % Number of states 
Ny         = 7;                          % Number of observation variables
Nu         = 2;                          % Number of input (control) variables
NparSys    = 11;                         % Number of system parameters
Nparam     = NparSys;                    % Total number of parameters to be estimated
dt         = 0.1;                        % Sampling time

disp(['Test Case = ', num2str(test_case)]);
disp('Longitudinal motion, nonlinear model -- HFB-320: Nx=4, Ny=7, Nu=2')

%----------------------------------------------------------------------------------------
% Load flight data for Nzi time segments to be analyzed and concatenate 
load -ascii ..\flt_data\hfb320_1_10.asc;
data = hfb320_1_10;     

% Number of data points
Ndata = size(data,1);

% Generate new time axis
t = [0:dt:Ndata*dt - dt]';

% Observation variables V, alpha, theta, q, qdot, ax, az
Z = [data(:,5) data(:,6) data(:,7) data(:,8) data(:,9) data(:,10) data(:,11)];

% Input variables de, thrust
Uinp = [data(:,2) data(:,4)];

% Initial starting values for unknown parameters (aerodynamic derivatives) 
% CD0, CDV, CDAL, CL0, CLV, CLAL, CM0, CMV, CMAL, CMQ, CMDE                                                
param = [ 5.67516D-03;  7.72612D-03;  6.74256D-01; ...
         -3.18267D-01;  2.60317D-01;  5.37576D+00; ...
          4.98218D-02;  1.89182D-02; -4.98586D-01; -2.58439D+01; -9.90687D-01];

% Flag for free and fixed parameters
parFlag = [1;  1;  1; ...
           1;  1;  1;...
           1;  1;  1;  1;  1];

% Number of free parameters (to be estimated)
NparID = size(find(parFlag~=0),1);
% Total number of states (system states +  free parameters)
Nxp = Nx + NparID;

% Initial conditions on state variables V, alpha, theta, q
x0   = [1.06023E+02; 1.11685E-01; 1.04887E-01; -3.32659E-03];

% Augmented state vector:
xa0  = [x0; param(find(parFlag~=0))];

% Perturbations to compute approximations of system matrices
delxa = [zeros(Nxp,1)+1.0e-04]; 

% Measurement noise covariance matrix - R0(Ny): only diagonal terms
% Matrix R values from fem
rr   = [0.01758668956825  0.00000099020743  0.00000019774013  0.00000033836151...
        0.00003168412236  0.00041909760875  0.02020310372280]';
     
% Process noise covariance matrix (diagonal terms only)
% f11, f22, f33, f44: 3.58553e-001   2.42099e-003   4.47607e-004 1.73778e-003 
% obtained from /FVSysID/chapter05/ml_fem for test_case=4.
% F = diag([3.58553e-001   2.42099e-003   4.47607e-004   1.73778e-003])
% The corresponding covraince matrix qq in discrete time is given by FF'/dt.
% (For more explanation, refer to Appendix A6)
% qq for system state, followed by that for augmented states (parameters)
qq(1:Nx,1)     = [0.12856025380900  0.00000586119258  0.00000020035203  0.00000301987933]'/dt;
qq(Nx+1:Nxp,1) = [zeros(NparID,1)];
    
% Initial state propagation error covariance matrix - pcov(Nxp): only diagonal terms
pa0(1:Nx,1)     = 1.0e+1;     % p0 for system states
pa0(Nx+1:Nxp,1) = 1.0e+1;     % p0 for parameters

% Reference parameter values from ml_fem for plot    
% parFEM contains estimates from FEM - for comparison purposes only
parOEM = [ 1.22688e-001  -6.44969e-002   3.20055e-001...
          -9.29113e-002   1.48726e-001   4.32785e+000... 
           1.11905e-001   3.95154e-003  -9.67854e-001  -3.47098e+001  -1.52913e+000];

return
% end of function
