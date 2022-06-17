function [Nu, Ny, Ndata, NdataPred, dt, T, Xin, Zout] = mDefCase27(test_case);

% Reading of flight data, definition of input/output variables for neural network 
% test_case = 27,  ATTAS quasi-steady stall -- longitudinal mode only
% Data pre-processing (computation of aerodynamic force and moment coefficients) 
%            inputs  - de, da, dr, p, q, r, al, be, V, rho, fnl, fnr, al/aldot, Mach
%            outputs - CD, CL, Cm, CY, Cl, Cn
% Aerodynamic modeling using FFNN 
%            inputs  - alpha, q, deltae, Mach  
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
d2r = pi/180;
r2d = 180/pi;

disp(['Test Case = ', num2str(test_case)]);
disp('Quasi-Steady stall ATTAS; Longitudinal motion')

%--------------------------------------------------------------------------
% Load flight data for Nzi time segments to be analyzed and concatenate 
load -ascii ..\flt_data\fAttas_qst01.asc;
load -ascii ..\flt_data\fAttas_qst02.asc;
data = [fAttas_qst01; fAttas_qst02];
dt   = 0.04;                           % sampling time
Nzi  = 2;
Nts1 = size(fAttas_qst01,1);
Nts2 = size(fAttas_qst02,1);
izhf = [Nts1; Nts1+Nts2];

% Observation variables CD, CY, CL, Cl, Cm, Cn (ax, ay, az, p, q, r)
ZAccel = [data(:, 2)      data(:, 3)      data(:, 4) ...
          data(:, 7)*d2r  data(:, 8)*d2r  data(:, 9)*d2r ];

% Input variables de, da, dr, p, q, r, al, be, V, rho, fnl, fnr, al/aldot, Mach
Uinp = [data(:,22)*d2r (data(:,29)-data(:,28))*0.5*d2r  data(:,30)*d2r ...
        data(:, 7)*d2r  data(:, 8)*d2r  data(:, 9)*d2r ...
        data(:,13)*d2r  data(:,14)*d2r  data(:,15) ...
        data(:,34)      data(:,37)      data(:,38) ...
        data(:,13)*d2r  data(:,31)];

% Compute aerodynamic force and moment coefficients
[Z, Uinp] = umr_reg_attas(ZAccel, Uinp, Nzi, izhf, dt, test_case);

% Normalization
lRef = 3.159;           % m  (wing chord), reference length for longitudinal motion
bRef = 10.75;           % m  (half the wing span), ref. length for lateral-directional
vtas = Uinp(:, 9);      % True airspeed
Uinp(:, 4) = Uinp(:, 4)*bRef./vtas;
Uinp(:, 5) = Uinp(:, 5)*lRef./vtas;
Uinp(:, 6) = Uinp(:, 6)*bRef./vtas;

%--------------------------------------------------------------------------
% drag, Lift  and pitching moment coefficients (CD, CL, Cm) as outputs 
Zout = [Z(:,1) Z(:,2) Z(:,3)];

% Input variables alpha, q, deltae, Mach, alpha-dot
Xin = [Uinp(:,7) Uinp(:,5) Uinp(:,1) Uinp(:,14) Uinp(:,13)];

%--------------------------------------------------------------------------
Nu = size(Xin,2);                      % Nu = number of inputs
Ny = size(Zout,2);                     % Ny = number of outputs

Ndata     = size(Xin,1);               % Number of data points for training
T         = [0:dt:Ndata*dt-dt]';       % Time vector (for plotting)
NdataPred = Ndata;                     % Number of data points for prediction

return  % end of function
