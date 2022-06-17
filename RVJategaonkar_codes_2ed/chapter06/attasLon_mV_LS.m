% attasLon_multivariateLS
%
% Flight Vehicle System Identification - A Time Domain Methodology
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA
%
% Chapter 6, Section 6.9.2
% Multivariate linear regression: Analytical solution
%
% The multivariate linear regression is applicable to multiple outputs
% (dependent variables). It is based on the assumption that all the dependent
% variables are functions of the same set of independent variables.
%
% This is a test case for longitudinal motion, with three dependent
% variables namely CD, CL, and Cm. These aerodynamic coefficients are
% functions of (constant1, al, qn, de). 
% If these aerodynamic coefficients are not functions of the same set of
% independent variables, then it is necessary to process each of them
% separately. This is done using the program attas_regLS.m

disp(' ');
disp('ATTAS aircraft, longitudinal and lateral-directional motion')
disp('Multivariate LS with Normal Equation:')

d2r   = pi/180;
r2d   = 180/pi;

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

test_case = 23;

% Observation variables CD, CY, CL, Cl, Cm, Cn (ax, ay, az, p, q, r)
ZAccel = [data(:, 2)       data(:, 3)       data(:, 4)...
          data(:, 7)*d2r   data(:, 8)*d2r   data(:, 9)*d2r ];
    
% Input variables de, da, dr, p, q, r, al, be, V, rho, fnl, fnr
Uinp = [data(:,22)*d2r (data(:,29)-data(:,28))*0.5*d2r  data(:,30)*d2r...
        data(:, 7)*d2r  data(:, 8)*d2r  data(:, 9)*d2r...
        data(:,13)*d2r  data(:,14)*d2r  data(:,15)...
        data(:,34)      data(:,37)      data(:,38) ];

% Data pre-processing to compute aerodynamic force and moment coefficients
[Z, Uinp] = umr_reg_attas(ZAccel, Uinp, Nzi, izhf, dt, test_case);


% Normalization
lRef = 3.159;           % m  (wing chord), reference length for longitudinal motion
bRef = 10.75;           % m  (half the wing span), ref. length for lateral-directional
vtas = Uinp(:, 9);      % True airspeed
Uinp(:, 4) = Uinp(:, 4)*bRef./vtas;
Uinp(:, 5) = Uinp(:, 5)*lRef./vtas;
Uinp(:, 6) = Uinp(:, 6)*bRef./vtas;

% Unit vector as additonsl input to estimate zero aerodynamic terms
vectorof1 = ones(Ndata,1);

%--------------------------------------------------------------------------
% Multivariate linear regression
% Three Observation variables CD, CL, Cm (Longitudinal motion)
% y(:,1) = CD0 + CDal*al + CDq*qn + CDde*de;
% y(:,2) = CL0 + CLal*al + CLq*qn + CLde*de;
% y(:,3) = Cm0 + Cmal*al + Cmq*qn + Cmde*de;
Y3 = [Z(:,1)  Z(:,2)  Z(:,3)];

% Input variables vectorof1(1), al, qn, de (same set for all three outputs)
X3 = [vectorof1  Uinp(:,7)  Uinp(:,5)  Uinp(:,1)];

% LS estimates by solving Normal equations
C3Par = X3\Y3;
disp('');
disp('Multivariate linear regression');
disp('Aerodynamic force and moment coefficients CD, CL, and Cm:');
% Compute and print statistics of the estimates
[par_std, par_std_rel, R2Stat] = LS_Stat(X3, Y3, C3Par);


%--------------------------------------------------------------------------
disp(' ');
disp('Verification by treating the three dependent variables separately:')
% To verify MMR run the same problem by treating three dependent variables separately.

% Input variables vectorof1(1), al, qn, de (same set for all three outputs)
X = [vectorof1  Uinp(:,7)  Uinp(:,5)  Uinp(:,1)];

% Observation variable CD (Drag coefficient)
% y(1) = CD0 + CDal*al + CDde*de;
Y = Z(:,1);
% LS estimates by solving Normal equation
CDPar = X\Y;
% Compute and print statistics of the estimates
disp('Drag coefficient CD:');
[par_std, par_std_rel, R2Stat] = LS_Stat(X, Y, CDPar);

% Observation variable CL (Lift coefficient)
% y(2) = CL0 + CLal*al + CLde*de;
Y = Z(:,2);
% LS estimates by solving Normal equation
CLPar = X\Y;
% Compute and print statistics of the estimates
disp('Lift coefficient CL:');
[par_std, par_std_rel, R2Stat] = LS_Stat(X, Y, CLPar);

% Observation variable Cm (Pitching moment coefficient)
% y(3) = Cm0 + Cmal*al + Cmq*qn + Cmde*de;
Y = Z(:,3);
% LS estimates by solving Normal equation
CmPar = X\Y;
% Compute and print statistics of the estimates
disp('Pitching moment coefficient Cm:');
[par_std, par_std_rel, R2Stat] = LS_Stat(X, Y, CmPar);

