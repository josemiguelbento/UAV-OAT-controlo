function [sy, szmsy, sx, sxstd] = ekf_mod(state_eq, obser_eq, ts, Z, Uinp, ...
                                          Ndata, Ny, NparID, Nxp, Nu, Nx, Nparam, ...
                                          dt, rr, qq, pp, param, parFlag, xt, delxa);

% Extended Kalman Filter (EKF) for combined state and parameter estimation
%
% Chapter 7: Recursive Parameter Estimation 
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% by Ravindra V. Jategaonkar
% published by AIAA, Reston, VA 20191, USA
%
% Inputs:
%    state_eq      function coding the state equations
%    obser_eq      function coding the observation equations
%    ts            time vector
%    Z             measured outputs (Ndata,Ny)
%    Uinp          measured inputs (Ndata,Nu) 
%    Ndata         number of data points
%    Ny            number of output variables
%    NparID        number of unknown parameters being estimated
%    Nxp           number of augmented state (=Nx+NparID)
%    Nu            number of input variables
%    Nx            number of state variables
%    Nparam        total number of parameters appearing in the postulated model
%    dt            sampling time
%    rr            Measurement noise covariance matrix, (Ny): only diagonal terms
%    qq            Process noise covariance matrix, (Nxp) - only diagonal terms
%    param         parameter vector (Nparam)
%    parFlag       flags for free and fixed parameters (=1, free parameter, 0: fixed)
%    pp            Initial state propagation error covariance, (Nxp): only diagonal terms
%    xt            Starting values for the augmented state vector (system states + parameters)
%    delxa         Perturbations to compute approximations of system matrices
%
% Outputs:
%    sy            estimated model ouptuts, (Ndata,Ny)
%    szmy          Residualy (z-y), (Ndata,Ny)
%    sx            estimated augmented states, i.e. (system states + parameters), (Ndata,Nxp)
%    sxstd         standard deviations of estimated states, (Ndata,Nxp)


%--------------------------------------------------------------------------
% Note: There are different approaches possible to treat the first data 
% point. Slightly different implementations result based on the whether 
% we consider the specified initial xa0 and pa0 as those for the corrected
% states xhat or for the predicted states xtilde. The exact procedure is 
% irrelevant to recursive estimation, since the estimates get anyway 
% updated immediately thereafter; the overall performance in terms of 
% convergence and final estimates is not affected much. For the sake of
% convenience, here we assume that the initial specified values pertain 
% to the predicted states xa. This allows the information available at 
% the first discrete point to be utilized best.


% State propagation error covariance matrix - P(Nxp X Nxp)
ptilde = diag(pp);
% Process noise covariance matrix - Q0: (Nxp x Nxp)
Q0 = diag(qq);
% Measurement noise covariance matrix - R0: (Ny x Ny)
R0 = diag(rr);

%--------------------------------------------------------------------------
% Recursive filtering starts here (loop for the data points)
for k=1:Ndata,

    u1c(:,1) = Uinp(k,1:Nu)';                              % Exogenous control inputs  

    %----------------------------------------------------------------------
    % Prediction step (Extrapolation / time update): 
    if k > 1,
        % u1p and u1c for interpolation during intermedite steps of Runge-Kutta
        u1p(:,1) = Uinp(k-1,1:Nu)'; 

        param(find(parFlag~=0)) = xh(Nx+1:Nx+NparID);
        % Numerical integration 
        xt = ruku4_aug(state_eq, ts, xh, dt, u1p, u1c, param, Nx, Nxp, Nparam);

        % Linearized state natrix
        Amat = sysmatA(state_eq, Nxp, Nx, Nparam, NparID, xh, delxa, u1p,...
                                                          param, parFlag, ts); 
        % State transition matrix
        Phi  = eye(Nxp);
        for j1=1:10,
            Phi = Phi + (Amat^j1)*(dt^j1)/(factorial(j1)); % Taylor series
        end
        % Phi = expm(Amat*dt);                             % Matrix exponential
        
        % Propagation of covariances
        ptilde  = Phi*phat*Phi' + Q0;
    end

    %----------------------------------------------------------------------
    % Correction step (Measurement update)
    
    % Model outputs
    param(find(parFlag~=0)) = xt(Nx+1:Nx+NparID);
    y   = feval(obser_eq, ts, xt, u1c, param);

    % Linearized observation matrix
    Cmat  = sysmatC(obser_eq, Ny, Nxp, Nx, Nparam, NparID, xt, delxa,...
                              u1c, param, parFlag, ts);    % Observation matrix
                          
    % Kalman gain matrix Kgain
    Kgain = ptilde*Cmat'*inv(Cmat*ptilde*Cmat' + R0);      % Kgain by matrix inversion
    % Kgain = ptilde*Cmat'/(Cmat*ptilde*Cmat' + R0);       % 

    % State update
    z   = Z(k,1:Ny)';                                      % Measured variables
    res = z - y;                                           % Output Residual 
    xh  = xt + Kgain*res;                                  % State Update   

    % Covariance matrix update; 
    % phat = (eye(Nxp)-Kgain*Cmat)*ptilde;                 % short form 
    phat = (eye(Nxp) - Kgain*Cmat)*ptilde*(eye(Nxp) - Kgain*Cmat)'...
                                 + Kgain*R0*Kgain';        % Long (Joseph) form
    
    %----------------------------------------------------------------------
    % Save model output, estimated states, residuals and standard deviations for plots
    sy(k,1:Ny) = y';               
    sx(k,:)    = xh';    
    szmsy(k,:) = Z(k,1:Ny) - sy(k,1:Ny);
    sxstd(k,:) = sqrt(diag(phat))';
    
end      % end of EKF (i.e., of recursive filtering)

return
% end of the function
