% Maximum Likelihood parameter estimation:
% Filter Error Method accounting for process and measurement noise -- LINEAR SYSTEMS
% Applicable to linear systems only (Section 5.2)
% Relaxation algorithm:
%     Step 1: Explicit estimation of R (covariance matrix of residuals)
%     Step 2: Gauss-Newton method for optimization of cost function w.r.t. parameters
%
% Chapter 5: Filter Error Method
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA

clear all;
close all;

% Select the test case to be analyzed:
test_case = 2;                    % Lateraldirectional motion, simulated data with turbulence

global NA  iA  kA  jA  Abet  NB  iB  kB  jB  Bbet
global NC  iC  kC  jC  Cbet  ND  iD  kD  jD  Dbet
global NF  iF  kF  jF  Fbet
global NALF  NBET  iP  NK
global NBX  iBX  jBX  XGAM  NGAM
global NBY  iBY  jBY  YDEL  NDEL

%----------------------------------------------------------------------------------------
% Model definition: system matrices, initial parameter values, flight data
if  test_case == 2,
    [param, Anames, Bnames, Cnames, Dnames, Fnames, BXnames, BYnames,...
       iSD, SD_yError, Nx, Nu, Ny, Ts, dt, Ndata, Z, Uinp, x0] = mDefCase02_lin(test_case);
end

%----------------------------------------------------------------------------------------
% Convergence limit in terms of relative change in thc cost function
tolR      = 1e-4;            %tolR      = 1e-3;
% max number of iterations
niter_max = 15;

% Iteration count from which F-estimate will be corrected using latest R-estimate
iterFupR = 3;

%----------------------------------------------------------------------------------------
% Initialize iteration counter, counter for halving step, etc.
iter     = 0;
khalf    = 0;
prevcost = 0;
iFup     = 0;
iFcmp    = 0;
ihalved  = 0;      % Monitors if the parameter step has been halved or not. 
                   % This is used to overwrite parameters for convergence plots
disp('Parameter estimation applying Maximum Likelihood (Filter Error) Method:');


% Build up of system matrices 
[Amat, Bmat, Cmat, Dmat, Fmat, BX, BY, parVal, Nparam] = mod_sysmat(param, Anames,...
                                                         Bnames, Cnames, Dnames, Fnames, ...
                                                         BXnames, BYnames);
% Store parameter values for plotting purposes
params   = parVal;
par_std  = zeros(Nparam,1);

Pcov  = zeros(Nx);
Kgain = zeros(Nx,Ny);

%----------------------------------------------------------------------------------------
% Initial measurement noise covariance matrix R
if  iSD == 0,                                   % Default values
    [currentcost, R, RI, Y, SXtilde, SXhat, SZmY, Phi, Chi] = ...
                              costfun_fem_lin(Amat, Bmat, Cmat, Dmat, BX, BY, ...
                                              Ndata, Ny, Nu, Nx,...
                                              dt, x0, Uinp, Z, parVal, Kgain);
    disp(['cost function: det(R) - default value = ' num2str(currentcost)]);
else
    % Specified as standard deviations of output errors
    disp (' ');
    disp ('Initial noise covariance matrix R -- Standard deviations of the output errors:');
    disp(num2str(SD_yError))
    RI = diag(1./SD_yError.^2);
end

%----------------------------------------------------------------------------------------
% Iteration Loop (Jump back address)
while iter <= niter_max;

    while iFcmp <= 0;
        % Decompose parVal into system matrices
        [Amat, Bmat, Cmat, Dmat, Fmat, BX, BY] = par2sysmat(parVal, Anames,...
                                                            Bnames, Cnames, Dnames, Fnames,...
                                                            BXnames, BYnames);

        % Compute steady-state Kalman Gain matrix
        xt = x0;
        [Kgain, Pcov] = gainmat_lin(Amat, Cmat, Fmat, Nx, Ny, Nu, Nparam,...
                                                dt, parVal, xt, Uinp, RI); 
                                                
        % estimate covariance matrix R; determinant and inverse of R
        xt = x0;
        [currentcost, R, RInew, Y,  SXtilde, SXhat, SZmY, Phi, Chi] = ...
                                     costfun_fem_lin(Amat, Bmat, Cmat, Dmat, BX, BY, ...
                                                     Ndata, Ny, Nu, Nx, ... 
                                                     dt, xt, Uinp, Z, parVal, Kgain);
        
        if  iFup == 0,
            % Print out the iteration count, parameter values and cost function
            disp(' ');
            disp(['iteration = ', num2str(iter)]);
            %disp('param'); parVal'
            disp(['cost function: det(R) = ' num2str(currentcost)]);
            iFcmp = 1;
        else
            disp('Correction of F (with the new estimated value of R)');
            %disp('param'); parVal
            disp(['cost function: det(R) = ' num2str(currentcost)]);
        
            if  currentcost > prevcost,
                disp('Local divergence after F-compensation ');
                khalf = khalf + 1;
                if  khalf < 3,              % Allow 2. step of halving
                    for i1=1:NF, i3 = jF(i1); parVal(i3) = (parVal(i3)+FAlt(i1))/2; end
                elseif  khalf == 3,         % At 3rd halving restore previous values
                    for i1=1:NF, i3 = jF(i1); parVal(i3) = FAlt(i1); end    % Restore previous F values
                    RI = RIAlt;
                else                        % After 3rd halving, discontinue F-correction 
                    iFcmp = 1;              % and proceed to the next full step.
                end
            else
                iFcmp = 1;                  % Set iFcmp > 0 after halving is done
            end
        end
        
    end   % end of while iFcmp <= 0
    % khalf = 0;                            % 2014-04-23

    % Store parameters and standard deviations only if successful step: convergence plot 
	if (ihalved ==0)
        if  (iter > 0 & iFup == 0 )  | (iter > 0 & iFcmp ==1 ),
            params  = [params, parVal];
            pcov    = inv(F);
            par_std = [par_std, sqrt(diag(pcov))];    
        end
	else
		params(:,end) = parVal;             % save only the latest one when halved
	end

    %------------------------------------------------------------------------------------
    % Check convergence: relative change in the cost function
    relerror = abs((currentcost-prevcost)/currentcost);

    if (relerror < tolR) && (iter > 0)  &&  (iFcmp == 0),
        
        disp('Iteration concluded: relative change in det(R) < tolR')
        break;
        
    else
        
        if  iter == niter_max,
            disp(' ');
            disp('Maximum number of iterations reached.');
            break;
            
        elseif (currentcost > prevcost) && (iter > 0),
        
            % Maximum of 10 times halving of the parameters
            if  khalf == 10,
                disp('Intermediate divergence!')
                disp('Error termination:')
                disp('No further improvement after 10 times halving of parameters.')
                break;
            else
                disp('Intermediate divergence: halving of parameter step')
                parVal =(parVal+param_old)/2;
                khalf  = khalf + 1;
                iFcmp = 0;             % 2014-04-23
                % iter  = iter + 1;    % 2014-04-23 ??
                ihalved = 1;           % 2014-04-23
            end; 
            
        else
            
            %----------------------------------------------------------------------------
			ihalved = 0;               % 2014-04-23
            xt = x0;
            NK = NBET;
            
            % Compute gradients of P-matrix: gradP(Nx,Nx,Nbet)
            gradP = lyapun(Nx, Ny, dt, Amat, Cmat, Pcov, Kgain, Fmat, RI);
                        
            % Compute gradients of K-matrix: grdK(Nx,Ny,Nbet)
            grdK  = gradK(Nx, Ny, Nparam, NK, NBET, NC, Cmat, RI, Pcov, gradP);
            
            % Compute the matrix of second gradients F and gradient G
            [F, G] = gradxy_lin(Nx, Nu, Ny, Nparam, NBET, Ndata,...
                                    Uinp, SXtilde, SXhat, SZmY, Cmat, Kgain, ...
                                    grdK, RI, Phi, Chi);

            % Compute parameter update using Cholesky factorization: 
            uptF   = chol(F);                    % Upper triangular F = uptF'*uptF 
            delPar = uptF \ (uptF'\G);

            % Check for the inequality contraints KC <= 1
            NparID = Nparam;
            delPar = kcle1_lin(Nx, Ny, Nparam, NparID, NK, delPar, Cmat, Kgain, grdK, F);
             
            %----------------------------------------------------------------------------
            % Update parameter vector param
            param_old = parVal;
            parVal    = parVal + delPar;
            
            prevcost = currentcost;
            iter  = iter + 1;
            iFcmp = 0;
            khalf = 0;                            % 2014-04-23
            
            if  iter >= iterFupR,                 % F compensation using new R
                
                khalf = 1;                        % Initialize counter
                while  khalf ~= 0,                % Jump back address; 2014-04-23
                    
                    % Decompose parVal into system matrices
                    [Amat, Bmat, Cmat, Dmat, Fmat, BX, BY] = par2sysmat(parVal, Anames,...
                                                             Bnames, Cnames, Dnames, Fnames,...
                                                             BXnames, BYnames);
                    % Compute steady-state Kalman Gain matrix
                    xt = x0;
                    [Kgain, Pcov] = gainmat_lin(Amat, Cmat, Fmat, Nx, Ny, Nu, Nparam,...
                                                dt, parVal, xt, Uinp, RI);

                    % Estimate covariance matrix R; determinant and inverse of R
                    xt = x0;
                    [currentcost, R, RInew, Y,  SXtilde, SXhat, SZmY, Phi, Chi] = ...
                                     costfun_fem_lin(Amat, Bmat, Cmat, Dmat, BX, BY, ...
                                                     Ndata, Ny, Nu, Nx, ... 
                                                     dt, xt, Uinp, Z, parVal, Kgain);
                        
                    if (khalf == 1), disp(' '); end
                    disp(['iteration = ', num2str(iter)]);
                    %disp('param'); parVal'
                    disp(['cost function: det(R) = ' num2str(currentcost)]);

                    relerror = abs((currentcost-prevcost)/currentcost);
                    if  relerror < tolR,
                        % On eps-convergence after the full iteration, no need to carry out
                        % F-compensation, because at the true minimum it would not (or rather
                        % should not) lead to any changes in det(R). Hence, terminate.
                        disp(' ')
                        disp('Iteration concluded: relative change in det(R) < tolR')
                        params  = [params, parVal];
                        pcov    = inv(F);        % save param and std.Dev for conver-plot
                        par_std = [par_std, sqrt(diag(pcov))];    
                        break
                        
                    elseif  currentcost > prevcost,
                        if  khalf == 10,         % Maximum 10 times halving of parameters
                            disp('Error termination:')
                            disp('No further improvement after 10 times halving of parameters.')
                            break;
                        else
                            disp('Intermediate divergence: halving of parameter step')
                            parVal = (parVal+param_old)/2;
                            khalf  = khalf + 1;
                        end
                    else
                        khalf = 0;
                    end
                end
                
				if khalf == 10 
					param = param_old; % go back to old parameters. These are the last to make sense.
					iter = iter - 1;
					break; % error termination.
				elseif relerror < tolR
					break; % converged.
				end
                
                prevcost = currentcost;
                            
                paralt = parVal;
                for i1=1:NF, i3 = jF(i1); FAlt(i1) = parVal(i3); end    % Remember previous F values
                RIAlt  = RI;
                
                % Compensate F-estimates using new RI
                parVal = fcompn_lin(NF, jF, FAlt, RInew, RI, Cmat, parVal);
               
                RI    = RInew;
                iFup  = 1;
                iFcmp = 0;
                % khalf = 0;             % 2014-04-23
                
            end    % end of "if iter >= iterFupR, % F compensation using new R"
            
        end    % end of "if iter == niter_max, elseif currentcost > prevcost & iter > 0 , else"
        
    end    % end of "if (relerror<tolR) & (iter > 0)  & (iFcmp ==0)"         
     
end    % end of "while iter <= niter_max;"


%----------------------------------------------------------------------------------------
% Printout of final parameter estimates, standard deviations and correlation coefficients
if  iter > 0,
    par_std_rel = par_accuracy_lin(iter, Nparam, parVal, par_std, pcov);
end

% Printout of estimated parameters as system matrices:
[Amat, Bmat, Cmat, Dmat, Fmat, BX, BY] = par2sysmat(parVal, Anames,...
                                                    Bnames, Cnames, Dnames, Fnames,...
                                                    BXnames, BYnames);
%Anames,  Amat
%Bnames,  Bmat
%Cnames,  Cmat
%Dnames,  Dmat

%----------------------------------------------------------------------------------------
% plots of measured and estimated time hsitories of outputs and inputs
% convergence plot of parameter estimates
if  test_case == 2,
    t = plots_TC02_oem_SimNoise(Ts, Z, Y, Uinp, params, par_std, iter);
end
