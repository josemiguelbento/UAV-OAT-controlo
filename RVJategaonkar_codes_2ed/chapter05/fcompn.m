function param = fcompn (Nx, Nparam, FAlt, RInew, RIprev, Cmat, param, parFlag)

% Revise the estimates of the process noise distribution matrix F to
% compensate for the RI revision by heuristic procedure (Eq. 5.41)
%
% Chapter 5: Filter Error Method
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA
%
% Inputs:
%    Nx            number of state variables
%    Ndata         number of data points
%    FAlt          elements of F matrix prior to compensation
%    RInew         inverse of updated R 
%    RIprev        inverse of R from the previous step
%    Cmat          linearized observation matrix
%    param         parameter vector
%    parFlag       flags for free and fixed parameters (=1, free parameter, 0: fixed)
%
% Outputs:
%    param         parameter vector with compensated F-elements


%-------------------------------------------------------------------------------- 
NF = size(find(parFlag(Nparam-Nx+1:Nparam)~=0),1);    % Number of free F-parameters

% Check whether all of the F elements are fixed; if yes, return
if (NF == 0), return, end; 

%-------------------------------------------------------------------------------- 
% Some or all of the F-elements (diagonal) are free:

% sqrt(rold/rnew): only diagonal terms are required
rRatio = diag( sqrt(RIprev/RInew) );

% Correction factor: Term in the bracket on rhs of Eq. (5.41)
ph1 = ( Cmat.^2' * (diag(RIprev).*rRatio) ) ./ ( Cmat.^2' * diag(RIprev) );
 
% Remember F values prior to correction (required in the case of local divergence):
FAlt = param(Nparam-Nx+1:Nparam);

% Correct F-matrix elements (only those which are being estimated):
for kk=1:Nx,
    iPar = Nparam-Nx+kk;
    if  parFlag(iPar) ~= 0,
        param(iPar) = param(iPar)*ph1(kk);
    end
end

return
% end of function
