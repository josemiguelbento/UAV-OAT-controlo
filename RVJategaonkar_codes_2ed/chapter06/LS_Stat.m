function [Yhat, par_std, par_std_rel, R2Stat] = LS_Stat(X, Y, parEst)

% Compute model output Yhat, the standard deviations of estimates par_std,
% the relative standard deviations par_std_rel, and the R-square statistics:
% caters to multivariate LS/TLS estimation 
%
% Chapter 6, Equation Error Methods
% Flight Vehicle System Identification - A Time Domain Methodology
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA
%
% Inputs:
%    X            Independent variables
%    Y            Dependent variables
%    parEst       Estimated parameters
%
% Outputs:
%    Yhat         Model estimated outputs
%    par_std      Absolute standard deviations
%    par_std_rel  Relative standard deviations
%    R2Stat       R-square statistics


[Npt, Npar]     = size(X);
[Npar, Nmultiv] = size(parEst);

for imulV=1:Nmultiv,
    
    Yhat    = X*parEst(:,imulV);
    sigma2  = sum( (Y(:,imulV)-Yhat).^2 ) / (Npt-Npar);
    pCov    = sigma2*inv(X'*X);

    par_std = sqrt(diag(pCov));
    par_std_rel = par_std*100./abs(parEst(:,imulV));

    Yavg   = sum(Y(:,imulV))/Npt;
    R2Stat = sum( (Yhat-Yavg).^2 ) / sum( (Y(:,imulV)-Yavg).^2 );

    disp('No.    value          Std. Deviation    Relative Std. Deviation') 
    for ip=1:Npar,
        par_prnt = sprintf('%3i   %13.5e   %10.4e   %8.2f',...
                              ip, parEst(ip,imulV), par_std(ip), par_std_rel(ip));
        disp(par_prnt)
    end
    par_prnt = sprintf('R-square statistics: = %13.5e',R2Stat);
    disp(par_prnt)
end

return