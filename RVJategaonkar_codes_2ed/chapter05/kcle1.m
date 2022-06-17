function delPar = kcle1(Nx, Ny, Nparam, NparID, Nk, delPar, Cmat, Kgain, gradKC, F)

% Constrain the diagonal elements of KC to be less than or equal to 1:
%
% Chapter 5: Filter Error Method
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA
%
% Inputs:
%    Nx            number of state variables
%    Ny            number of output variables
%    Nparam        total number of parameters appearing in the postulated model
%    NparID        number of unknown parameters being estimated
%    Nk            number of parameters affecting the gain matrix
%    delPar        parameter update (Delta-Theta)
%    Cmat          linearized observation matrix
%    Kgain         Kalman filter gain matrix
%    gradKC        gradients of KC
%    F             information matrix
%
% Outputs:
%    delPar        parameter update after constrained optimization


%--------------------------------------------------------------------------------------
% Inverse of the second gradient of the cost function
uptF = chol(F);                             % Upper triangular F = uptF'*uptF 
g2J  = uptF \ ( uptF'\eye(NparID) );        % Inverse by Cholesky factorization

% Linear approximation of the constraint: Eq. (5.35)
KCineq = diag(Kgain*Cmat) + gradKC*delPar - 1;

% Check for KCineq to be <= 1
clear S;
clear M_dKCdPar;                            % No. of rows of M vary; clear M_dKCdPar 
kk = 0;

for ix=1:Nx, 
    if  KCineq(ix) > 0,
        kk = kk +1;
        S(kk) = KCineq(ix);                 % Eq. (5.37);  S(i)
        M_dKCdPar(kk,:) = gradKC(ix,:);     % Eq. (5.38);  M(i,j)
    end
end

%--------------------------------------------------------------------------------------
% Check whether constraints are violated or not; if so, compute constrained solution
if  kk > 0,
    
    % M*d2J/dTh2*M' (quantity within the flower bracket of Eq. 5.39)
    Mg2JMt = M_dKCdPar*g2J*M_dKCdPar';
    
    % Inverse of M*d2J/dTh2*M' and multiplication by S: (solve using Cholesky factorization)
    uptMg2JMt = chol(Mg2JMt);
    wv1       = uptMg2JMt \ (uptMg2JMt'\S'); 
    
    % Premultiply by d2J/dTh2*M'
    delParCon = g2J*M_dKCdPar'*wv1;
    
    % Contrained solution: Eq. (5.39)
    delPar = delPar - delParCon;
    
end

return
% end of function
