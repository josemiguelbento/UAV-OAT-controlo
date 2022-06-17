function [Z, U] = umr_reg_hfb(ZAccel, U, Nzi, izhf, dtk, test_case)

% Data pre-processing: 
% Compute the drag, lift and pitching moment coefficients for HFB-320:
% Restricted to longitudinal motion only for data file 'hfb320_1_09.asc'.
%
% Chapter 8: Artificial Neural Networks
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA

%--------------------------------------------------------------------------
% Aircraft mass characteristics
Mass  = 7472.0;         % kg
sRef  = 30.097216;      % m2 (wing area)
lRef  = 2.43;           % m  (wing chord), reference length for longitudinal motion
siEng = 0.0524;         % Inclination angle of engines
iX    = 1.3336E+04;     % kgm2 (provisional value  --  to be verified)
iY    = 9.1420E+04;     % kgm2 (hfb320: SCBYIY = 8.00270D-4)
iZ    = 3.5959E+04;     % kgm2 (provisional value  --  to be verified)
iXZ   = 1.1442E+03;     % kgm2 (provisional value  --  to be verified)   

% bRef = 10.75;           % m  (half the wing span), ref. length for lateral-directional
% lambda = 7.22;          % -  aspect ratio

% location of AC (Aerodynamic Center - moment reference point) from CG
xCGAC = 0.02;
yCGAC = 0.01;
zCGAC = 0.12;
% location of AS (Accelerometer Sensor) from CG
xASCG =  0.0;           % The accelerometer locations are with w.r.t CG
yASCG =  0.0;
zASCG =  0.0;
% location of engine from CG
xENCG = -1.343;
yENCG =  2.990;
zENCG = -0.652;

%--------------------------------------------------------------------------
% Measured ax, ay, az, pDot, qDot, rDot:
axm  = ZAccel(:,1);
aym  = ZAccel(:,2);
azm  = ZAccel(:,3);
pDot = ZAccel(:,4);
qDot = ZAccel(:,5);
rDot = ZAccel(:,6);

% Input variables (Measured quantities)
deltaElv = U(:, 1);          % Elevator deflection
deltaAil = U(:, 2);          % Aileron deflection
deltaRud = U(:, 3);          % Rudder deflection
pm       = U(:, 4);          % roll rate
qm       = U(:, 5);          % pitch rate
rm       = U(:, 6);          % yaw rate
alfam    = U(:, 7);          % angle of attack
betam    = U(:, 8);          % angle of sideslip
vtas     = U(:, 9);          % True airspeed 
qbar     = U(:,10);          % Dynamic pressure
FengL    = U(:,11);          % engine thrust, left 
FengR    = U(:,12);          % engine thrust, right

% Correct measured accelerations and angular rates for measurement biases:
b_ax =  0;  b_ay =  0;  b_az =  0;     % biases in ax, ay, az
b_p  =  0;  b_q  =  0;  b_r  =  0;     % biases in p, q, r
ax   = axm - b_ax;
ay   = aym - b_ay;
az   = azm - b_az;
p    = pm  - b_p;
q    = qm  - b_q;
r    = rm  - b_r;

% Correct measured flow angles for errors in scale factor and bias
D_Alfa = 0.0;
F_Alfa = 1.0;
D_Beta = 0.0;
F_Beta = 1.0;
al     = (alfam - D_Alfa)/F_Alfa; 
be     = (betam - D_Beta)/F_Beta;  

% Dynamic pressure
rho  = 0.792;                % density of air 
qbar = 0.5*rho.*vtas.*vtas;  % dynamic pressure; or measured qbar u(10) can be used 

%--------------------------------------------------------------------------
% Forces and moments due to engine
FengS = FengL + FengR;                 % Total thrust
FengD = FengL - FengR;                 % Asymmetric thrust
xTW =  FengS*cos(siEng);
yTW =  0;
zTW = -FengS*sin(siEng);
mTW =  FengS*cos(siEng)*zENCG + FengS*sin(siEng)*xENCG;

%--------------------------------------------------------------------------
% Accelerations at CG:
% axCG = axm + xASCG.*(q.*q+r.*r) - yASCG.*(p.*q-rDot) - zASCG.*(p.*r+qDot);
% ayCG = aym - xASCG.*(p.*q+rDot) + yASCG.*(r.*r+p.*p) - zASCG.*(q.*r-pDot);
% azCG = azm - xASCG.*(p.*r-qDot) - yASCG.*(q.*r+pDot) + zASCG.*(p.*p+q.*q);
% In the present case the accelerations w.r.t CG are stored.
axCG = ax;
ayCG = ay;
azCG = az;

%--------------------------------------------------------------------------
% Body axes force coefficients:
CX = (Mass*axCG - xTW)./(qbar*sRef);
CZ = (Mass*azCG - zTW)./(qbar*sRef);

% Lift, drag and side force coefficients:
CD = -CX.*cos(al) - CZ.*sin(al);
CL =  CX.*sin(al) - CZ.*cos(al);

% Body-axes rolling, pitching and yawing coefficients referred to CG:
CM_CG = ( iY.*qDot + (p.*p -r.*r).*iXZ  - p.*r.*(iZ-iX) - mTW ) ./(qbar*sRef*lRef);

% Moment coefficients referred to aerodynamic center (moment reference point):
CM_AC = CM_CG + CX.*zCGAC/lRef - CZ.*xCGAC/lRef;

%--------------------------------------------------------------------------
% Load aerodynamic forces and moment in Z
Z(:,1) = CD;
Z(:,2) = CL;
Z(:,3) = CM_AC;

return
% end of function
