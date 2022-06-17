function [Nu, Ny, Ndata, NdataPred, dt, T, Xin, Zout] = mDefCase23(test_case);

% Definition of model, flight data, initial values etc. 
% test_case = 23 -- Estimation of aerodynamic parameters by least squares method
%                   Linear model and multiple time segments (NZI=3),
%                   Longitudinal and lateral-directional motion
%                   states  - --
%                   outputs - CD, CL, Cm, CY, Cl, Cn (Aero coefficients)
%                   inputs  - de, da, dr, p, q, r, al, be, V, rho, fnl, fnr
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
disp('ATTAS: Aerodynamic model pertaining to lateral-directional motion')

%--------------------------------------------------------------------------
% Load flight data for Nzi time segments to be analyzed and concatenate 
load ..\flt_data\fAttasElv1;
load ..\flt_data\fAttasAil1;
load ..\flt_data\fAttasRud1;
Nzi   = 3;
data  = [fAttasElv1; fAttasAil1; fAttasRud1];
Nts1  = size(fAttasElv1,1);
Nts2  = size(fAttasAil1,1);
Nts3  = size(fAttasRud1,1);
izhf  = [Nts1; Nts1+Nts2; Nts1+Nts2+Nts3];

Ndata = size(data,1);
dt    = 0.04;                           % sampling time

% Observation variables CD, CY, CL, Cl, Cm, Cn (ax, ay, az, p, q, r)
ZAccel = [data(:, 2)       data(:, 3)       data(:, 4)...
          data(:, 7)*d2r   data(:, 8)*d2r   data(:, 9)*d2r ];
    
% Input variables de, da, dr, p, q, r, al, be, V, rho, fnl, fnr, al/aldot, Mach
Uinp = [data(:,22)*d2r (data(:,29)-data(:,28))*0.5*d2r  data(:,30)*d2r...
        data(:, 7)*d2r  data(:, 8)*d2r  data(:, 9)*d2r...
        data(:,13)*d2r  data(:,14)*d2r  data(:,15)...
        data(:,34)      data(:,37)      data(:,38)...
        data(:,13)*d2r  data(:,31) ];

% Data pre-processing to compute aerodynamic force and moment coefficients
[Z, Uinp] = umr_reg_attas(ZAccel, Uinp, Nzi, izhf, dt, test_case);

% Normalization
lRef = 3.159;           % m  (wing chord), reference length for longitudinal motion
bRef = 10.75;           % m  (half the wing span), ref. length for lateral-directional
vtas = Uinp(:, 9);      % True airspeed
Uinp(:, 4) = Uinp(:, 4)*bRef./vtas;
Uinp(:, 5) = Uinp(:, 5)*lRef./vtas;
Uinp(:, 6) = Uinp(:, 6)*bRef./vtas;

%--------------------------------------------------------------------------
% Output variables CY, Cl, Cn (side force, rolling and yawing moment coefficients)
Zout = [Z(:,4)  Z(:,5)  Z(:,6)];

% Input variables beta, pn, rn, da, dr
Xin  = [Uinp(:,8)  Uinp(:,4)  Uinp(:,6)  Uinp(:,2)  Uinp(:,3)];

%--------------------------------------------------------------------------
Nu = size(Xin,2);                      % Nu = number of inputs
Ny = size(Zout,2);                     % Ny = number of outputs

Ndata     = size(Xin,1);               % Number of data points for training
T         = [0:dt:Ndata*dt - dt]';     % Time vector (for plotting)
NdataPred = Ndata;                     % Number of data points for prediction

