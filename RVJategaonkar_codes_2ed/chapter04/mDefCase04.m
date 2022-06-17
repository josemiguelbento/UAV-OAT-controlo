function [state_eq, obser_eq, Nx, Ny, Nu, NparSys, Nparam, NparID, Nminmax, dt, ...
             Ndata, Nzi, izhf, t, Z, Uinp, param, parFlag, param_min, param_max,...
             x0, iArtifStab, StabMat, LineSrch, parFlagX0, NX0ID, ...
                               bXpar, parFlagBX, NbX, NBXID] = mDefCase04(test_case)

% Definition of model, flight data, initial values etc. 
% test_case = 4 -- Longitudinal motion: HFB-320 Aircraft
% Nonlinear model in terms of non-dimensional derivatives as function of
% variables in the stability axes (V, alfa)   
%                  states  - V, alpha, theta, q
%                  outputs - V, alpha, theta, q, qdot, ax, az
%                  inputs  - de, thrust  
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
state_eq   = 'xdot_TC04_hfb_lon';       % function for state equations       
obser_eq   = 'obs_TC04_hfb_lon';        % function for observation equations
Nx         = 4;                         % Number of states 
Ny         = 7;                         % Number of observation variables
Nu         = 2;                         % Number of input (control) variables
NparSys    = 11;                        % number of system parameters
Nparam     = NparSys;                   % Total number of system and bias parameters
dt         = 0.1;                       % sampling time
iArtifStab = 0;                         % No artificial stabilization
LineSrch   = 0;                         % Line search option (=0, No line search, 
                                        %                     =1, Line search)

disp(['Test Case = ', num2str(test_case)]);
disp('Longitudinal motion, nonlinear model -- HFB-320: Nx=4, Ny=7, Nu=2')

Check_Case =  1;     % 1 time segment
% Check_Case =  2;     % 2 time segments
% Check_Case =  5;     %  5 time segments
% Check_Case = 10;     % 10 time segments

%----------------------------------------------------------------------------------------
% Load flight data for Nzi time segments to be analyzed and concatenate 
load -ascii \FVSysID\flt_data\hfb320_1_10.asc;     % flight data file

if Check_Case == 1,    % Nzi=1
    Nzi  = 1;
    data = [hfb320_1_10];    
    Ndt1 = size(hfb320_1_10,1);
    izhf   = [Ndt1];
    
elseif Check_Case == 2,
    Nzi  = 2; 
    data = [hfb320_1_10; hfb320_1_10];    
    Ndt1 = size(hfb320_1_10,1);
    Ndt2 = size(hfb320_1_10,1);
    izhf   = [Ndt1; Ndt1+Ndt2];
    
elseif Check_Case == 5,
    Nzi  = 5; 
    data = [hfb320_1_10; hfb320_1_10; hfb320_1_10; hfb320_1_10; hfb320_1_10;];    
    Ndt1 = size(hfb320_1_10,1);
    Ndt2 = size(hfb320_1_10,1);
    Ndt3 = size(hfb320_1_10,1);
    Ndt4 = size(hfb320_1_10,1);
    Ndt5 = size(hfb320_1_10,1);
    izhf   = [Ndt1; ...
              Ndt1+Ndt2; ...
              Ndt1+Ndt2+Ndt3; ...
              Ndt1+Ndt2+Ndt3+Ndt4;  ...
              Ndt1+Ndt2+Ndt3+Ndt4+Ndt5];
elseif Check_Case == 10,
    Nzi  = 10; 
    data = [hfb320_1_10; hfb320_1_10; hfb320_1_10; hfb320_1_10; hfb320_1_10; ...
            hfb320_1_10; hfb320_1_10; hfb320_1_10; hfb320_1_10; hfb320_1_10];    
    Ndt1  = size(hfb320_1_10,1);
    Ndt2  = size(hfb320_1_10,1);
    Ndt3  = size(hfb320_1_10,1);
    Ndt4  = size(hfb320_1_10,1);
    Ndt5  = size(hfb320_1_10,1);
    Ndt6  = size(hfb320_1_10,1);
    Ndt7  = size(hfb320_1_10,1);
    Ndt8  = size(hfb320_1_10,1);
    Ndt9  = size(hfb320_1_10,1);
    Ndt10 = size(hfb320_1_10,1);
    izhf  = [Ndt1; ...
             Ndt1+Ndt2; ...
             Ndt1+Ndt2+Ndt3; ...
             Ndt1+Ndt2+Ndt3+Ndt4;  ...
             Ndt1+Ndt2+Ndt3+Ndt4+Ndt5; ...
             Ndt1+Ndt2+Ndt3+Ndt4+Ndt5+Ndt6; ...
             Ndt1+Ndt2+Ndt3+Ndt4+Ndt5+Ndt6+Ndt7; ...
             Ndt1+Ndt2+Ndt3+Ndt4+Ndt5+Ndt6+Ndt7+Ndt8; ...
             Ndt1+Ndt2+Ndt3+Ndt4+Ndt5+Ndt6+Ndt7+Ndt8+Ndt9; ...
             Ndt1+Ndt2+Ndt3+Ndt4+Ndt5+Ndt6+Ndt7+Ndt8+Ndt9+Ndt10];
else
    disp('wrong check case')
    mDefStop
end

% Number of data points Ndata and cumulative index izhf
% Ndata1 = size(hfb320_1_10,1);
% izhf   = [Ndata1];
% Ndata1 = size(hfb320_1_10,1);
% Ndata2 = size(hfb320_1_10,1);
% izhf   = [Ndata1; Ndata1+Ndata2];

Ndata  = size(data,1);

% Generate new time axis
t = [0:dt:Ndata*dt-dt]';

% Observation variables V, alpha, theta, q, qdot, ax, az
Z = [data(:,5) data(:,6) data(:,7) data(:,8) data(:,9) data(:,10) data(:,11)];

% Input variables de, thrust
Uinp = [data(:,2)  data(:,4)];

% Initial starting values for unknown parameters (aerodynamic derivatives) 
% CD0, CDV, CDAL, CL0, CLV, CLAL, CM0, CMV, CMAL, CMQ, CMDE                                                 
param = [ 5.67516D-03;  7.72612D-03;  6.74256D-01; ...
         -3.18267D-01;  2.60317D-01;  5.37576D+00; ...
          4.98218D-02;  1.89182D-02; -4.98586D-01; -2.58439D+01; -9.90687D-01];

% Define lower and upper bounds for the parameters to be estimated
param_min(1:Nparam,1) = -Inf;          % default values for Unconstrained optimization
param_max(1:Nparam,1) =  Inf;
% param_min(10) = -4.0D+01;  param_max(10) = -2.50D+01;   % Cmq

% Determine the number of lower and upper bounds
if isempty( find(param_min~=-Inf)  |  find(param_max~=Inf) ) ~=0 ,
   Nminmax = 0; 
else
   Nminmax = size( find ( diff( sort([find(param_min~=-Inf); find(param_max~=Inf)]) ) ), 1) + 1; 
end

% Flags for free and fixed parameters
%parFlag =ones(Nparam,1);
parFlag = [1;  1;  1; ...
           1;  1;  1;...
           1;  1;  1;  1;  1];

% Total number of free parameters
NparID = size(find(parFlag~=0),1); 

% Initial conditions on state variables V, alpha, theta, q
x0(:,1) = [ 1.06023E+02; 1.11685E-01; 1.04887E-01; -3.32659E-03];
if Nzi > 1, 
    for iz=2:Nzi, x0(:,iz) = x0(:,1); end
end

% Flags for free and fixed initial conditions
parFlagX0(:,1) =[0;  0;  0;  0];
% parFlagX0(:,1) =[1;  1;  1;  1];
% parFlagX0(:,1) =[1;  0;  1;  0];

% parFlagX0(:,1) =[1;  1;  1;  1];       % Check case 4: NZI=2; free + fixed
% parFlagX0(:,2) =[1;  1;  1;  1];       

% parFlagX0(:,1) =[1;  0;  1;  0];       % Check case 4: NZI=2; free + fixed
% parFlagX0(:,2) =[1;  0;  1;  0];       
% 
% parFlagX0(:,1) =[0;  0;  0;  0];
% parFlagX0(:,2) =[0;  0;  0;  0];

% parFlagX0(:,1) =[1;  0;  1;  0];       % Check case 4: NZI=2; free + fixed
% parFlagX0(:,2) =[1;  1;  0;  1];       

% parFlagX0(:,1) =[1;  1;  1;  1];
% if Nzi > 1, 
%     for iz=2:Nzi, parFlagX0(:,iz) = parFlagX0(:,1); end
% end

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

