% attas_regLS
%
% Chapter 6, Equation Error Methods
% Flight Vehicle System Identification - A Time Domain Methodology
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA
%
% Least squares method - classical Normal equation:
%
% This is a separate program to compute the LS estimates:
% The Normal equation is to be solved analytically once for each output; 
% in the present case there are six outputs, CD, CY, CL, Cl, Cm, Cn.
% The aerodynamic force and moment coefficients are obtained through
% the pre-processing function umr_reg_attas.
% This is the equivalent of test_case 23 /FVSysID/chapter04/ml_oem.
% Presently for three time slices with elevator, aileron and rudder inputs.

disp(' ');
disp('ATTAS aircraft, longitudinal and lateral-directional motion')
disp('Classical LS with Normal Equation:')

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
time  = [0:dt:Ndata*dt-dt]';            % time

test_case = 23;

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

% Unit vector as additonsl input to estimate zero aerodynamic terms
vectorof1 = ones(Ndata,1);

%--------------------------------------------------------------------------
% Observation variable CD (Drag coefficient)
% y(1) = CD0 + CDal*al;
YCD = Z(:,1);
% Input variables vectorof1(1), al
XCD = [vectorof1  Uinp(:,7)];
% CDPar=inv(XCD'*XCD)*XCD'*YCD;
CDPar = XCD\YCD;
% Compute and print statistics of the estimates
disp(' ')
disp('Drag coefficient CD:');
[YCDhat, par_std, par_std_rel, R2Stat] = LS_Stat(XCD, YCD, CDPar);

%--------------------------------------------------------------------------
% Observation variable CL (Lift coefficient)
% y(2) = CL0 + CLal*al;
YCL = Z(:,2);
% Input variables vectorof1(1), al
XCL = [vectorof1  Uinp(:,7)];
% CLPar=inv(XCL'*XCL)*XCL'*YCL;
CLPar = XCL\YCL;
% Compute and print statistics of the estimates
disp(' ')
disp('Lift coefficient CL:');
[YCLhat, par_std, par_std_rel, R2Stat] = LS_Stat(XCL, YCL, CLPar);

%--------------------------------------------------------------------------
% Observation variable Cm (Pitching moment coefficient)
% y(3) = Cm0 + Cmal*al + Cmq*qn          + Cmde*de;
YCm = Z(:,3);
% Input variables vectorof1(1), al, qn, de
XCm = [vectorof1  Uinp(:,7)  Uinp(:,5)  Uinp(:,1)];
% CmPar=inv(XCm'*XCm)*XCm'*YCm;
CmPar = XCm\YCm;
% Compute and print statistics of the estimates
disp(' ')
disp('Pitching moment coefficient Cm:');
[YCmhat, par_std, par_std_rel, R2Stat] = LS_Stat(XCm, YCm, CmPar);

%--------------------------------------------------------------------------
% Observation variable CY (side force coefficient)
% y(4) = CY0 + CYbe*be;
YCY = Z(:,4);
% Input variables vectorof1(1), be
XCY = [vectorof1  Uinp(:,8)];
% CYPar=inv(XCY'*XCY)*XCY'*YCY;
CYPar = XCY\YCY;
% Compute and print statistics of the estimates
disp(' ')
disp('Side force coefficient CY:');
[YCYhat, par_std, par_std_rel, R2Stat] = LS_Stat(XCY, YCY, CYPar);

%--------------------------------------------------------------------------
% Observation variable Cl (Rolling moment coefficient)
% y(4) = Cl0 + Clbe*be + Clp*pn + Clr*rn + Clda*da;
YCl = Z(:,5);
% Input variables vectorof1(1), be, pn, rn, da
XCl = [vectorof1  Uinp(:,8)  Uinp(:,4)  Uinp(:,6)  Uinp(:,2)];
% ClPar=inv(XCl'*XCl)*XCl'*YCl;
ClPar = XCl\YCl;
% Compute and print statistics of the estimates
disp(' ')
disp('Rolling moment coefficient Cl:');
[YClhat, par_std, par_std_rel, R2Stat] = LS_Stat(XCl, YCl, ClPar);

%--------------------------------------------------------------------------
% Observation variable Cn (Yawing moment coefficient)
% y(6) = Cn0 + Cnbe*be + Cnp*pn + Cnr*rn + Cndr*dr;
YCn = Z(:,6);
% Input variables vectorof1(1), be, pn, rn, dr
XCn = [vectorof1  Uinp(:,8)  Uinp(:,4)  Uinp(:,6)  Uinp(:,3)];
% LS estimates by solving Normal equation
% CnPar=inv(XCn'*XCn)*XCn'*YCn;
CnPar = XCn\YCn;
% Compute and print statistics of the estimates
disp(' ')
disp('Yawing moment coefficient Cn:');
[YCnhat, par_std, par_std_rel, R2Stat] = LS_Stat(XCn, YCn, CnPar);


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%Plot time histories of computed (measured) and estimated variables
figure(1)
subplot(611),plot(time,YCD(:,1),'b', time,YCDhat(:,1),'r'); grid; ylabel('CD ()');
title('Time histories of output variables (measured and estimated)')
subplot(612),plot(time,YCL(:,1),'b', time,YCLhat(:,1),'r'); grid; ylabel('CL (-)');
subplot(613),plot(time,YCm(:,1),'b', time,YCmhat(:,1),'r'); grid; ylabel('Cm_{AC} (-)');
subplot(614),plot(time,YCY(:,1),'b', time,YCYhat(:,1),'r'); grid; ylabel('CY (-)');
subplot(615),plot(time,YCl(:,1),'b', time,YClhat(:,1),'r'); grid; ylabel('Cl_{AC} (-)');
subplot(616),plot(time,YCn(:,1),'b', time,YCnhat(:,1),'r'); grid; ylabel('Cn_{AC} (-)');
xlabel('Time in sec'); 
