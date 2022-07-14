% Maximum Likelihood parameter estimation:
% Output Error Method accounting for measurement noise.
% Relaxation algorithm:
%     Step 1: Explicit estimation of R (covariance matrix of residuals)
%     Step 2: Gauss-Newton (or Levenberg-Marquardt) method for optimization of 
%             cost function w.r.t. parameters
%
% Chapter 4: Output Error Method
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Secon Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA, January 2015

clear all;
close all;

global dt

%-----------------------------------------------------------------------------------
% Select the test case to be analyzed:
% test_case = 1;               % Lateral-directional motion, n=2, m=5, p=3, ATTAS
% test_case = 2;               % Lateral motion, simulated data with turbulence
% test_case = 3;               % Lateral-directional motion, n=2, m=2, p=3, ATTAS
% test_case = 4;               % Longitudinal motion (Cl, CD, Cm), test A/C HFB-320

% test_case = 6;               % Unstable aircraft, short period, combined LS/OEM 
% test_case = 7;               % Unstable aircraft, short period, Eqn Decoupling
% test_case = 8;               % Unstable aircraft, short period, OEM
% test_case = 9;               % Unstable aircraft, short period, Stabilized OEM
% test_case = 10;              % Unstable aircraft, short period, EigValTransform

% test_case = 11;              % Short period motion, n=2, m=2, p=1, ATTAS

test_case = 22;              % Flight path reconstruction, ATTAS, NZI=3,
                               % longitudinal and lateral-directional motion
                               
% test_case = 23;              % Aero-model by Regression, ATTAS, NZI=3,
                               % longitudinal and lateral-directional motion
% test_case = 24;              % same as test_case=23, but nonlinear in CD

% test_case = 27;              % ATTAS Regression NL -- Quasi-steady stall
                               % longitudinal mode only

% test_case = 31;              % Similar to TC01, but with time delay in one signal.

% test_case = 32;              % Similar to TC22 (Attas FPR), but with BX separtely
                               % for each time segment
                               
% test_case = 33;              % Similar to TC22 (Attas FPR), but with estimation 
                               % of time delays in alpha, beta, psi
                               
% test_case = 34;              % Similar to TC01, but with BX separtely
                               % for each time segment


%-----------------------------------------------------------------------------------
% Choose iOptim for optimization method: =1: Gauss-Newton; =2: Levenberg-Marquardt
iOptim = 1;
% iOptim = 2;

%-----------------------------------------------------------------------------------
% Choose numerical integration method:
integMethod = 'ruku4';     % ruku2, ruku3, ruku4 (2nd, 3rd or 4th order Rumge-Kutta)

%-----------------------------------------------------------------------------------
% Model definition; functions for state derivatives and outputs
if (test_case == 1),
    [state_eq, obser_eq, Nx, Ny, Nu, NparSys, Nparam, NparID, Nminmax,...
        dt, Ndata, Nzi, izhf, t, Z, Uinp, param, parFlag, param_min, param_max,...
        x0, iArtifStab, StabMat, LineSrch, parFlagX0, NX0ID, ...
                              bXpar, parFlagBX, NbX, NBXID] = mDefCase01(test_case);
elseif (test_case == 2),
    [state_eq, obser_eq, Nx, Ny, Nu, NparSys, Nparam, NparID, Nminmax, ...
        dt, Ndata, Nzi, izhf, t, Z, Uinp, param, parFlag, param_min, param_max,...
        x0, iArtifStab, StabMat, LineSrch, parFlagX0, NX0ID, ...
                              bXpar, parFlagBX, NbX, NBXID] = mDefCase02(test_case);
elseif (test_case == 3),
    [state_eq, obser_eq, Nx, Ny, Nu, NparSys, Nparam, NparID, Nminmax, ...
        dt, Ndata, Nzi, izhf, t, Z, Uinp, param, parFlag, param_min, param_max,...
        x0, iArtifStab, StabMat, LineSrch, parFlagX0, NX0ID, ...
                              bXpar, parFlagBX, NbX, NBXID] = mDefCase03(test_case);
elseif (test_case == 4),
    [state_eq, obser_eq, Nx, Ny, Nu, NparSys, Nparam, NparID, Nminmax,...
        dt, Ndata, Nzi, izhf, t, Z, Uinp, param, parFlag, param_min, param_max,...
        x0, iArtifStab, StabMat, LineSrch, parFlagX0, NX0ID, ...
                              bXpar, parFlagBX, NbX, NBXID] = mDefCase04(test_case);
elseif (test_case == 5),
    [state_eq, obser_eq, Nx, Ny, Nu, NparSys, Nparam, NparID, Nminmax,...
        dt, Ndata, Nzi, izhf, t, Z, Uinp, param, parFlag, param_min, param_max,...
        x0, iArtifStab, StabMat, LineSrch, parFlagX0, NX0ID, ...
                              bXpar, parFlagBX, NbX, NBXID] = mDefCase05(test_case);
elseif (test_case == 6),
    [state_eq, obser_eq, Nx, Ny, Nu, NparSys, Nparam, NparID, Nminmax,...
        dt, Ndata, Nzi, izhf, t, Z, Uinp, param, parFlag, param_min, param_max,...
        x0, iArtifStab, StabMat, LineSrch, parFlagX0, NX0ID, ...
                              bXpar, parFlagBX, NbX, NBXID] = mDefCase06(test_case);
elseif (test_case == 7),
    [state_eq, obser_eq, Nx, Ny, Nu, NparSys, Nparam, NparID, Nminmax,...
        dt, Ndata, Nzi, izhf, t, Z, Uinp, param, parFlag, param_min, param_max,...
        x0, iArtifStab, StabMat, LineSrch, parFlagX0, NX0ID, ...
                              bXpar, parFlagBX, NbX, NBXID] = mDefCase07(test_case);
elseif (test_case == 8),
    [state_eq, obser_eq, Nx, Ny, Nu, NparSys, Nparam, NparID, Nminmax,...
        dt, Ndata, Nzi, izhf, t, Z, Uinp, param, parFlag, param_min, param_max,...
        x0, iArtifStab, StabMat, LineSrch, parFlagX0, NX0ID, ...
                              bXpar, parFlagBX, NbX, NBXID] = mDefCase08(test_case);
elseif (test_case == 9),
    [state_eq, obser_eq, Nx, Ny, Nu, NparSys, Nparam, NparID, Nminmax,...
        dt, Ndata, Nzi, izhf, t, Z, Uinp, param, parFlag, param_min, param_max,...
        x0, iArtifStab, StabMat, LineSrch, parFlagX0, NX0ID, ...
                              bXpar, parFlagBX, NbX, NBXID] = mDefCase09(test_case);
elseif (test_case == 10),
    [state_eq, obser_eq, Nx, Ny, Nu, NparSys, Nparam, NparID, Nminmax,...
        dt, Ndata, Nzi, izhf, t, Z, Uinp, param, parFlag, param_min, param_max,...
        x0, iArtifStab, StabMat, LineSrch, parFlagX0, NX0ID, ...
                              bXpar, parFlagBX, NbX, NBXID] = mDefCase10(test_case);
elseif (test_case == 11),
    [state_eq, obser_eq, Nx, Ny, Nu, NparSys, Nparam, NparID, Nminmax,...
        dt, Ndata, Nzi, izhf, t, Z, Uinp, param, parFlag, param_min, param_max,...
        x0, iArtifStab, StabMat, LineSrch, parFlagX0, NX0ID, ...
                              bXpar, parFlagBX, NbX, NBXID] = mDefCase11(test_case);
elseif (test_case == 12),
    [state_eq, obser_eq, Nx, Ny, Nu, NparSys, Nparam, NparID, Nminmax,...
        dt, Ndata, Nzi, izhf, t, Z, Uinp, param, parFlag, param_min, param_max,...
        x0, iArtifStab, StabMat, LineSrch, parFlagX0, NX0ID, ...
                              bXpar, parFlagBX, NbX, NBXID] = mDefCase12(test_case);
elseif (test_case == 22),
    [state_eq, obser_eq, Nx, Ny, Nu, NparSys, Nparam, NparID, Nminmax,...
        dt, Ndata, Nzi, izhf, t, Z, Uinp, param, parFlag, param_min, param_max,...
        x0, iArtifStab, StabMat, LineSrch, parFlagX0, NX0ID, ...
                              bXpar, parFlagBX, NbX, NBXID] = mDefCase22(test_case);
elseif (test_case == 23),
    [state_eq, obser_eq, Nx, Ny, Nu, NparSys, Nparam, NparID, Nminmax,...
        dt, Ndata, Nzi, izhf, t, Z, Uinp, param, parFlag, param_min, param_max,...
        x0, iArtifStab, StabMat, LineSrch, parFlagX0, NX0ID, ...
                              bXpar, parFlagBX, NbX, NBXID] = mDefCase23(test_case);
elseif (test_case == 24),
    [state_eq, obser_eq, Nx, Ny, Nu, NparSys, Nparam, NparID, Nminmax,...
        dt, Ndata, Nzi, izhf, t, Z, Uinp, param, parFlag, param_min, param_max,...
        x0, iArtifStab, StabMat, LineSrch, parFlagX0, NX0ID, ...
                              bXpar, parFlagBX, NbX, NBXID] = mDefCase24(test_case);
elseif (test_case == 27),
    [state_eq, obser_eq, Nx, Ny, Nu, NparSys, Nparam, NparID, Nminmax,...
        dt, Ndata, Nzi, izhf, t, Z, Uinp, param, parFlag, param_min, param_max,...
        x0, iArtifStab, StabMat, LineSrch, parFlagX0, NX0ID, ...
                              bXpar, parFlagBX, NbX, NBXID] = mDefCase27(test_case); 
elseif (test_case == 31),
    [state_eq, obser_eq, Nx, Ny, Nu, NparSys, Nparam, NparID, Nminmax,...
        dt, Ndata, Nzi, izhf, t, Z, Uinp, param, parFlag, param_min, param_max,...
        x0, iArtifStab, StabMat, LineSrch, parFlagX0, NX0ID, ...
                              bXpar, parFlagBX, NbX, NBXID] = mDefCase31(test_case);
elseif (test_case == 32),
    [state_eq, obser_eq, Nx, Ny, Nu, NparSys, Nparam, NparID, Nminmax,...
        dt, Ndata, Nzi, izhf, t, Z, Uinp, param, parFlag, param_min, param_max,...
        x0, iArtifStab, StabMat, LineSrch, parFlagX0, NX0ID, ...
                              bXpar, parFlagBX, NbX, NBXID] = mDefCase32(test_case);
elseif (test_case == 33),
    [state_eq, obser_eq, Nx, Ny, Nu, NparSys, Nparam, NparID, Nminmax,...
        dt, Ndata, Nzi, izhf, t, Z, Uinp, param, parFlag, param_min, param_max,...
        x0, iArtifStab, StabMat, LineSrch, parFlagX0, NX0ID, ...
                              bXpar, parFlagBX, NbX, NBXID] = mDefCase33(test_case);
elseif (test_case == 34),
    [state_eq, obser_eq, Nx, Ny, Nu, NparSys, Nparam, NparID, Nminmax,...
        dt, Ndata, Nzi, izhf, t, Z, Uinp, param, parFlag, param_min, param_max,...
        x0, iArtifStab, StabMat, LineSrch, parFlagX0, NX0ID, ...
                              bXpar, parFlagBX, NbX, NBXID] = mDefCase34(test_case);
else
    disp('Error Termination:');
    disp('Wrong specification of test_case.');
    % % break;
end 

% Verify model definition
iError = mDefCHK_oem(test_case, Nx, Ny, Nu, NparSys, Nparam, NparID, Nzi, ... 
                     Nminmax, iOptim, param, parFlag, param_min, param_max, ...
                     x0, iArtifStab, StabMat);
if iError ~= 0, % break        % Error termination 
end                                   
%-----------------------------------------------------------------------------------
% parameter perturbation size for gradient computation by numerical approximation
par_step  = 1e-6;
% par_step  = 1e-3;
% Convergence limit in terms of relative change in the cost function
tolR      = 1e-4;
% tolR      = 1e-3;
% max number of iterations
% niter_max = 1;
% niter_max = 0;
niter_max = 50;

%-----------------------------------------------------------------------------------
% Initialize iteration counter, counter for halving steps (maximum of ten)
iter     = 0;
khalf    = 0;
prevCost = 0;
% Store parameter values for plotting purposes
params   = param;
par_std  = zeros(NparID+NX0ID+NBXID,1);
%
nBounds  = 0;
i_State  = zeros(Nparam,1);
% options for ode solver (default)
options  = odeset;

%-----------------------------------------------------------------------------------
disp('Maximum Likelihood Parameter estimation: Output Error Method:');
if (iOptim == 1),
    disp('Optimization method: Gauss-Newton method:');
elseif (iOptim == 2),
    disp('Optimization method: Levenberg-Marquardt method:');
    lamda = 0.001;
else
    disp('Error Termination:');
    disp('Wrong specification of the optimization method.');
    % % break;
end

if (strcmp(integMethod,'ruku2')),
    disp('Numerical integration method: Runge-Kutta 2nd order');
elseif (strcmp(integMethod,'ruku3')),
    disp('Numerical integration method: Runge-Kutta 3rd order');
elseif (strcmp(integMethod,'ruku4')),
    disp('Numerical integration method: Runge-Kutta 4th order');
else
    disp('Error Termination:');
    disp('Wrong specification of the integration method.');
    % break;
end

% Initialize time counter
tMLIni = cputime;

% Single vector of system parameters, initial conditions and bias parameters
paramX0BX = param;
if ~isempty(x0),
    for kzi=1:Nzi,
        paramX0BX = [paramX0BX; x0(:,kzi)];
    end
end
if ~isempty(bXpar),
    for kzi=1:Nzi,
        paramX0BX = [paramX0BX; bXpar(:,kzi)];
    end
end


% Y = zeros(Ndata,Ny);       % has no effect of cpu time for tc05 prop case

%-----------------------------------------------------------------------------------
% Iteration Loop (Jump back address)
while iter <= niter_max;

    % perform simulation for the current parameter values
    [currentCost, R, RI, Y] = costfun_oem (integMethod, state_eq, obser_eq, ...
                                           Ndata, Ny, Nu, Nzi, Nx, t, x0, ...
                                           Uinp, Z, izhf, iArtifStab, ...
                                           StabMat, Nparam, paramX0BX, NbX);

    % Print out the iteration count (, parameter values) and cost function
    tMLIter = cputime - tMLIni;
    disp(['iteration = ', num2str(iter)]);
    disp(['cost function: det(R) = ', num2str(det(R)), ...
          '   cpu-time = ', num2str(tMLIter) ]);

    % Relative change in the cost function
    relerror = abs((currentCost-prevCost)/currentCost);
    %disp(['relative error = ', num2str(relerror)]);

    % store params and standard deviations only if successful step: convergence plot 
    % if (currentCost < prevCost),
    if ( (currentCost < prevCost)  | ((relerror<tolR) && (iter > 0)) ),
        params  = [params, param];
        pcov    = inv(F);                        % param error covar mat, Eq. (4.87)
        % par_std = [par_std, sqrt(diag(pcov))];   % standard deviations, Eq. (4.88)
        stdDev  = sqrt(diag(pcov));              % standard deviations, Eq. (4.88)
        stdDev(i_State~=0) = 0;
        par_std = [par_std, stdDev];
    end

    % Check convergence: relative change in the cost function
    if (relerror < tolR) & (iter > 0),
        
        disp('convergence criterion is satisfied');
        % break;
        
    else
        
        if (iter == niter_max),
            if (currentCost < prevCost | niter_max == 0),
                disp('Maximum number of iterations reached.');
                % break;
            else                  % to allow halving at itmax before terminating
                disp('Intermediate divergence: halving of parameter step')
                paramX0BX = (paramX0BX+param_old)/2;
                [param, x0, bXpar] = parDecomp(Nparam, Nx, Nzi, NbX, paramX0BX);
                half = khalf + 1;
            end;
             
        elseif (currentCost > prevCost) & (iter > 0),
        
            % Maximum of 10 times halving of the parameters
            if (khalf == 10),
                disp('Intermediate divergence!')
                disp('Error termination:')
                disp('No improvement after 10 times halving of parameter step.')
                % break;
            else
                disp('Intermediate divergence: halving of parameter step')
                paramX0BX = (paramX0BX+param_old)/2;
                [param, x0, bXpar] = parDecomp(Nparam, Nx, Nzi, NbX, paramX0BX);
                khalf = khalf + 1;
            end; 
            
        else
            
            % compute the matrix of second gradients F and gradient G, Eq. (4.30)
            
            % Perturbations for gradient computation by difference approximation
            par_del = par_step*paramX0BX(1:Nparam);       % param perturbations 
            par_del(find(par_del==0))     = par_step;     % if zero, set to par_step
            par_delX0 = par_step*x0;                      % X0 perturbations 
            par_delX0(find(par_delX0==0)) = par_step;     % if zero, set to par_step
            par_delbX = par_step*bXpar;                   % bX perturbations 
            par_delbX(find(par_delbX==0)) = par_step;     % if zero, set to par_step

            if isempty(x0) == 0,  
                XGST(Nx, NparID+NX0ID+NBXID) = 0;     % Workspace to save propagated
            else                                      % perturbed states for re-
                XGST = [ ];                           % initialization; see Fig. 4.5
            end                                       % (Pseudo Parallel Processing)

            [F, G, XGST] = gradFG(Ny, Nparam, NparID, Ndata, Nu, Nx, Nzi, izhf, ...
                                  Z, Y, RI, param, parFlag, par_del, par_delX0,...
                                  state_eq, Uinp, obser_eq, t, x0, iArtifStab, ...
                                  StabMat, integMethod, parFlagX0, NX0ID, XGST, ...
                                  paramX0BX, NbX, NBXID, bXpar, parFlagBX, par_delbX);
   
            % compute parameter update step: either GN, BVGN, or LM
            if  iOptim == 1,      % Unconstrained Gauss-Newton or bounded variable GN
                [delPar, nBounds, i_State, paramX0BX] = ...
                                  improv(F, G, Nparam, NparID, Nminmax, nBounds,...
                                  param_min, param_max, param, i_State, parFlag,...
                                  NX0ID, integMethod, state_eq, obser_eq, Ndata,...
                                  Ny, Nu, Nzi, Nx, dt, t, x0, Uinp, Z, izhf, ...
                                  iArtifStab, StabMat, currentCost, LineSrch, ...
                                  paramX0BX, parFlagX0, NBXID, parFlagBX, NbX); 

            elseif iOptim == 2,   % Levenberg-Marquardt, Section 4.13
                [delPar, lamda] = ...
                         LMmethod(integMethod, state_eq, obser_eq, Ndata, Ny, ...
                                  Nu, Nzi, Nx, Nparam, NparID, lamda, param, ...
                                  parFlag, t, x0, Uinp, Z, izhf, F, G, ...
                                  tolR, currentCost, iArtifStab, StabMat, ...
                                  NX0ID, paramX0BX, parFlagX0, ...
                                  NBXID, NbX, bXpar, parFlagBX);                
            end 
             
            % update parameter vector param, initial conditions x0, and bias 
            % parameters bX; Eq. (4.29)
            param_old = paramX0BX;
            [param, x0, bXpar, paramX0BX] = ...
                        parUpdate(paramX0BX, x0, bXpar, delPar, parFlag, parFlagX0, ...
                                  parFlagBX, Nzi, Nx, Nparam, NbX, NparID, NX0ID);
            
            % Update iteration count, reset khalb and prevCost (for next iteration)
            prevCost = currentCost;
            iter  = iter + 1;
            khalf = 0;

        end;       % end of if (iter == niter_max),
        
    end;           % end of if (relerror < tolR) & (iter > 0), / else
  
end;               % end of while iter <= niter_max;

%-----------------------------------------------------------------------------------
% Print final parameter estimates, standard deviations and correlation coefficients
if  iter > 0,
    par_std_rel = par_accuracy(iter, Nparam, param, param_min, param_max,...
                               par_std, pcov, parFlag, NparID,...
                               NX0ID, Nx, Nzi, x0, parFlagX0,...
                               NbX, NBXID, bXpar, parFlagBX);
end

%-----------------------------------------------------------------------------------
% plots of measured and estimated time histories of outputs and inputs
% convergence plot of parameter estimates
if (test_case == 1),
    [t]=plots_TC01_oem_lat(t, Z, Y, Uinp, params, par_std, iter);
elseif (test_case == 2),
    [t]=plots_TC02_oem_SimNoise(t, Z, Y, Uinp, params, par_std, iter);
elseif (test_case == 3),
    [t]=plots_TC03_oem_lat_pr(t, Z, Y, Uinp, params, par_std, iter);
elseif (test_case == 4),
    [t]=plots_TC04_oem_hfb(t, Z, Y, Uinp, params, par_std, iter);
elseif (test_case == 5),
    [t]=plots_TC05_prop_lat(t, Z, Y, Uinp, params, par_std, iter);
elseif (test_case == 6  |  test_case == 7  |  test_case == 8  | ...
        test_case == 9  |  test_case == 10),
    [t]=plots_TC08_oem_uAC(t, Z, Y, Uinp, params, par_std, iter);
elseif (test_case == 11),
    [t]=plots_TC11_oem_sp(t, Z, Y, Uinp, params, par_std, iter);
elseif (test_case == 12),
    [t]=plots_TC11_oem_sp(t, Z, Y, Uinp, params, par_std, iter);
elseif (test_case == 22),  
    [t]=plots_TC22_oem_fpr(t, Z, Y, Uinp, params, par_std, iter);
elseif (test_case == 23 | test_case ==24),  
    [t]=plots_TC23_attas_regLonLat(t, Z, Y, Uinp, params, par_std, iter);
elseif (test_case == 27),  
    [t]=plots_TC27_oem_regQStall(t, Z, Y, Uinp, params, par_std, iter);
% elseif (test_case == 22),  
%     [t]=plots_TC32_oem_fpr(t, Z, Y, Uinp, params, par_std, iter);
elseif (test_case == 31),
    [t]=plots_TC01_oem_lat(t, Z, Y, Uinp, params, par_std, iter);
elseif (test_case == 32),  
   [t]=plots_TC32_oem_fpr(t, Z, Y, Uinp, params, par_std, iter);
elseif (test_case == 33),  
    [t]=plots_TC33_oem_fpr(t, Z, Y, Uinp, params, par_std, iter);
elseif (test_case == 34),
    [t]=plots_TC34_oem_lat(t, Z, Y, Uinp, params, par_std, iter);
end
