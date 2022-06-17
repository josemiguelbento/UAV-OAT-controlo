function [sy, szmsy, sx, sxstd] = efrls_mod(state_eq, obser_eq,...
                                            ts, Z, Uinp, Ndata, Ny, NparID, Nxp, Nu,...
                                            Nx, Nparam, dt, lamda, p0, param, parFlag,...
                                            xh, delxa);
                                        
% State estimator without knowledge of noise covariances:
% Extended forgetting factor Recursive Least Squares (EFRLS) method
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
%    lamda         forgetting factor
%    p0            Initial state propagation error covariance, (Nxp): only diagonal terms
%    param         parameter vector (Nparam)
%    parFlag       flags for free and fixed parameters (=1, free parameter, 0: fixed)
%    xh            Starting values for the augmented state vector (system states + parameters)
%    delxa         Perturbations to compute approximations of system matrices
%
% Outputs:
%    sy            estimated model ouptuts, (Ndata,Ny)
%    szmy          Residualy (z-y), (Ndata,Ny)
%    sx            estimated augmented states, i.e. (system states + parameters), (Ndata,Nxp)
%    sxstd         standard deviations of estimated states, (Ndata,Nxp)


%--------------------------------------------------------------------------
% State propagation error covariance matrix - pcov
pktilde = diag(p0);        

% First data point; compute outputs, store outputs and error
u1      = Uinp(1,1:Nu);
param(find(parFlag~=0)) = xh(Nx+1:Nx+NparID);
y       = feval(obser_eq, ts, xh, u1, param);
sy(1,:) = y';
sx(1,:) = xh';
szmsy(1,:) = Z(1,1:Ny) - sy(1,1:Ny);
        
% Recursive Least Squares estimation starts here (loop for the data points)
for k=2:Ndata
    
   	u1 = Uinp(k-1,1:Nu);        
    u2 = Uinp(k,1:Nu);   	    
    param(find(parFlag~=0)) = xh(Nx+1:Nx+NparID);
    xt = ruku4_aug(state_eq, ts, xh, dt, u1, u2, param', Nx, Nxp, Nparam);
    
    delxa = 1.0d-7*xh;
    for ix=1:Nxp;
        if (delxa(ix) == 0),
            delxa(ix) = 1.0d-7;
        end
    end
    
    % Computation of linearized state matrix A and state transition matrix phi
    Amat = sysmatA(state_eq, Nxp, Nx, Nparam, NparID, xh, delxa, u1,...
                                 param, parFlag, ts);    % System matrix A
    phi  = expm(Amat*dt);
    
    % Kalman gain matrix
    Cmat = sysmatC(obser_eq, Ny, Nxp, Nx, Nparam, NparID, xh, delxa,...
                             u2, param, parFlag, ts);    % Observation matrix 
    RINO = lamda*eye(Ny,Ny) + Cmat*phi*pktilde*phi'*Cmat';
    kkg  = pktilde*phi'*Cmat'*inv(RINO);
	    
    param(find(parFlag~=0)) = xt(Nx+1:Nx+NparID);
    y       = feval(obser_eq, ts, xt, u2, param);
    zmy     = Z(k,1:Ny)' - y;
    xh      = xt + phi*kkg*zmy;
    pktilde = inv(lamda)*phi*(eye(Nxp)-kkg*Cmat*phi)*pktilde*phi';
        
    % standard deviations for plot
    std_dev = sqrt(diag(pktilde)); 

	sx(k,:) = xh';
	sy(k,:) = y';
   	szmsy(k,:) = Z(k,1:Ny) - sy(k,1:Ny);
    sxstd(k,:) = std_dev';    
    
end      % end of RLS

return
% end of function
