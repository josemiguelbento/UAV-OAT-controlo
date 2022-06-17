function [Nu, Ny, Ndata, NdataPred, dt, T, Xin, Zout] = mDefCase04(test_case);

% Definition of model, flight data, initial values etc. 
% test_case = 4 -- Longitudinal motion: HFB-320 Aircraft (atmospheric turbulence)
% Data pre-processing (computation of aerodynamic force and moment coefficients) 
%            inputs  - e, da, dr, p, q, r, al, be, V, qbar, fnl, fnr, al->alDot  
%            outputs - CD, CL, Cm
% Aerodynamic modeling using FFNN 
%            inputs  - de, al, q, V  
%            outputs - CD, CL, Cm

% Inputs:
%    test_case   Test case number
% Outputs:
%    Nu          Number of nodes in the input layer (No. of input variables)
%    Ny          Number of nodes in the output layer  (No. of output variables)
%    Ndata       Number of data points used in the training cycle
%    Ndatapred   Number of data points to be used for prediction cycle
%    dt          Sampling time
%    T           Time (Ndata,1)
%    Xin         Input space (Ndata,Nu)
%    Zout        Output space (Ndata,Ny)
%
% Chapter 8: Artificial Neural Networks
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA


%--------------------------------------------------------------------------
% Constants
d2r   = pi/180;
r2d   = 180/pi;

disp(['Test Case = ', num2str(test_case)]);
disp('Longitudinal motion -- HFB-320; flight data with turbulence: Ny=3, Nu=4')

%--------------------------------------------------------------------------
% Load flight data for Nzi time segments to be analyzed and concatenate 
load -ascii ..\flt_data\hfb320_1_10.asc;
Nzi  = 1;
data = hfb320_1_10;     
Nts1 = size(hfb320_1_10,1);
izhf = Nts1;
dt   = 0.1;

% Observation variables ax, ay, az, pDot, qDot, rDot
ZAccel = [data(:,10)  data(:,12)  data(:,11)...
          data(:,15)  data(:, 9)  data(:,16) ];

% Input variables for pre-computations:
% de, da, dr, p, q, r, al, be, V, qbar, fnl, fnr
Uinp = [data(:, 2)  data(:,19)      data(:,20)...
        data(:,13)  data(:, 8)      data(:,14)...
        data(:, 6)  data(:,17)      data(:, 5)...
        data(:, 3)  data(:, 4)*0.5  data(:,4)*0.5];

% Data pre-processing to compute aerodynamic force and moment coefficients
[Z, Uinp] = umr_reg_hfb(ZAccel, Uinp, Nzi, izhf, dt, test_case);

%--------------------------------------------------------------------------
% Input and output variables of neural network:

% Output variables CD, CL, Cm (drag, lift and pitching moment coefficients)
Zout = Z;

% Input variables for neural network: de, al, q, V
Xin  = [Uinp(:,1)  Uinp(:,7)  Uinp(:,5)  Uinp(:,9)];

%--------------------------------------------------------------------------
Nu = size(Xin,2);                      % Nu = number of inputs
Ny = size(Zout,2);                     % Ny = number of outputs
Ndata     = size(Xin,1);               % Number of data points for training
NdataPred = Ndata;                     % Number of data points for prediction
T         = [0:dt:Ndata*dt - dt]';     % Time vector (for plotting)

