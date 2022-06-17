function delPar = kcle1_lin(Nx, Ny, Nparam, NparID, Nk, delPar, Cmat, Kgain, gradK, F)

% Constrain the diagonal elements of KC to be less than or equal to 1:
%
% Chapter 5: Filter Error Method
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA
%
% Filter error method for linear systems (ml_fem_linear)
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
%    gradK         gradients of K
%    F             information matrix
%
% Outputs:
%    delPar        parameter update after constrained optimization


%--------------------------------------------------------------------------------------
global NC  iC  kC  jC  Cbet
    
% Compute gradient of KC-diagonal
gradKC = zeros(Nx,Nparam);
for i=1:Nk,
    gradKC(:,i) = diag(gradK(:,:,i)*Cmat);
end

for kk=1:NC,
    i2 = jC(kk);
    if  i2 > 0,
        i1 = iC(kk);
        i3 = kC(kk);
        gradKC(i3,i2) = gradKC(i3,i2) + Kgain(i3,i1)*Cbet(kk);
    end
end

% Inverse of the second gradient of the cost function
uptF = chol(F);                             % Upper triangular F = uptF'*uptF 
g2J  = uptF \ ( uptF'\eye(NparID) );        % Inverse by Cholesky factorization

% Linear approximation of the constraint: Eq. (5.35)
KCineq = diag(Kgain*Cmat) + gradKC*delPar - 1;

% Check for KCineq to be <= 1
clear S;
clear M_dKCdPar;                            % No. of rows of M vary; clear M_dKCdPar 
kk = 0;

for i=1:Nx, 
    if  KCineq(i) > 0,
        kk = kk +1;
        S(kk) = KCineq(i);                  % Eq. (5.37);  S(i)
        M_dKCdPar(kk,:) = gradKC(i,:);      % Eq. (5.38);  M(i,j)
    end
end

% Check whether constraints are violated or not; if so, compute constrained solution
if  kk > 0,
    
    % M*d2J/dTh2*M' (quantity within the flower bracket of Eq. 5.39)
    Mg2JMt = M_dKCdPar*g2J*M_dKCdPar';
    
    % Inverse of M*d2J/dTh2*M' and multiply by S: (solve using Cholesky factorization)
    uptMg2JMt = chol(Mg2JMt);
    wv1       = uptMg2JMt \ (uptMg2JMt'\S'); 
    
    % Premultiply by d2J/dTh2*M'
    delParCon = g2J*M_dKCdPar'*wv1;
    
    % Contrained solution: Eq. (5.39)
    delPar = delPar - delParCon;
    
end

return
% end of function
