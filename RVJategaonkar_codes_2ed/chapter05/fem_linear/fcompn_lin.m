function parVal = fcompn_lin (NF, jF, FAlt, RInew, RIprev, Cmat, parVal)

% Revise the estimates of the process noise distribution matrix F to
% compensate for the RI revision by heuristic procedure (Eq. 5.41)
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
%    NF            number of free parameters of process noise distribution matrix F
%    jF            indices of unknown parameters appearing in F-matrix
%    FAlt          elements of F matrix prior to compensation
%    RInew         inverse of updated R 
%    RIprev        inverse of R from the previous step
%    Cmat          linearized observation matrix
%    parVal        parameter vector
%
% Outputs:
%    parVal        parameter vector with compensated F-elements


%-------------------------------------------------------------------------------- 
% Check whether all of the F elements are fixed; if yes, return
% if (NF == 0), return, end; 

% If some or all of the F-elements (diagonal) are free, then update them:
if  NF > 0,
    
    % sqrt(rold/rnew): only diagonal terms are required
    rRatio = diag( sqrt(RIprev/RInew) );

    % Correction factor: term in the bracket on rhs of Eq. (5.41)
    ph1 = ( Cmat.^2' * (diag(RIprev).*rRatio) ) ./ ( Cmat.^2' * diag(RIprev) );
     
    for ip=1:NF,
        i3 = jF(ip);
        FALT(ip)   = parVal(i3);
        parVal(i3) = parVal(i3)*ph1(ip);         % Eq. (5.41)
    end
    
end

return
% end of function
