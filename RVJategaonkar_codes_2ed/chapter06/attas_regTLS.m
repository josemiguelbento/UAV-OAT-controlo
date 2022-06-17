% attas_regTLS
%
% Chapter 6, Equation Error Methods
% Flight Vehicle System Identification - A Time Domain Methodology
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA
%
% Total least squares method:
%
% This is a separate program to compute the TLS estimates.
% It is very similar to attas_regLS, except that we apply now TLS.

disp(' ');
disp('ATTAS aircraft, longitudinal and lateral-directional motion')
disp('Classical TLS with analytic solution using SVD:')

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

% Observation variables ax, ay, az, p, q, r  ==> CD, CY, CL, Cl, Cm, Cn
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
% Observation variable CD (Drag coefficient)
% y(1) = CD0 + CDal*al;
YCD = Z(:,1);
% Input variables vectorof1(1), al
XCD = [vectorof1  Uinp(:,7)];
np  = size(XCD,2);
np1 = np + 1;

% TLS estimates by svd
XYcomp = [XCD YCD];               % Composed data matrix
[ue,se,ve] = svd(XYcomp,0);       % Compute svd - economy: only for first n columns of ue
CDPar = -(ve(1:np,np1)/ve(np1,np1));

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
np  = size(XCL,2);
np1 = np + 1;

% TLS estimates by svd
XYcomp = [XCL YCL];               % Composed data matrix
[ue,se,ve] = svd(XYcomp,0);       % Compute svd - economy: only for first n columns of ue
CLPar = -(ve(1:np,np1)/ve(np1,np1));

% Compute and print statistics of the estimates
disp(' ')
disp('Lift coefficient CL:');
[YCLhat, par_std, par_std_rel, R2Stat] = LS_Stat(XCL, YCL, CLPar);

%--------------------------------------------------------------------------
% Observation variable Cm (Pitching moment coefficient)
% y(3) = Cm0 + Cmal*al + Cmq*qn + Cmde*de;
YCm = Z(:,3);
% Input variables vectorof1(1), al, qn, de
XCm = [vectorof1  Uinp(:,7)  Uinp(:,5)  Uinp(:,1)];
np  = size(XCm,2);
np1 = np + 1;

% TLS estimates by svd
XYcomp = [XCm YCm];               % Composed data matrix
[ue,se,ve] = svd(XYcomp,0);       % Compute svd - economy: only for first n columns of ue
CmPar = -(ve(1:np,np1)/ve(np1,np1));
% % LS Normal equation
% CmPar = XCm\YCm;

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
np  = size(XCY,2);
np1 = np + 1;

% TLS estimates by svd
XYcomp = [XCY YCY];               % Composed data matrix
[ue,se,ve] = svd(XYcomp,0);       % Compute svd - economy: only for first n columns of ue
CYPar = -(ve(1:np,np1)/ve(np1,np1));

% Compute and print statistics of the estimates
disp(' ')
disp('Side force coefficient CY:');
[YCYhat, par_std, par_std_rel, R2Stat] = LS_Stat(XCY, YCY, CYPar);

%--------------------------------------------------------------------------
% Observation variable Cl (Rolling moment coefficient)
% y(5) = Cl0 + Clbe*be + Clp*pn + Clr*rn + Clda*da;
YCl = Z(:,5);
% Input variables vectorof1(1), be, pn, rn, da
XCl = [vectorof1  Uinp(:,8)  Uinp(:,4)  Uinp(:,6)  Uinp(:,2)];
np  = size(XCl,2);
np1 = np + 1;

% TLS estimates by svd
XYcomp = [XCl YCl];               % Composed data matrix
[ue,se,ve] = svd(XYcomp,0);       % Compute svd - economy: only for first n columns of ue
ClPar = -(ve(1:np,np1)/ve(np1,np1));

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
np  = size(XCn,2);
np1 = np + 1;

% TLS estimates by svd
XYcomp = [XCn YCn];               % Composed data matrix
[ue,se,ve] = svd(XYcomp,0);       % Compute svd - economy: only for first n columns of ue
CnPar = -(ve(1:np,np1)/ve(np1,np1));

% Compute and print statistics of the estimates
disp(' ')
disp('Yawing moment coefficient Cn:');
[YCnhat, par_std, par_std_rel, R2Stat] = LS_Stat(XCn, YCn, CnPar);


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%Plot time histories of computed (measured) and estimated variables
figure(1)
subplot(611),plot(time,YCD(:,1),'b', time,YCDhat(:,1),'r'); grid; ylabel('CD ()');
title({'Time histories of output variables (measured and estimated) applying TLS';...
       'from elevator, aileron, and rudder input maneuvers'})
subplot(612),plot(time,YCL(:,1),'b', time,YCLhat(:,1),'r'); grid; ylabel('CL (-)');
subplot(613),plot(time,YCm(:,1),'b', time,YCmhat(:,1),'r'); grid; ylabel('Cm_{AC} (-)');
subplot(614),plot(time,YCY(:,1),'b', time,YCYhat(:,1),'r'); grid; ylabel('CY (-)');
subplot(615),plot(time,YCl(:,1),'b', time,YClhat(:,1),'r'); grid; ylabel('Cl_{AC} (-)');
subplot(616),plot(time,YCn(:,1),'b', time,YCnhat(:,1),'r'); grid; ylabel('Cn_{AC} (-)');
xlabel('Time in sec'); 



% Modeling of pitching moment coefficient using TLS
disp(' ')
disp('NOTE:')
disp('From Figure 1 it is observed that the match between the flight derived and model')
disp('estimated aerodynamic coefficients CD, CL, CY, Cl, and Cn applying the TLS is good.')
disp('This time history match is similar to that obtained applying the OLS method using')
disp('"attas_regLS.m". The OLS and TLS estimates for the above coefficients are comparable.')
disp(' ')
disp('From Figure 1 it is, however, observed that the match for the pitching moment')
disp('coefficient Cm provided by the TLS shows significant discrepancies. On the other hand,')
disp('the match for Cm provided by OLS was acceptable.')
disp('The TLS values of Cm-parameters differ much from the corresponding OLS estimates.')
disp(' ')
disp('This anomaly is attributed to the fact that three time segments with elevator,')
disp('aileron and rudder inputs are analyzed simultaneously. The coupling effects')
disp('due to the lateral-directional motion variables into pitching motion are dominant.')
disp('However, the model for Cm is based on the longitudinal variables only, i.e. al, q, de')
disp('as independent variables. The effects due to beta, p, r etc. are not modeled.')
disp('These missing inputs of beta, p, r, which are significant in the second and third')
disp('maneuvers are treated as input noise. These discrepancies in the postulated model')
disp('lead to wrong TLS estimates from three maneuvers.')
disp('To cover this case correctly, it would require model augmentation (i.e. introduction')
disp('of appropriate independent variables). Since our aim here is restricted to')
disp('demonstration of TLS principle, such model improvements are not pursued here.')
disp('Since such discrepancies were not predominant for other coefficients, it is an')
disp('indicator that the coupling effects in them are not that significant.')
disp(' ')
disp('The above argumentation can be verified in an alternative way by analyzing the')
disp('first maneuver only with an elevator input based on the same simplified model. ')
disp('This has been carried out in the following. We apply both OLS and TLS to this single')
disp('maneuver and plot the results in Figure 2, which shows that the match is now')
disp('comparable and the estimates too.')
disp(' ')
disp('hit any key to continue ...'), pause

% Dependent variable Cm for the first time segment only (1:Nts1)
YCmTS1 = Z(1:Nts1,3);        
% Input variables [vectorof1(1), al, qn, de] for the first time segment only (1:Nts1)
XCmTS1 = [vectorof1(1:Nts1)  Uinp(1:Nts1,7)  Uinp(1:Nts1,5)  Uinp(1:Nts1,1)];

% LS estimate by solving Normal equation
CmParTS1_LS = XCmTS1\YCmTS1;
disp(' ')
disp('LS estimates of pitching moment coefficient Cm from 3211 elevator input maneuver:');
[YCmTS1hat_LS, par_std, par_std_rel, R2Stat] = LS_Stat(XCmTS1, YCmTS1, CmParTS1_LS);

% TLS estimates by svd
np  = size(XCmTS1,2);
np1 = np + 1;
XYcompTS1  = [XCmTS1 YCmTS1];        % Composed data matrix
[ue,se,ve] = svd(XYcompTS1,0);       % Compute svd - economy: only for first n columns of ue
CmParTS1_TLS = -(ve(1:np,np1)/ve(np1,np1));
disp(' ')
disp('TLS estimates of pitching moment coefficient Cm from 3211 elevator input maneuver:');
[YCmTS1hat_TLS, par_std, par_std_rel, R2Stat] = LS_Stat(XCmTS1, YCmTS1, CmParTS1_TLS);

figure(2)
subplot(111),plot(time(1:Nts1),YCmTS1(:,1),'b',...
                  time(1:Nts1),YCmTS1hat_LS(:,1),'r',...
                  time(1:Nts1),YCmTS1hat_TLS(:,1),'k'); grid; ylabel('Cm_{AC} (-)');
                  legend('Flight derived','OLS','TLS',1);
title('Time histories of measured and estimated Cm by LS and TLS from 3211 elevator input only')
xlabel('Time in sec'); 

% end of attas_RegLS