% attasLonLat_mV_TLS
%
% Flight Vehicle System Identification - A Time Domain Methodology
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA
%
% Chapter 6, Section 6.9.2
% Multivariate Total Least Squares: Analytical solution
%
% The multivariate total least squares is applicable to multiple outputs
% (dependent variables). It is based on the assumption that all the dependent
% variables are functions of the same set of independent variables.
%
% This is a test case for longitudinal and lateral directional motion, 
% with six dependent variables namely CD, CL, Cm, Cy, Cl, Cn. 
% These aerodynamic coefficients are functions of the same set of independent
% variables: (constant1, al, qn, de,be, pn, rn, da, dr). 
% If these aerodynamic coefficients are not functions of the same set of
% independent variables, then it is necessary to process each of them
% separately. This is done using the program attas_regTLS.m

disp(' ');
disp('ATTAS aircraft, longitudinal and lateral-directional motion')
disp('Multivariate Total Least Squares:')

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
% Six Observation variables CD, CL, Cm, CY, Cl, Cn
% y(:,1) = CD0+CDal*al+CDq*qn+CDde*de + CDbe*be+CDp*pn+CDr*rn+CDda*da+CDdr*dr;
% y(:,2) = CL0+CLal*al+CLq*qn+CLde*de + CLbe*be+CLp*pn+CLr*rn+CLda*da+CLdr*dr;
% y(:,3) = Cm0+Cmal*al+Cmq*qn+Cmde*de + Cmbe*be+Cmp*pn+Cmr*rn+Cmda*da+Cmdr*dr;
% y(:,4) = CY0+CYal*al+CYq*qn+CYde*de + CYbe*be+CYp*pn+CYr*rn+CYda*da+CYdr*dr;
% y(:,5) = Cl0+Clal*al+Clq*qn+Clde*de + Clbe*be+Clp*pn+Clr*rn+Clda*da+Cldr*dr;
% y(:,6) = Cn0+Cnal*al+Cnq*qn+Cnde*de + Cnbe*be+Cnp*pn+Cnr*rn+Cnda*da+Cndr*dr;
Y6 = [Z(:,1)  Z(:,2)  Z(:,3)  Z(:,4)  Z(:,5)  Z(:,6)];

% Input variables vectorof1(1), al, qn, de be, pn, rn, da, dr
X6 = [vectorof1  Uinp(:,7)  Uinp(:,5)  Uinp(:,1) ...
                 Uinp(:,8)  Uinp(:,4)  Uinp(:,6)  Uinp(:,2)  Uinp(:,3)];

nq  = size(X6,2);
nq1 = nq + 1;
XYcomp = [X6 Z];                    % Composed data matrix
[ue,se,ve] = svd(XYcomp,0);         % Compute svd - economy: only for first n columns of ue
C6Par = -( inv(ve(nq1:end,nq1:end))' * ve(1:nq,nq1:end)' )';
disp('Multivariate Total Least Squares');
disp('Aerodynamic force and moment coefficients CD, CL, Cm, Cy, Cl, and Cn:');
[par_std, par_std_rel, R2Stat] = LS_Stat(X6, Z, C6Par);

%--------------------------------------------------------------------------
disp(' ');
disp('Verification by treating the six dependent variables separately:')
disp('Caveat: The Multivariate TLS estimates will not be same as those')
disp('        provided by univariate TLS.')
% To verify MMR run the same problem by treating six dependent variables separately.

% Input variables vectorof1(1), al, qn, de (same set for all three outputs)
X  = [vectorof1  Uinp(:,7)  Uinp(:,5)  Uinp(:,1) ...
                 Uinp(:,8)  Uinp(:,4)  Uinp(:,6)  Uinp(:,2)  Uinp(:,3)];

nq  = size(X,2);
nq1 = nq + 1;

% Observation variable CD (Drag coefficient)
% y = CD0 + CDal*al + CDq*qn + CDde*de + CDbe*be + CDp*pn + CDr*rn + CDda*da + CDdr*dr;
Y = Z(:,1);
XYcomp = [X Y];                     % Composed data matrix
[ue,se,ve] = svd(XYcomp,0);         % Compute svd - economy: only for first n columns of ue
CDPar = -(ve(1:nq,nq1)/ve(nq1,nq1));
disp('Drag coefficient CD:');
[par_std, par_std_rel, R2Stat] = LS_Stat1(X, Y, CDPar);

% Observation variable CL (Lift coefficient)
% y = CL0 + CLal*al + CLq*qn + CLde*de + CLbe*be + CLp*pn + CLr*rn + CLda*da + CLdr*dr;
Y = Z(:,2);
XYcomp = [X Y];                     % Composed data matrix
[ue,se,ve] = svd(XYcomp,0);         % Compute svd - economy: only for first n columns of ue
CLPar = -(ve(1:nq,nq1)/ve(nq1,nq1));
disp('Lift coefficient CL:');
[par_std, par_std_rel, R2Stat] = LS_Stat(X, Y, CLPar);

% Observation variable Cm (Pitching moment coefficient)
% y = Cm0 + Cmal*al + Cmq*qn + Cmde*de + Cmbe*be + Cmp*pn + Cmr*rn + Cmda*da + Cmdr*dr;
Y = Z(:,3);
XYcomp = [X Y];                     % Composed data matrix
[ue,se,ve] = svd(XYcomp,0);         % Compute svd - economy: only for first n columns of ue
CmPar = -(ve(1:nq,nq1)/ve(nq1,nq1));
disp('Pitching moment coefficient Cm:');
[par_std, par_std_rel, R2Stat] = LS_Stat(X, Y, CmPar);

% Observation variable CY (side force coefficient)
% y = CY0 + CYal*al + CYq*qn + CYde*de + CYbe*be + CYp*pn + CYr*rn + CYda*da + CYdr*dr;
Y = Z(:,4);
XYcomp = [X Y];                     % Composed data matrix
[ue,se,ve] = svd(XYcomp,0);         % Compute svd - economy: only for first n columns of ue
CYPar = -(ve(1:nq,nq1)/ve(nq1,nq1));
disp('Side force coefficient CY:');
[par_std, par_std_rel, R2Stat] = LS_Stat(X, Y, CYPar);

% Observation variable Cl (Rolling moment coefficient)
% y = Cl0 + Clal*al + Clq*qn + Clde*de + Clbe*be + Clp*pn + Clr*rn + Clda*da + Cldr*dr;
Y = Z(:,5);
XYcomp = [X Y];                     % Composed data matrix
[ue,se,ve] = svd(XYcomp,0);         % Compute svd - economy: only for first n columns of ue
ClPar = -(ve(1:nq,nq1)/ve(nq1,nq1));
disp('Rolling moment coefficient Cl:');
[par_std, par_std_rel, R2Stat] = LS_Stat(X, Y, ClPar);


% Observation variable Cn (Yawing moment coefficient)
% y = Cn0+Cnal*al+Cnq*qn+Cnde*de + Cnbe*be+Cnp*pn+Cnr*rn+Cnda*da+Cndr*dr;
Y = Z(:,6);
XYcomp = [X Y];                     % Composed data matrix
[ue,se,ve] = svd(XYcomp,0);         % Compute svd - economy: only for first n columns of ue
CnPar = -(ve(1:nq,nq1)/ve(nq1,nq1));
disp('Yawing moment coefficient Cn:');
[par_std, par_std_rel, R2Stat] = LS_Stat(X, Y, CnPar);
