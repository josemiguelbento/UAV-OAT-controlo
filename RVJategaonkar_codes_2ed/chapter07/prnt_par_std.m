function [par_avg, std_avg] = prnt_par_std(method, Nx, NparSys, Ndata, parFlag, NavgPt,...
                                                   sx, sxstd);

% Compute average parameter values and standard deviations over NavgPt points
% and print the same.
%
% Chapter 7: Recursive Parameter Estimation
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% by Ravindra V. Jategaonkar
% published by AIAA, Reston, VA 20191, USA
%
% Inputs:
%    method        recursive parameter estimation method
%    Nx            number of state variables
%    NparSys       Number of system parameters
%    Ndata         number of data points
%    parFlag       flags for free and fixed parameters (=1, free parameter, 0: fixed)
%    NavgPt        number of points for averaging
%    sx            estimated augmented states, i.e. (system states + parameters), (Ndata,Nxp)
%    sxstd         standard deviations of estimated states, (Ndata,Nxp)
%
% Outputs:
%    par_avg       estimated parameters (average over last NavgPt points)
%    std_avg       standard deviations (average over last NavgPt points)


% parameter values and their standard deviations: average over last NavgPt points
par_avg = mean(sx(Ndata-NavgPt+1:Ndata,Nx+1:end))';
std_avg = mean(sxstd(Ndata-NavgPt+1:Ndata,Nx+1:end))';

if (strcmp(method,'EKF')  |  strcmp(method,'UKF')  |  strcmp(method,'UKFaug')  | strcmp(method,'FTR'))
    
    par_prnt = sprintf('Estimated Parameters with %s: Average of last %d points',method,NavgPt);
    disp(par_prnt)
    disp(' No.   Parameter        Std. deviation     Relative Std. Dev (%)')
    iPar = 0;
    for ip=1:NparSys,
        if  parFlag(ip) > 0,
            iPar = iPar + 1;
            par_std_rel = Inf;
            if par_avg(iPar) ~= 0,
                par_std_rel = 100*std_avg(iPar)/abs(par_avg(iPar));
            end
            par_prnt = sprintf('%3i   %13.5e     %10.4e      %8.2f',...
                                  ip, par_avg(iPar), std_avg(iPar), par_std_rel);
            disp(par_prnt)
        end
    end
    
elseif (strcmp(method,'EFRLS'))
    
    par_prnt = sprintf('Estimated Parameters with %s: Average of last %d points',method,NavgPt);
    disp(par_prnt)
    disp(' No.   Parameter ')
    for ip=1:NparSys,
        par_prnt = sprintf('%3i   %13.5e ', ip, par_avg(ip));
        disp(par_prnt)
    end

end

    
