% eig_uAC_ID
%
% Compute eigenvalues of system matrix estimated applying different methods
% Unstable aircraft - simulated data
%
% Chapter 09, Table 9.1 
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% published by AIAA, Reston, VA 20191, USA

U0   = 44.5695; 

%--------------------------------------------------------------------------
% True values
Zw   = -1.4249;
ZqU0 = -1.4768 + U0;
Mw   =  0.2163;
Mq   = -3.7067;

Amat = [Zw ZqU0; ...
        Mw Mq];
disp('0: Eigenvalues of simulated (true) system')
eigV = eig(Amat);
for ip=1:size(eigV,1),
    par_prnt = sprintf('%4i  %8.4f', ip, eigV(ip));
    disp(par_prnt)
end

%--------------------------------------------------------------------------
% Estimated values applying Classical RegLS (Normal Equation)
% Chapter 9, uAC_regLS
Zw   = -1.42490e+000;
ZqU0 = -1.47680e+000 + U0;
Mw   =  2.14790e-001;
Mq   = -3.69054e+000;

Amat = [Zw ZqU0; ...
        Mw Mq];
disp('1: Eigenvalues of estimated system matrix - Least squares estimation')
eigV = eig(Amat);
for ip=1:size(eigV,1),
    par_prnt = sprintf('%4i  %8.4f', ip, eigV(ip));
    disp(par_prnt)
end

%--------------------------------------------------------------------------
% Estimated values applying Total least squares
% Chapter 9, uAC_regTLS
Zw   = -1.42490e+000;
ZqU0 = -1.47680e+000 + U0;
Mw   =  2.14802e-001;
Mq   = -3.69069e+000;

Amat = [Zw ZqU0; ...
        Mw Mq];
disp('2: Eigenvalues of estimated system matrix - Total least squares estimation')
eigV = eig(Amat);
for ip=1:size(eigV,1),
    par_prnt = sprintf('%4i  %8.4f', ip, eigV(ip));
    disp(par_prnt)
end

%--------------------------------------------------------------------------
% Estimated values applying LS/OEM (Combined output error and least squares)
% Chapter 4, ml_oem, test_case=6
Zw   = -1.42490e+000;
ZqU0 = -1.4768       + U0;
Mw   =  2.16338e-001;
Mq   = -3.71215e+000;

Amat = [Zw ZqU0; ...
        Mw Mq];
disp('3: Eigenvalues of estimated system matrix - LS/OEM (Combined output error and least squares)')
eigV = eig(Amat);
for ip=1:size(eigV,1),
    par_prnt = sprintf('%4i  %8.4f', ip, eigV(ip));
    disp(par_prnt)
end

%--------------------------------------------------------------------------
% Estimated values applying Equation Decoupling
% Chapter 4, ml_oem, test_case=7
Zw   = -1.42766e+000;
ZqU0 = -1.4768       + U0;
Mw   =  2.16158e-001;
Mq   = -3.70855e+000;

Amat = [Zw ZqU0; ...
        Mw Mq];
disp('4: Eigenvalues of estimated system matrix - Equation Decoupling method')
eigV = eig(Amat);
for ip=1:size(eigV,1),
    par_prnt = sprintf('%4i  %8.4f', ip, eigV(ip));
    disp(par_prnt)
end

%--------------------------------------------------------------------------
% Estimated values applying Eigenvalue Transformation
% Chapter 4, ml_oem, test_case=10
Zw   = -1.42936e+000;
ZqU0 = -1.4768       + U0;
Mw   =  2.17761e-001;
Mq   = -3.72645e+000;

Amat = [Zw ZqU0; ...
        Mw Mq];
disp('5: Eigenvalues of estimated system matrix - Eigenvalue Transformation method')
eigV = eig(Amat);
for ip=1:size(eigV,1),
    par_prnt = sprintf('%4i  %8.4f', ip, eigV(ip));
    disp(par_prnt)
end

%--------------------------------------------------------------------------
% Estimated values applying Filter Error method
% Chapter 5, ml_fem, test_case=8
Zw   = -1.42780e+000;
ZqU0 = -1.4768       + U0;
Mw   =  2.17171e-001;
Mq   = -3.71967e+000;

Amat = [Zw ZqU0; ...
        Mw Mq];
disp('6: Eigenvalues of estimated system matrix - Filter Error method')
eigV = eig(Amat);
for ip=1:size(eigV,1),
    par_prnt = sprintf('%4i  %8.4f', ip, eigV(ip));
    disp(par_prnt)
end

%--------------------------------------------------------------------------
% Estimated values applying Extended Kalman filter
% Chapter 7, mainRPE, test_case=8
Zw   = -1.42523e+000;
ZqU0 = -1.4768        + U0;
Mw   =  2.17516e-001;
Mq   = -3.73726e+000;

Amat = [Zw ZqU0; ...
        Mw Mq];
disp('7: Eigenvalues of estimated system matrix - Extended Kalman filter')
eigV = eig(Amat);
for ip=1:size(eigV,1),
    par_prnt = sprintf('%4i  %8.4f', ip, eigV(ip));
    disp(par_prnt)
end

%--------------------------------------------------------------------------
% Estimated values applying Unscented Kalman filter
% Chapter 7, mainRPE, test_case=8
Zw   = -1.42516e+000;
ZqU0 = -1.4768       + U0;
Mw   =  2.17131e-001;
Mq   = -3.73432e+000;

Amat = [Zw ZqU0; ...
        Mw Mq];
disp('8: Eigenvalues of estimated system matrix - Unscented Kalman filter')
eigV = eig(Amat);
for ip=1:size(eigV,1),
    par_prnt = sprintf('%4i  %8.4f', ip, eigV(ip));
    disp(par_prnt)
end

%--------------------------------------------------------------------------
% Estimated values applying OEM
% Chapter 4, ml_oem, test_case=8
Zw   = -1.30856e+000;
ZqU0 = -1.4768       + U0;
Mw   =  5.21602e-002;
Mq   = -1.92771e+000;

Amat = [Zw ZqU0; ...
        Mw Mq];
disp('9: Eigenvalues of estimated system matrix - Output Error method')
eigV = eig(Amat);
for ip=1:size(eigV,1),
    par_prnt = sprintf('%4i  %8.4f', ip, eigV(ip));
    disp(par_prnt)
end

%--------------------------------------------------------------------------
% Estimated values applying Stabilized OEM
% Chapter 4, ml_oem, test_case=9
Zw   = -1.42684e+000;
ZqU0 = -1.4768       + U0;
Mw   =  2.17019e-001;
Mq   = -3.72013e+000;

Amat = [Zw ZqU0; ...
        Mw Mq];
disp('10: Eigenvalues of estimated system matrix - Stabilized Output Error method')
eigV = eig(Amat);
for ip=1:size(eigV,1),
    par_prnt = sprintf('%4i  %8.4f', ip, eigV(ip));
    disp(par_prnt)
end
