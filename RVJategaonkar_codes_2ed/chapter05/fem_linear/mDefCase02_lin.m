function [param, Anames, Bnames, Cnames, Dnames, Fnames, BXnames, BYnames,...
          iSD, SD_yError, Nx, Nu, Ny, Ts, dt, Ndata, Z, Uinp, x0] = mDefCase02_lin(test_case)

% Chapter 5: Filter Error Method
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA

param.names  = {'LP', 'LR', 'NP', 'NR', ...
                'LDA', 'LDR', 'LV', 'NDA', 'NDR', 'NV', ...
                'YP', 'YR', 'YDA', 'YDR', 'YV', ...
                'f11', 'f22', ...
                'bxpdot', 'bxrdot', ...
                'bypdot', 'byrdot', 'byay', 'byp', 'byr'}';

param.values = [-6.7;   1.83; -0.906; -0.665; ...
                -18.3;  0.43; -0.114; -0.66; -2.82;  0.0069; ...
                -0.64;  1.30; -1.40;   2.79; -0.193;
                 0.02;  0.02; ...
                 0.08; -0.089; ...
                 0.08; -0.089; 0.044; -0.0034; -0.0015];

param.flags  = [1;  1; 1; 1; ...
                1;  1; 1; 1; 1;  1; ...
                1;  1; 1; 1; 1; ...
                1;  1; ...
                1;  1; ...
                1;  1;  1;  1;  1];

Anames = {'LP' 'LR'; ...
          'NP' 'NR'};
  
Bnames = {'LDA' 'LDR' 'LV'; ...
          'NDA' 'NDR' 'NV'};

Cnames = {'LP' 'LR'; ...
          'NP' 'NR'; ...
          'YP' 'YR'; ...
           1    0; ...
           0    1 };
  
Dnames = {'LDA' 'LDR' 'LV'; ...
          'NDA' 'NDR' 'NV'; ...
          'YDA' 'YDR' 'YV'; ...
           0     0     0  ; ...
           0     0     0 };

Fnames = {'f11'  0 ; ...
           0    'f22'};

BXnames = {'bxpdot' 'bxrdot'}';

BYnames = {'bypdot' 'byrdot' 'byay' 'byp' 'byr'}';

% model size
Nx = size(Anames,1);                     % Number of state variables
Nu = size(Bnames,2);                     % Number of input variables
Ny = size(Cnames,1) ;                    % Number of output variables

%----------------------------------------------------------------------------------------
% Load flight data for Nzi time segments to be analyzed and concatenate 
load -ascii ..\..\flt_data\y13aus_da1.asc;
data = y13aus_da1;     

% Sampling time
dt    = 0.05;  

% Number of data points
Ndata = size(data,1);  

% Generate new time axis
Ts    = [0:dt:Ndata*dt-dt]';           % Time vector

% Observation variables pdot, rdot, ay, p, r
Z = [data(:,12) data(:,13) data(:,14) data(:,15) data(:,16)];

% Input variables aileron, rudder, vk
Uinp = [data(:,17) data(:,18) data(:,19)];

% Initial conditions p0, r0
x0 = [0; 0];

% Initial R: Default (iSD=0) or specified as standard deviations of output errors 
iSD = 0;
%iSD = 1;
SD_yError =[0.164516  0.1487645  0.2213919  0.0824749  0.4420580];
