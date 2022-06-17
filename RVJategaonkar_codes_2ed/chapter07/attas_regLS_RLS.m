% attas_regLS_RLS
% 
% This program is applied to estimate parameters of CD, CY, CL, Cl, Cm, Cn.
% It is an extension of the program attasLS that was used in chapter 6,
% section 6.9.2. The first part of computing force and moment coefficients
% using the function umr_reg_attas is exactly the same. 
% The parameters are estimated by considering CD, CY, CL, Cl, Cm, Cn, one at a time.
% They are estimated applying LS method of Chapter 6 and RLS of Chapter 7.
% The LS estimation procedure is exactly the same as that of Chapter 6. 
% The procedure for RLS is appended here for each aerodynamic coefficient
% appropriately.
%
% Chapter 6, Section 6.9.2 (Least squares method - classical Normal equation), and 
% Chapter 7, Section 7.2.1 and 7.2.2 (Recursive least squares)
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% by Ravindra V. Jategaonkar
% published by AIAA, Reston, VA 20191, USA

disp(' ');
disp('ATTAS aircraft, longitudinal and lateral-directional motion')

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
Y = Z(:,1);
% Input variables vectorof1(1), al
X = [vectorof1  Uinp(:,7)];
% CDPar=inv(X'*X)*X'*Y;
CDPar = X\Y;
% Compute and print statistics of the estimates
disp(' ')
disp('Drag coefficient CD:');
disp('Classical LS with Normal Equation:')
[YCDhatLS, par_std, par_std_rel, R2Stat] = LS_Stat(X, Y, CDPar);

%--------------------------------------------------------------------------
% Recursive least squares with forgetting factor (Eqs. (7.16) to (7.18))

% Initial P matrix and forgetting factor
[Ndata, nparam] = size(X);
P0     = eye(nparam)*1.0e+06; 
lamda  = 1;	
theta0 = zeros (nparam,1);

% Estimate parameters by RLS algorithm
ThetaCD = RLSff(X, Y, lamda, P0, theta0);

% Compute and print statistics of the estimates
disp('Recursive least squares method:');
[YCDhatRLS, par_std, par_std_rel, R2Stat] = LS_Stat(X, Y, ThetaCD(Ndata,:)');

T  = [0:dt:Ndata*dt-dt]';
XL = T(end) + 5;
figure(1)
subplot(211),plot(T,ThetaCD(:,1), [0 XL],[CDPar(1,1) CDPar(1,1)]); grid; ylabel('CD0');
subplot(212),plot(T,ThetaCD(:,2), [0 XL],[CDPar(2,1) CDPar(2,1)]); grid; ylabel('CDalpha');
xlabel('Time in sec');  

%--------------------------------------------------------------------------
% Observation variable CL (Lift coefficient)
% y(2) = CL0 + CLal*al;
Y = Z(:,2);
% Input variables vectorof1(1), al
X = [vectorof1  Uinp(:,7)];
% CLPar=inv(X'*X)*X'*Y;
CLPar = X\Y;
% Compute and print statistics of the estimates
disp(' ')
disp('Lift coefficient CL:');
disp('Classical LS with Normal Equation:')
[YCLhatLS, par_std, par_std_rel, R2Stat] = LS_Stat(X, Y, CLPar);

%--------------------------------------------------------------------------
% Recursive least squares with forgetting factor (Eqs. (7.16) to (7.18))

% Initial P matrix and forgetting factor
[Ndata, nparam] = size(X);
P0     = eye(nparam)*1.0e+06; 
lamda  = 1;	
theta0 = zeros (nparam,1);

% Estimate parameters by RLS algorithm
ThetaCL = RLSff(X, Y, lamda, P0, theta0);

% Compute and print statistics of the estimates
disp('Recursive least squares method:');
[YCLhatRLS, par_std, par_std_rel, R2Stat] = LS_Stat(X, Y, ThetaCL(Ndata,:)');

figure(2)
subplot(211),plot(T,ThetaCL(:,1), [0 XL],[CLPar(1,1) CLPar(1,1)]); grid; ylabel('CL0');...
subplot(212),plot(T,ThetaCL(:,2), [0 XL],[CLPar(2,1) CLPar(2,1)]); grid; ylabel('CLalpha');
xlabel('Time in sec');  

%--------------------------------------------------------------------------
% Observation variable Cm (Pitching moment coefficient)
% y(3) = Cm0 + Cmal*al + Cmq*qn          + Cmde*de;
Y = Z(:,3);
% Input variables vectorof1(1), al, qn, de
X = [vectorof1  Uinp(:,7)  Uinp(:,5)  Uinp(:,1)];
% CmPar=inv(X'*X)*X'*Y;
CmPar = X\Y;
% Compute and print statistics of the estimates
disp (' ')
disp('Pitching moment coefficient Cm:');
disp('Classical LS with Normal Equation:')
[YCmhatLS, par_std, par_std_rel, R2Stat] = LS_Stat(X, Y, CmPar);

%--------------------------------------------------------------------------
% Recursive least squares with forgetting factor (Eqs. (7.16) to (7.18))

% Initial P matrix and forgetting factor
[Ndata, nparam] = size(X);
P0     = eye(nparam)*1.0e+7;
lamda  = 1;	
theta0 = zeros (nparam,1);
%theta0 = [4.0e-2  -4.0e-1  -5.0e+0  -5.0e-1]'

% Estimate parameters by RLS algorithm
ThetaCm = RLSff(X, Y, lamda, P0, theta0);

% Compute and print statistics of the estimates
disp('Recursive least squares method:');
[YCmhatRLS, par_std, par_std_rel, R2Stat] = LS_Stat(X, Y, ThetaCm(Ndata,:)');

figure(3)
subplot(411),plot(T,ThetaCm(:,1), [0 XL],[CmPar(1,1) CmPar(1,1)]); grid; ylabel('Cm0');
subplot(412),plot(T,ThetaCm(:,2), [0 XL],[CmPar(2,1) CmPar(2,1)]); grid; ylabel('Cm\alpha');
subplot(413),plot(T,ThetaCm(:,3), [0 XL],[CmPar(3,1) CmPar(3,1)]); grid; ylabel('Cmq');
subplot(414),plot(T,ThetaCm(:,4), [0 XL],[CmPar(4,1) CmPar(4,1)]); grid; ylabel('Cm\deltae');
xlabel('Time in sec');  

%--------------------------------------------------------------------------
% Observation variable CY (side force coefficient)
% y(4) = CY0 + CYbe*be;
Y = Z(:,4);
% Input variables vectorof1(1), be
X = [vectorof1  Uinp(:,8)];
% CYPar=inv(X'*X)*X'*Y;
CYPar = X\Y;
% Compute and print statistics of the estimates
disp(' ')
disp('Side force coefficient CY:');
disp('Classical LS with Normal Equation:')
[YCYhatLS, par_std, par_std_rel, R2Stat] = LS_Stat(X, Y, CYPar);

%--------------------------------------------------------------------------
% Recursive least squares with forgetting factor (Eqs. (7.16) to (7.18))

% Initial P matrix and forgetting factor
[Ndata, nparam] = size(X);
P0     = eye(nparam)*1.0e+06; 
lamda  = 1;	
theta0 = zeros (nparam,1);

% Estimate parameters by RLS algorithm
ThetaCY = RLSff(X, Y, lamda, P0, theta0);

% Compute and print statistics of the estimates
disp('Recursive least squares method:');
[YCYhatLS, par_std, par_std_rel, R2Stat] = LS_Stat(X, Y, ThetaCY(Ndata,:)');

T = [0:dt:Ndata*dt-dt]';
figure(4)
subplot(211),plot(T,ThetaCY(:,1), [0 XL],[CYPar(1,1) CYPar(1,1)]); grid; ylabel('CY0');
subplot(212),plot(T,ThetaCY(:,2), [0 XL],[CYPar(2,1) CYPar(2,1)]); grid; ylabel('CYbeta');
xlabel('Time in sec');  

%--------------------------------------------------------------------------
% Observation variable Cl (Rolling moment coefficient)
% y(4) = Cl0 + Clbe*be + Clp*pn + Clr*rn + Clda*da;
Y = Z(:,5);
% Input variables vectorof1(1), be, pn, rn, da
X = [vectorof1  Uinp(:,8)  Uinp(:,4)  Uinp(:,6)  Uinp(:,2)];
% ClPar=inv(X'*X)*X'*Y;
ClPar = X\Y;
% Compute and print statistics of the estimates
disp(' ')
disp('Rolling moment coefficient Cl:');
disp('Classical LS with Normal Equation:')
[YClhatLS, par_std, par_std_rel, R2Stat] = LS_Stat(X, Y, ClPar);

%--------------------------------------------------------------------------
% Recursive least squares with forgetting factor (Eqs. (7.16) to (7.18))

% Initial P matrix and forgetting factor
[Ndata, nparam] = size(X);
P0     = eye(nparam)*1.0e+06; 
lamda  = 1;	
theta0 = zeros (nparam,1);

% Estimate parameters by RLS algorithm
ThetaCl = RLSff(X, Y, lamda, P0, theta0);

% Compute and print statistics of the estimates
disp('Recursive least squares method:');
[YClhatRLS, par_std, par_std_rel, R2Stat] = LS_Stat(X, Y, ThetaCl(Ndata,:)');

figure(5)
subplot(511),plot(T,ThetaCl(:,1), [0 XL],[ClPar(1,1) ClPar(1,1)]); grid; ylabel('Cl0');
subplot(512),plot(T,ThetaCl(:,2), [0 XL],[ClPar(2,1) ClPar(2,1)]); grid; ylabel('Cl\beta');
subplot(513),plot(T,ThetaCl(:,3), [0 XL],[ClPar(3,1) ClPar(3,1)]); grid; ylabel('Clp');
subplot(514),plot(T,ThetaCl(:,4), [0 XL],[ClPar(4,1) ClPar(4,1)]); grid; ylabel('Clr');
subplot(515),plot(T,ThetaCl(:,5), [0 XL],[ClPar(5,1) ClPar(5,1)]); grid; ylabel('Cl\deltaa');
xlabel('Time in sec');  

%--------------------------------------------------------------------------
% Observation variable Cn (Yawing moment coefficient)
% y(6) = Cn0 + Cnbe*be + Cnp*pn + Cnr*rn + Cndr*dr;
Y = Z(:,6);
% Input variables vectorof1(1), be, pn, rn, dr
X = [vectorof1  Uinp(:,8)  Uinp(:,4)  Uinp(:,6)  Uinp(:,3)];
% LS estimates by solving Normal equation
% CnPar=inv(X'*X)*X'*Y;
CnPar = X\Y;
% Compute and print statistics of the estimates
disp(' ')
disp('Yawing moment coefficient Cn:');
disp('Classical LS with Normal Equation:')
[YCnhatLS, par_std, par_std_rel, R2Stat] = LS_Stat(X, Y, CnPar);


%--------------------------------------------------------------------------
% Recursive least squares with forgetting factor (Eqs. (7.16) to (7.18))

% Initial P matrix and forgetting factor
[Ndata, nparam] = size(X);
P0     = eye(nparam)*1.0e+06; 
lamda  = 1;	
theta0 = zeros (nparam,1);

% Estimate parameters by RLS algorithm
ThetaCn = RLSff(X, Y, lamda, P0, theta0);

% Compute and print statistics of the estimates
disp('Recursive least squares method:');
[YCnhatRLS, par_std, par_std_rel, R2Stat] = LS_Stat(X, Y, ThetaCn(Ndata,:)');

figure(6)
subplot(511),plot(T,ThetaCn(:,1), [0 XL],[CnPar(1,1) CnPar(1,1)]); grid; ylabel('Cn0');
subplot(512),plot(T,ThetaCn(:,2), [0 XL],[CnPar(2,1) CnPar(2,1)]); grid; ylabel('Cn\beta');
subplot(513),plot(T,ThetaCn(:,3), [0 XL],[CnPar(3,1) CnPar(3,1)]); grid; ylabel('Cnp');
subplot(514),plot(T,ThetaCn(:,4), [0 XL],[CnPar(4,1) CnPar(4,1)]); grid; ylabel('Cnr');
subplot(515),plot(T,ThetaCn(:,5), [0 XL],[CnPar(5,1) CnPar(5,1)]); grid; ylabel('Cn\deltar');
xlabel('Time in sec');  

%--------------------------------------------------------------------------
% Plot to generate figure 7.3
figure(7)
subplot(321),plot(T,ThetaCD(:,1), [0 XL],[CDPar(1,1) CDPar(1,1)]); grid;
             legend('C_{D0} RLS','        OLS',1);
subplot(323),plot(T,ThetaCL(:,1), [0 XL],[CLPar(1,1) CLPar(1,1)]); grid;
             legend('C_{L0} RLS','        OLS',1);
subplot(325),plot(T,ThetaCm(:,1), [0 XL],[CmPar(1,1) CmPar(1,1)]); grid;
             legend('C_{m0} RLS','        OLS',1);
xlabel('Time in sec');  
subplot(322),plot(T,ThetaCD(:,2), [0 XL],[CDPar(2,1) CDPar(2,1)]); grid;
             legend('C_{D\alpha} RLS','        OLS',1);
subplot(324),plot(T,ThetaCL(:,2), [0 XL],[CLPar(2,1) CLPar(2,1)]); grid;
             legend('C_{L\alpha} RLS','        OLS',1);
subplot(326),plot(T,ThetaCm(:,2), [0 XL],[CmPar(2,1) CmPar(2,1)]); grid;
             legend('C_{m\alpha} RLS','        OLS',1);
xlabel('Time in sec');  

% end of attas_RegLS_RLS
