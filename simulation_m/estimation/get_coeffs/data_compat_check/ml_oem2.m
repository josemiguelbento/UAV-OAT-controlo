% Maximum Likelihood parameter estimation:
% Output Error Method accounting for measurement noise.
% Relaxation algorithm:
%     Step 1: Explicit estimation of R (covariance matrix of residuals)
%     Step 2: Gauss-Newton (or Levenberg-Marquardt) method for optimization of 
%             cost function w.r.t. parameters
%
% Chapter 4: Output Error Method
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA, January 2015

clear all;
close all;

global dt

%-----------------------------------------------------------------------------------
% Choose iOptim for optimization method: =1: Gauss-Newton; =2: Levenberg-Marquardt
%iOptim = 1;
iOptim = 2;

%-----------------------------------------------------------------------------------
% Choose numerical integration method:
integMethod = 'ruku4';     % ruku2, ruku3, ruku4 (2nd, 3rd or 4th order Runge-Kutta)

%-----------------------------------------------------------------------------------
% Model definition; functions for state derivatives and outputs

[state_eq, obser_eq, Nx, Ny, Nu, NparSys, Nparam, NparID, Nminmax,...
        dt, Ndata, Nzi, izhf, t, Z, Uinp, param, parFlag, param_min, param_max,...
        x0, iArtifStab, StabMat, LineSrch, parFlagX0, NX0ID, ...
                              bXpar, parFlagBX, NbX, NBXID] = mDefCase22();

% Verify model definition
iError = mDefCHK_oem(Nx, Ny, Nu, NparSys, Nparam, NparID, Nzi, ... 
                     Nminmax, iOptim, param, parFlag, param_min, param_max, ...
                     x0, iArtifStab, StabMat);
% iError ~= 0        % Error termination 

%-----------------------------------------------------------------------------------
% parameter perturbation size for gradient computation by numerical approximation
par_step  = 1e-6;
% par_step  = 1e-3;
% Convergence limit in terms of relative change in the cost function
tolR      = 1e-5;
% max number of iterations
niter_max = 100;

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
if (iOptim == 1)
    disp('Optimization method: Gauss-Newton method:');
elseif (iOptim == 2)
    disp('Optimization method: Levenberg-Marquardt method:');
    lamda = 0.001;
else
    disp('Error Termination:');
    disp('Wrong specification of the optimization method.');
    iError = 1;
end

if (strcmp(integMethod,'ruku2'))
    disp('Numerical integration method: Runge-Kutta 2nd order');
elseif (strcmp(integMethod,'ruku3'))
    disp('Numerical integration method: Runge-Kutta 3rd order');
elseif (strcmp(integMethod,'ruku4'))
    disp('Numerical integration method: Runge-Kutta 4th order');
else
    disp('Error Termination:');
    disp('Wrong specification of the integration method.');
    iError = 1;
end
  
% Initialize time counter
tMLIni = cputime;

% Single vector of system parameters, initial conditions and bias parameters
paramX0BX = param;
if ~isempty(x0)
    for kzi=1:Nzi
        paramX0BX = [paramX0BX; x0(:,kzi)];
    end
end
if ~isempty(bXpar)
    for kzi=1:Nzi
        paramX0BX = [paramX0BX; bXpar(:,kzi)];
    end
end

%-----------------------------------------------------------------------------------
% Iteration Loop (Jump back address)
while iter <= niter_max && ~iError

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
    if ( (currentCost < prevCost)  || ((relerror<tolR) && (iter > 0)) )
        params  = [params, param];
        pcov    = inv(F);                        % param error covar mat, Eq. (4.87)
        % par_std = [par_std, sqrt(diag(pcov))];   % standard deviations, Eq. (4.88)
        stdDev  = sqrt(diag(pcov));              % standard deviations, Eq. (4.88)
        stdDev(i_State~=0) = 0;
        par_std = [par_std, stdDev];
    end

    % Check convergence: relative change in the cost function
    % if convergence is achieved, stop the loop
    if (relerror < tolR) && (iter > 0)
        disp('convergence criterion is satisfied');
        break;

    else        
        if (iter == niter_max)
            if (currentCost < prevCost || niter_max == 0)
                disp('Maximum number of iterations reached.');
            else                  % to allow halving at itmax before terminating
                disp('Intermediate divergence: halving of parameter step')
                paramX0BX = (paramX0BX+param_old)/2;
                [param, x0, bXpar] = parDecomp(Nparam, Nx, Nzi, NbX, paramX0BX);
                half = khalf + 1;
            end
             
        elseif (currentCost > prevCost) && (iter > 0)
        
            % Maximum of 20 times halving of the parameters
            if (khalf == 20)
                disp('Intermediate divergence!')
                disp('Error termination:')
                disp('No improvement after 20 times halving of parameter step.')
                iError = 1;
            else
                disp('Intermediate divergence: halving of parameter step')
                paramX0BX = (paramX0BX+param_old)/2;
                [param, x0, bXpar] = parDecomp(Nparam, Nx, Nzi, NbX, paramX0BX);
                khalf = khalf + 1;
            end
            
        else
            
            % compute the matrix of second gradients F and gradient G, Eq. (4.30)
            
            % Perturbations for gradient computation by difference approximation
            par_del = par_step*paramX0BX(1:Nparam);       % param perturbations 
            par_del(find(par_del==0))     = par_step;     % if zero, set to par_step
            par_delX0 = par_step*x0;                      % X0 perturbations 
            par_delX0(find(par_delX0==0)) = par_step;     % if zero, set to par_step
            par_delbX = par_step*bXpar;                   % bX perturbations 
            par_delbX(find(par_delbX==0)) = par_step;     % if zero, set to par_step

            if isempty(x0) == 0
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
            if  iOptim == 1      % Unconstrained Gauss-Newton or bounded variable GN
                [delPar, nBounds, i_State, paramX0BX] = ...
                                  improv(F, G, Nparam, NparID, Nminmax, nBounds,...
                                  param_min, param_max, param, i_State, parFlag,...
                                  NX0ID, integMethod, state_eq, obser_eq, Ndata,...
                                  Ny, Nu, Nzi, Nx, dt, t, x0, Uinp, Z, izhf, ...
                                  iArtifStab, StabMat, currentCost, LineSrch, ...
                                  paramX0BX, parFlagX0, NBXID, parFlagBX, NbX); 

            elseif iOptim == 2   % Levenberg-Marquardt, Section 4.13
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

        end       % end of if (iter == niter_max),
        
    end           % end of if (relerror < tolR) & (iter > 0), / else
  
end               % end of while iter <= niter_max;

%-----------------------------------------------------------------------------------
% Print final parameter estimates, standard deviations and correlation coefficients
if  iter > 0
    par_std_rel = par_accuracy(iter, Nparam, param, param_min, param_max,...
                               par_std, pcov, parFlag, NparID,...
                               NX0ID, Nx, Nzi, x0, parFlagX0,...
                               NbX, NBXID, bXpar, parFlagBX);
end

%-----------------------------------------------------------------------------------
% plots of measured and estimated time histories of outputs and inputs
% convergence plot of parameter estimates

[t]=plots_TC22_oem_fpr(t, Z, Y, Uinp, params, par_std, iter);

%----------------------------------------------------------------------------------
% save biases to file
name = '_2023_02_01_14_21_28';
save(strcat('biases',name,'.mat'), 'param');