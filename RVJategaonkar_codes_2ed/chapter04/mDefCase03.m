function [state_eq, obser_eq, Nx, Ny, Nu, NparSys, Nparam, NparID, Nminmax, dt, ...
             Ndata, Nzi, izhf, t, Z, Uinp, param, parFlag, param_min, param_max,...
             x0, iArtifStab, StabMat, LineSrch, parFlagX0, NX0ID, ...
                               bXpar, parFlagBX, NbX, NBXID] = mDefCase03(test_case)

% Definition of model, flight data, initial values etc. 
% test_case = 3: Lateral-directional motion, nx=2, ny=2, nu=3, test aircraft ATTAS
%                states  - p, r
%                outputs - p, r
%                inputs  - aileron, rudder, beta 
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
state_eq   = 'xdot_TC03_lat_pr';        % function for state equations       
obser_eq   = 'obs_TC03_lat_pr';         % function for observation equations
Nx         = 2;                         % Number of system states
Ny         = 2;                         % Number of observation variables
Nu         = 3;                         % Number of input (control) variables
NparSys    = 12;                        % number of system parameters
Nparam     = NparSys;                   % Total number of system and bias parameters
dt         = 0.04;                      % sampling time
iArtifStab = 0;                         % No artificial stabilization
LineSrch   = 0;                         % Line search option (=0, No line search, 
                                        %                     =1, Line search)

disp(['Test Case = ', num2str(test_case)]);
disp('Lateral-directional motion - ATTAS: Nx=2, Ny=2, Nu=3')

%----------------------------------------------------------------------------------------
% Load flight data for Nzi time segments to be analyzed and concatenate 
load ..\flt_data\fAttasAilRud1;         % flight data files
load ..\flt_data\fAttasAilRud2;
Nzi  = 2;                               % Number of time segements (Maneuvers)
data = [fAttasAilRud1; fAttasAilRud2];

% Number of data points Ndata and cumulative index izhf
Ndata1 = size(fAttasAilRud1,1);
Ndata2 = size(fAttasAilRud2,1);
izhf   = [Ndata1; Ndata1+Ndata2];
Ndata  = size(data,1);

% Generate new time axis
t = [0:dt:Ndata*dt-dt]';

% Observation variables p, r
Z = [data(:,7)*d2r data(:,9)*d2r];

% Input variables dela, delr, beta 
Uinp = [(data(:,29)-data(:,28))*0.5*d2r  data(:,30)*d2r  data(:,14)*d2r];
    
% Initial starting values for unknown parameters (aerodynamic derivatives) 
param = [-3.53744e+00;  6.75534e-01; -4.93279e+00;  0.73334e+00; -4.34076e+00;  6.50204e-03;...
         -0.86939e-01; -1.69526e-01; -1.92049e-01; -0.74855e+00;  2.05155e+00;  1.98767e-02]; 
 
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
parFlag = ones(Nparam,1);                   % All parameters being estimated
% parFlag = [1;  1;  1;  1;  1;  1;...
%            1;  1;  1;  1;  1;  1 ];

% Total number of free parameters
NparID = size(find(parFlag~=0),1); 

% Initial conditions on state variables p0, r0
x0(:,1) = [Z(1,1); Z(1,2)];                   % first time segment
x0(:,2) = [Z(Ndata1+1,1); Z(Ndata1+1,2)];     % second time segment

% Flags for free and fixed initial conditions
parFlagX0(:,1) =[0;  0];
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
if isempty( bXpar ) ~=0 ,
    NbX   = 0; 
    NBXID = 0;
else
    NbX   = size(bXpar(:,1),1);
    NBXID = size(find(parFlagBX~=0),1);
end


% Artificial stabilization matrix
StabMat = zeros(Nx,Ny);               
