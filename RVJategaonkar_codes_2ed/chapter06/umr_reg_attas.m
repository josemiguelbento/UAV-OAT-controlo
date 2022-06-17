function [Z, U] = umr_reg_attas(ZAccel, U, Nzi, izhf, dtk, test_case)

% Data pre-processing: 
% Compute aerodynamic force and moment coefficients referred to aerodynamic
% center (moment reference point) from measured accelerations and angular rates.
%
% Chapter 6, Equation Error Methods
% Flight Vehicle System Identification - A Time Domain Methodology
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA


% Aircraft mass characteristics
Mass   = 17631;           % kg
iX     = 1.33367E+05;     % kgm2
iY     = 2.52687E+05;     % kgm2
iZ     = 3.59593E+05;     % kgm2
iXZ    = 1.14420E+04;     % kgm2
sRef   = 64.0;            % m2 (wing area)
lRef   = 3.159;           % m  (wing chord), reference length for longitudinal motion
bRef   = 10.75;           % m  (half the wing span), ref. length for lateral-directional
lambda = 7.22;            % -  aspect ratio
siEng  = 0;               % Inclination angle of engines

% location of AC (Aerodynamic Center - moment reference point) from CG
xACCG = -0.02;
yACCG = -0.01;
zACCG = -0.12;
% location of AS (Accelerometer Sensor) from CG
xASCG = -1.010;
yASCG =  0.886;
zASCG =  0.103;
% location of engine from CG
xENCG = -1.343;
yENCG =  2.990;
zENCG = -0.652;

% Measured ax, ay, az, pdot, qdot, rdot (p,q,r to be diffeentiated):
axm = ZAccel(:,1);
aym = ZAccel(:,2);
azm = ZAccel(:,3);
pm  = ZAccel(:,4);
qm  = ZAccel(:,5);
rm  = ZAccel(:,6);

% Specify bias corrections for measured ax, ay, az, p, q, r:
if  test_case == 23 | test_case == 24,
    % ATTAS longitudinal and lateral motion: stored data is not corrected for biases
    % Following corrections are obtained by running ml_oem for test_case = 22.
    % First run with bias parameters only (1st edition):
    % b_ax =  9.23669e-003;  b_ay =  2.09408e-004;  b_az =  9.60082e-002;
    % b_p  =  1.08375e-003;  b_q  =  3.33630e-003;  b_r  =  1.00300e-003;
    % Second run with bias parameters and initial conditions (2nd Edition)
    b_ax =  6.76242e-003;  b_ay = -1.50664e-003;  b_az =  8.39892e-002;
    b_p  =  1.02555e-003;  b_q  =  3.40891e-003;  b_r  =  9.96192e-004;
elseif test_case == 27,
    % ATTAS stall data: the stored data is already corrected for bias errors
    b_ax =  0;  b_ay =  0;  b_az =  0;
    b_p  =  0;  b_q  =  0;  b_r  =  0;
end

% Correct measured accelerations and angular rates for measurement biases:
ax = axm - b_ax;
ay = aym - b_ay;
az = azm - b_az;
p  = pm  - b_p;
q  = qm  - b_q;
r  = rm  - b_r;

% Input variables
D_Alfa = 0.0;
F_Alfa = 1.0;
D_Beta = 0.0;
F_Beta = 1.0;
alNB   = (U(:,7) - D_Alfa)/F_Alfa;          % Angle of attack at Noseboom
beNB   = (U(:,8) - D_Beta)/F_Beta;          % Angle of sideslip at Noseboom
vtasNB = U(:, 9);                           % True airspeed at Noseboom
rho    = U(:,10);                           % density of air
FengL  = U(:,11);                           % engine thrust, left 
FengR  = U(:,12);                           % engine thrust, right

% Compute flow variables at CG from measured flow variables at Noseboom:
if  test_case == 23 | test_case == 24,
    xNBCG = 13.080;                         % Location of noseboom from CG
    yNBCG =-0.010;
    zNBCG =-0.027;
    uNB   = vtasNB.*cos(beNB).*cos(alNB);
    vNB   = vtasNB.*sin(beNB);
    wNB   = vtasNB.*cos(beNB).*sin(alNB);
    uCG   = uNB + yNBCG.*r - zNBCG.*q;
    vCG   = vNB + zNBCG.*p - xNBCG.*r;
    wCG   = wNB + xNBCG.*q - yNBCG.*p;
    vtas  = sqrt(uCG.^2 + vCG.^2 + wCG.^2);
    al    = atan(wCG./uCG);
    be    = asin(vCG./vtas);
elseif test_case == 27,
    % ATTAS stall model, the stored flow variables are already w.r.t CG
    al   = alNB; 
    be   = beNB;
    vtas = vtasNB;
end

% Filter the flow variables and store
al   = smoothMulTS(al,   Nzi, izhf); 
be   = smoothMulTS(be,   Nzi, izhf); 
vtas = smoothMulTS(vtas, Nzi, izhf); 

U(:,7) = al;                            % overwrite u(7): Angle of attack at CG
U(:,8) = be;                            % overwrite u(8): Angle of sideslip at CG
U(:,9) = vtas;                          % overwrite u(9): True airspeed at CG

% Dynamic pressure
qbar   = 0.5*rho.*vtas.*vtas;           % dynamic pressure

% Generate alDot by differentiation of al
alDot = ndiff_Filter08(al, Nzi, izhf, dtk); 
U(:,13) = alDot;

% Forces due to landing gear at CG (presently zero for in-air data with gear in)
xLG  = 0;
yLG  = 0;
zLG  = 0;
lLG  = 0; 
mLG  = 0; 
nLG  = 0; 

% Forces and moments due to engine
FengS =  FengL + FengR;                 % Total thrust
FengD =  FengL - FengR;                 % Asymmetric thrust
xTW   =  FengS*cos(siEng);
yTW   =  0;
zTW   = -FengS*sin(siEng);
lTW   =  FengD*sin(siEng)*yENCG;
mTW   =  FengS*cos(siEng)*zENCG + FengS*sin(siEng)*xENCG;
nTW   =  FengD*cos(siEng)*yENCG;

% pdot, qdot, rdot by differentiation of p, q, r:
pSm  = smoothMulTS(p, Nzi, izhf);                % filter signals before diff
qSm  = smoothMulTS(q, Nzi, izhf); 
rSm  = smoothMulTS(r, Nzi, izhf); 
pDot = ndiff_Filter08(pSm, Nzi, izhf, dtk);      % numerical differentiation
qDot = ndiff_Filter08(qSm, Nzi, izhf, dtk); 
rDot = ndiff_Filter08(rSm, Nzi, izhf, dtk); 

% Accelerations at CG:
axCG = ax + xASCG.*(q.*q+r.*r) - yASCG.*(p.*q-rDot) - zASCG.*(p.*r+qDot);
ayCG = ay - xASCG.*(p.*q+rDot) + yASCG.*(r.*r+p.*p) - zASCG.*(q.*r-pDot);
azCG = az - xASCG.*(p.*r-qDot) - yASCG.*(q.*r+pDot) + zASCG.*(p.*p+q.*q);

% Body axes force coefficients:
CX = (Mass*axCG - xTW - xLG)./(qbar*sRef);
CY = (Mass*ayCG       - yLG)./(qbar*sRef);
CZ = (Mass*azCG - zTW - zLG)./(qbar*sRef);

% Lift, drag and side force coefficients:
CD = -CX.*cos(al) - CZ.*sin(al);
CL =  CX.*sin(al) - CZ.*cos(al);
CY =  CY;

% Body-axes rolling, pitching and yawing coefficients referred to CG:
CL_CG = ( iX.*pDot - iXZ.*rDot - iXZ.*p.*q - (iY-iZ).*q.*r...
                                           - lTW - lLG ) ./(qbar*sRef*bRef);
CM_CG = ( iY.*qDot + (p.*p -r.*r).*iXZ     - p.*r.*(iZ-iX)...
                                           - mTW - mLG ) ./(qbar*sRef*lRef);
CN_CG = ( iZ.*rDot - iXZ.*pDot + iXZ.*q.*r - (iX-iY).*p.*q...
                                           - nTW - nLG ) ./(qbar*sRef*bRef);

% Moment coefficients referred to aerodynamic center (moment reference point):
CL_AC = CL_CG - CZ.*yACCG/bRef + CY.*zACCG/bRef;
CM_AC = CM_CG - CX.*zACCG/lRef + CZ.*xACCG/lRef;
CN_AC = CN_CG - CY.*xACCG/bRef + CX.*yACCG/bRef;

if  test_case == 23 | test_case == 24,
    Z(:,1) = CD;             % Longitudinal
    Z(:,2) = CL;
    Z(:,3) = CM_AC;
    Z(:,4) = CY;             % Lateral
    Z(:,5) = CL_AC;
    Z(:,6) = CN_AC;
    
elseif (test_case == 27),
    Z(:,1) = CD;             % Longitudinal only
    Z(:,2) = CL;
    Z(:,3) = CM_AC;
end

return
% end of function
