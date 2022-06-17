% Recursive Parameter Estimation
% Using either Extended Kalman Filter (EKF), 
%              Unscented Kalman Filter (UKF) -- simplified version,
%              Unscented Kalman Filter (UKFaugmented) - General case,
%              Extended Forgetting Factor Recursive Least Squares (EFRLS), or
%              Fourier Transform Regression (FTR).
%
% Chapter 7: Recursive Parameter Estimation 
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% by Ravindra V. Jategaonkar
% published by AIAA, Reston, VA 20191, USAA

clear all;
close all;

%---------------------------------------------------------------------------------------
% Select the test case to be analyzed:
% test_case = 3;              % Lateral-directioanl motion n=2, m=2, p=3, ATTAS
% test_case = 4;              % Longitudinal motion (Cl, CD, Cm), test aircraft HFB-320
test_case = 8;              % Unstable aircraft, short period (test case for chapter 08)
% test_case = 11;             % Short period motion, n=2, m=2, p=1, ATTAS
% test_case = 12;             % Short period motion, n=2, m=2, p=1, ATRA - A320
% test_case = 13;             % Short period motion, n=2, m=2, p=1, ATRA - A320 (Test for ftr_mod2)

%---------------------------------------------------------------------------------------
% Specify the method 
% method = 'EKF';             % Extended Kalman filter
% method = 'EFRLS';           % Extended forgetting factor recursive least squares
% method = 'FTR';             % Fourier Transform regression
method = 'UKF';             % Unscented Kalman Filter - Simplified version, no noise augmentation
% method = 'UKFaug';          % Unscented Kalman Filter - General case, augmentation though noise 
% method = 'ALL';
        
%----------------------------------------------------------------------------------------
% Model definition; functions for state derivatives and outputs
if (test_case == 3),
    [state_eq, obser_eq, Nx, Ny, Nu, NparSys, Nparam, NparID, Nxp, dt, Ndata,...
         t, Z, Uinp, param, parFlag, xah, delxa, rr, qq, p0, parOEM] = mDefCase03(test_case);
elseif (test_case == 4),
    [state_eq, obser_eq, Nx, Ny, Nu, NparSys, Nparam, NparID, Nxp, dt, Ndata,...
         t, Z, Uinp, param, parFlag, xah, delxa, rr, qq, p0, parOEM] = mDefCase04(test_case);
elseif (test_case == 8),
    [state_eq, obser_eq, Nx, Ny, Nu, NparSys, Nparam, NparID, Nxp, dt, Ndata,...
         t, Z, Uinp, param, parFlag, xah, delxa, rr, qq, p0, parOEM] = mDefCase08(test_case);
elseif (test_case == 11),
    [state_eq, obser_eq, Nx, Ny, Nu, NparSys, Nparam, NparID, Nxp, dt, Ndata,...
         t, Z, Uinp, param, parFlag, xah, delxa, rr, qq, p0, parOEM] = mDefCase11(test_case);
elseif (test_case == 12),
    [state_eq, obser_eq, Nx, Ny, Nu, NparSys, Nparam, NparID, Nxp, dt, Ndata,...
         t, Z, Uinp, param, parFlag, xah, delxa, rr, qq, p0, parOEM] = mDefCase12(test_case);
elseif (test_case == 13),
    [state_eq, obser_eq, Nx, Ny, Nu, NparSys, Nparam, NparID, Nxp, dt, Ndata,...
         t, Z, X, Uinp, param, parFlag, xah, delxa, rr, qq, p0, parOEM] = mDefCase13(test_case);
else
    disp('Error Termination:');
    disp('Wrong specification of test_case.');
    break;
end 

% Verify model definition
iError = mDefCHK_rpe(test_case, Nx, Ny, Nu, NparSys, Nparam, NparID, Nxp, ...
                                            param, parFlag, xah, delxa, rr, qq, p0);
if iError ~= 0, break, end        % Error termination 
                                    
%----------------------------------------------------------------------------------------
% Define RPE specific parameters:
lamda   = 0.998;                  % EFRLS: Forgetting factor 0.998
Uprate  = 1;                      % FTR:   update rate for FFT
OmegaHz = (0.2:0.04:1.5)';        % FTR:   Range of frequency in Hz

%----------------------------------------------------------------------------------------
% State and parameter estimation
if (strcmp(method,'EKF')  |  strcmp(method,'ALL') ),
    disp(' ');
    disp('Parameter estimation applying Extended Kalman Filter (EKF):');
    tekfIni = cputime;
    [syekf, szmsyekf, sxekf, sxekfstd] = ekf_mod(state_eq, obser_eq,...
                                                 t, Z, Uinp, Ndata, Ny, NparID, Nxp, Nu,...
                                                 Nx, Nparam, dt, rr, qq, p0, param, parFlag,...
                                                 xah, delxa);
    time_ekf = cputime - tekfIni;
    disp(['Computational time for EKF: time_ekf= ' num2str(time_ekf) ' seconds']);
    % parameter values: average over last 10 points
    [parAvgEkf, stdAvgEkf] = prnt_par_std('EKF', Nx, NparSys, Ndata, parFlag, 10,...
                                                 sxekf, sxekfstd);
end

if (strcmp(method,'UKF')  |  strcmp(method,'ALL') ),
    disp(' ');
    disp('Parameter estimation applying Unscented Kalman Filter (UKF) - Simplified version:');
    tukfIni = cputime;
    alpha = 0.5000;
    beta  = 2;
    kappa = 3 - Nxp;
    [syukf, sxukf, sxukfstd] = ukf_mod(state_eq, obser_eq, Z, Uinp, Ndata, dt,...
                                       Nx, Ny, Nu, Nparam, NparID, Nxp, param, parFlag,...
                                       xah, p0, qq, rr, kappa, alpha, beta);
    time_ukf = cputime - tukfIni;
    disp(['Computational time for UKF: time_ukf= ' num2str(time_ukf) ' seconds']);
    % parameter values: average over last 10 points
    [parAvgEkf, stdAvgEkf] = prnt_par_std('UKF', Nx, NparSys, Ndata, parFlag, 10,...
                                                 sxukf, sxukfstd);
end

if (strcmp(method,'UKFaug')  |  strcmp(method,'ALL') ),
    disp(' ');
    disp('Parameter estimation applying Unscented Kalman Filter (UKFaug) - General case:');
    tukfAugIni = cputime;
    alpha = 0.5000;
    beta  = 2;
    Na    = Nxp + Nx + Ny;        % Basic states + Paramaters + NwNoise + NvNoise
    kappa = 3 - Na;
    state_eq_UKFaug = [state_eq '_xyNoise'];
    obser_eq_UKFaug = [obser_eq '_xyNoise'];
    [syukfAug, sxukfAug, sxukfAugstd] = ukf_mod_augmented(state_eq_UKFaug, obser_eq_UKFaug,...
                                            Z, Uinp, Ndata, dt,...
                                            Nx, Ny, Nu, Nparam, NparID, Nxp, param, parFlag,...
                                            xah, p0, qq, rr, kappa, alpha, beta);
    time_ukfAug = cputime - tukfAugIni;
    disp(['Computational time for UKFaugmented: time_ukfAug = ' num2str(time_ukfAug) ' seconds']);
    % parameter values: average over last 10 points
    [parAvgEkf, stdAvgEkf] = prnt_par_std('UKFaug', Nx, NparSys, Ndata, parFlag, 10,...
                                                    sxukfAug, sxukfAugstd);
end

if ( ((strcmp(method,'EFRLS')  |  strcmp(method,'ALL'))  & test_case~=4  & test_case~=8 ) ),
    disp(' ');
    disp('Parameter estimation applying Extended Forgetting Factor Recursive Least Squares (EFRLS):');
    p0 = [zeros(1,Nxp)+1.0d03]';
    tEFRLSIni = cputime;
    [syrls, szmsyrls, sxrls, sxrlsstd] = efrls_mod(state_eq, obser_eq,...
                                                   t, Z, Uinp, Ndata, Ny, NparID, Nxp, Nu,...
                                                   Nx, Nparam, dt, lamda, p0, param, parFlag,...
                                                   xah, delxa);
    tEFRLS = cputime - tEFRLSIni;
    disp(['Computational time for EFRLS: tEFRLS = ' num2str(tEFRLS) ' seconds']);
    % parameter values: average over last 10 points
    [parAvgEkf, stdAvgEkf] = prnt_par_std('EFRLS', Nx, NparSys, Ndata, parFlag, 10,...
                                                   sxrls, sxrlsstd);
end

if ( ((strcmp(method,'FTR')  |  strcmp(method,'ALL')) & test_case~=4   & test_case~=8 ) ),
    disp(' ');
    disp('Parameter estimation applying Discrete Fourier Transform method (FTR):');
    % [tFTR, sxftr, sxftrstd] = ftr_mod2(Z, X, Uinp, dt, Uprate, OmegaHz,...
    %                                   Ny, Nu, Nx, Ndata);
    [tFTR, sxftr, sxftrstd] = ftr_mod(Z, Uinp, dt, Uprate, OmegaHz,...
                                      Ny, Nu, Nx, Ndata);
    % parameter values: average over last 5 points
    ndftPts = size(sxftr,1);
    ndftPar = size(sxftr,2);
    [parAvgEkf, stdAvgEkf] = prnt_par_std('FTR', 0, ndftPar, ndftPts, parFlag, 5,...
                                                 sxftr, sxftrstd);
      
end

%----------------------------------------------------------------------------------------
% plots of measured and estimated time hsitories of outputs, inputs and parameters
if (test_case == 3),
    if (strcmp(method,'EKF')),
        [t]=plots_TC03_lat_ekf(t,parOEM,Z,Uinp,syekf,sxekf,sxekfstd,method);
    elseif (strcmp(method,'UKF')),
        [t]=plots_TC03_lat_ukf(t,parOEM,Z,Uinp,syukf,sxukf,sxukfstd,method);
    elseif (strcmp(method,'UKFaug')),
        [t]=plots_TC03_lat_ukf(t,parOEM,Z,Uinp,syukfAug,sxukfAug,sxukfAugstd,method);
    elseif (strcmp(method,'EFRLS')),
        [t]=plots_TC03_lat_rls(t,parOEM,Z,Uinp,syrls,sxrls,sxrlsstd,method);
    elseif (strcmp(method,'ALL')),
        [t]=plots_TC03_lat_5RPE(t,parOEM,Z,Uinp,syekf,sxekf,sxekfstd,...
                                                syukf,sxukf,sxukfstd,...
                                                syukfAug,sxukfAug,sxukfAugstd,...
                                                syrls,sxrls,sxrlsstd,...
                                          tFTR, sxftr,sxftrstd,method);
    end
    
elseif (test_case == 4),
    if (strcmp(method,'EKF')),
        [t]=plots_TC04_hfb_ekf(t,parOEM,Z,Uinp,syekf,sxekf,sxekfstd,method);
    elseif (strcmp(method,'UKF')),
        [t]=plots_TC04_hfb_ukf(t,parOEM,Z,Uinp,syukf,sxukf,sxukfstd,method);
    elseif (strcmp(method,'UKFaug') ),
        [t]=plots_TC04_hfb_ukf(t,parOEM,Z,Uinp,syukfAug,sxukfAug,sxukfAugstd,method);
    elseif (strcmp(method,'EFRLS')),
        [t]=plots_TC04_hfb_rls(t,parOEM,Z,Uinp,syrls,sxrls,sxrlsstd,method);
    elseif (strcmp(method,'ALL')),
        [t]=plots_TC04_hfb_3RPE(t,parOEM,Z,Uinp,syekf,sxekf,sxekfstd,...
                                                syukf,sxukf,sxukfstd,...
                                                syukfAug,sxukfAug,sxukfAugstd,method);
    end
    
elseif (test_case == 8),
    if (strcmp(method,'EKF')),
        [t]=plots_TC08_uAC_ekf(t,parOEM,Z,Uinp,syekf,sxekf,sxekfstd,method);
     elseif (strcmp(method,'UKF')),
        [t]=plots_TC08_uAC_ekf(t,parOEM,Z,Uinp,syukf,sxukf,sxukfstd,method);
     elseif (strcmp(method,'UKFaug')),
        [t]=plots_TC08_uAC_ekf(t,parOEM,Z,Uinp,syukfAug,sxukfAug,sxukfAugstd,method);
    elseif (strcmp(method,'ALL')),
        [t]=plots_TC08_uAC_3RPE(t,parOEM,Z,Uinp,syekf,sxekf,sxekfstd,...
                                                syukf,sxukf,sxukfstd,...
                                                syukfAug,sxukfAug,sxukfAugstd,method);
    end
    
elseif (test_case == 11),
    if (strcmp(method,'EKF')),
        [t]=plots_TC11_lon_ekf(t,parOEM,Z,Uinp,syekf,sxekf,sxekfstd,method);
    elseif (strcmp(method,'UKF')),
        [t]=plots_TC11_lon_ukf(t,parOEM,Z,Uinp,syukf,sxukf,sxukfstd,method);
    elseif (strcmp(method,'UKFaug')),
        [t]=plots_TC11_lon_ukf(t,parOEM,Z,Uinp,syukfAug,sxukfAug,sxukfAugstd,method);
    elseif (strcmp(method,'EFRLS')),
        [t]=plots_TC11_lon_rls(t,parOEM,Z,Uinp,syrls,sxrls,sxrlsstd,method);
    elseif (strcmp(method,'ALL')),
        [t]=plots_TC11_lon_5RPE(t,parOEM,Z,Uinp,syekf,sxekf,sxekfstd,...
                                                syukf,sxukf,sxukfstd,...
                                                syukfAug,sxukfAug,sxukfAugstd,...
                                                syrls,sxrls,sxrlsstd,...
                                          tFTR, sxftr,sxftrstd,method);
    end
    
    elseif (test_case == 12),
    if (strcmp(method,'EKF')),
        [t]=plots_TC11_lon_ekf(t,parOEM,Z,Uinp,syekf,sxekf,sxekfstd,method);
    elseif (strcmp(method,'UKF')),
        [t]=plots_TC11_lon_ukf(t,parOEM,Z,Uinp,syukf,sxukf,sxukfstd,method);
    elseif (strcmp(method,'UKFaug')),
        [t]=plots_TC11_lon_ukf(t,parOEM,Z,Uinp,syukfAug,sxukfAug,sxukfAugstd,method);
    elseif (strcmp(method,'EFRLS')),
        [t]=plots_TC11_lon_rls(t,parOEM,Z,Uinp,syrls,sxrls,sxrlsstd,method);
    elseif (strcmp(method,'ALL')),
        [t]=plots_TC12_lon_5RPE(t,parOEM,Z,Uinp,syekf,sxekf,sxekfstd,...
                                                syukf,sxukf,sxukfstd,...
                                                syukfAug,sxukfAug,sxukfAugstd,...
                                                syrls,sxrls,sxrlsstd,...
                                          tFTR, sxftr,sxftrstd,method);
    end

end
