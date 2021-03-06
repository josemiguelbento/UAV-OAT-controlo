function [state_eq, obser_eq, Nx, Ny, Nu, NparSys, Nparam, NparID, Nminmax, dt, ...
             Ndata, Nzi, izhf, t, Z, Uinp, param, parFlag, param_min, param_max,...
             x0, iArtifStab, StabMat, LineSrch, parFlagX0, NX0ID, ...
                               bXpar, parFlagBX, NbX, NBXID] = mDefCase22()

% Definition of model, flight data, initial values etc. 
% test_case = 22 -- Flight path reconstruction, multiple time segments (NZI=3),
%                   longitudinal and lateral-directional motion
%                   states  - u, v, w, phi, theta, psi, h
%                   outputs - V, alpha, beta, phi, theta, psi, h
%                   inputs  - ax, ay, az, p, q, r, (pdot, qdot, rdot)
%
% Chapter 4: Output Error Method
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA
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

%----------------------------------------------------------------------------------------
% Model definition
state_eq   = 'xdot_TC22_fpr';            % function for state equations       
obser_eq   = 'obs_TC22_fpr';             % function for observation equations
Nx         = 7;                          % Number of states 
Ny         = 7;                          % Number of observation variables
Nu         = 9;                          % Number of input (control) variables
% NparSys    = 6;                          % number of system parameters
NparSys    = 10;                         % number of system parameters
Nparam     = NparSys;                    % Total number of system and bias parameters
dt         = 0.02;                       % sampling time
iArtifStab = 0;                          % No artificial stabilization
LineSrch   = 0;                          % Line search option (=0, No line search, 
                                         %                     =1, Line search)

disp('Flight path reconstruction: X-Plane, longitudinal and lateral-directional motion')

%----------------------------------------------------------------------------------------
% Load flight data for Nzi time segments to be analyzed and concatenate 
addpath '..\..\get_coeffs'
data_load = load('../flight_data_1/ProcessedData_2022_05_07_11_13_57.mat');
data_aux = data_load.el_1;

% RCch1 = delta_a; RCch2 = delta_e: RCch3 = delta_t; RCch4 = delta_r
% In data: - delta in PWM; - RCch in degrees; - except delta_t and RCch3
[pwm2deg_ail, pwm2deg_el, pwm2deg_rud] = PWM2degree();
data_aux.RCch1 = deg2rad(pwm2deg_ail(data_aux.delta_a));
data_aux.RCch2 = deg2rad(pwm2deg_el(data_aux.delta_e));
data_aux.RCch3 = data_aux.delta_t;
data_aux.RCch4 = deg2rad(pwm2deg_rud(data_aux.delta_r));

% (1x1) struct to (Nx1) struct
data_T = struct2table(data_aux);
data_T.Properties.VariableNames{'roll'} = 'phi';
data_T.Properties.VariableNames{'pitch'} = 'theta';
data_T.Properties.VariableNames{'yaw'} = 'psi';
data_T.phi = deg2rad(data_T.phi);
data_T.psi = deg2rad(data_T.psi);
data_T.theta = deg2rad(data_T.theta);
data_T.AoA = deg2rad(data_T.AoA);
data_T.beta = deg2rad(data_T.beta);
data = table2struct(data_T);

Nzi = 1;         % number of maneuvers
% data = [fAttasElv1; fAttasAil1; fAttasRud1];    % name of each maneuver

% Number of data points
% Ndata1 = size(fAttasElv1,1);
% Ndata2 = size(fAttasAil1,1);
% Ndata3 = size(fAttasRud1,1);
% izhf   = [Ndata1; Ndata1+Ndata2; Ndata1+Ndata2+Ndata3];
Ndata  = size(data,1);
izhf = [Ndata];

% Generate new time axis
t = [0:dt:Ndata*dt-dt]';

% Observation variables V, alpha, beta, phi, theta, psi, h
Z = [ [data.Va]'...      % Va
      [data.AoA]'...     % AoA
      [data.beta]'...    % beta
      [data.phi]'...     % phi
      [data.theta]'...   % theta
      [data.psi]'...     % psi
      [data.h]'...       % h
    ];

% Generate pdot, qdot and rdot by numerical differentiation of p, q, r
[pDot, qDot, rDot] = ndiff_pqr(Nzi, izhf, dt, [data.p], [data.q], [data.r]);

% Input variables ax, ay, az, p, q, r, pdot, qdot, rdot
Uinp = [[data.ax]'      [data.ay]'      [data.az]' ...      % m s^-2
        [data.p]'       [data.q]'       [data.r]' ...       % rad/s
        pDot            qDot            rDot];             % rad s^-2

% Initial starting values for unknown parameters (aerodynamic derivatives) 
param = zeros(Nparam,1);
% param = [0; 0; 9.66253e-2; 0; 0; 0];

% assuming AoA and angle of sideslip correctly calibrated
% param = zeros(6,1);
% param(7,1)  = 1.0;
% param(8,1)  = 0.0;
% param(9,1)  = 1.0;
% param(10,1) = 0.0;

% Define lower and upper bounds for the parameters to be estimated
param_min(1:Nparam,1) = -Inf;          % default values for unconstrained optimization
param_max(1:Nparam,1) =  Inf;

% Determine the number of lower and upper bounds
if isempty( find(param_min~=-Inf)  |  find(param_max~=Inf) ) ~=0 
   Nminmax = 0; 
else
   Nminmax = size( find ( diff( sort([find(param_min~=-Inf); find(param_max~=Inf)]) ) ), 1) + 1; 
end

% Flag for free and fixed parameters
parFlag = ones(Nparam,1);

% Total number of free parameters
NparID = size(find(parFlag~=0),1); 

% Initial conditions u0, v0, w0, phi0, theta0, psi0, h0
%  x0(:,1) = [129.4; -0.9; 5.05;...                                %first time segment
%             Z(1,4); Z(1,5); Z(1,6);...
%             Z(1,7)];  
%  x0(:,2) = [129.4; -0.9; 5.15;...                                %second time segment
%             Z(izhf(1)+1,4); Z(izhf(1)+1,5); Z(izhf(1)+1,6);...
%             Z(izhf(1)+1,7)];  
%  x0(:,3) = [128.7; -0.9; 4.75;...                                %Third time segment
%             Z(izhf(2)+1,4); Z(izhf(2)+1,5); Z(izhf(2)+1,6);...
%             Z(izhf(2)+1,7)];     
x0(:,1) = [data(1).u; data(1).v; data(1).w;...
           Z(1,4); Z(1,5); Z(1,6);...
           Z(1,7)];

% Flags for free and fixed initial conditions
parFlagX0(:,1) = [0;  0;  0;  0;  0;  0;  0]; 
% parFlagX0(:,1) =[1;  1;  1;  1;  1;  1;  1]; 

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
if isempty( bXpar ) ~=0 
    NbX   = 0; 
    NBXID = 0;
else
    NbX   = size(bXpar(:,1),1);
    NBXID = size(find(parFlagBX~=0),1);
end

% Artificial stabilization matrix
StabMat = zeros(Nx,Ny);               