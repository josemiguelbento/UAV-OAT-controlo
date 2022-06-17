function par_std_rel = par_accuracy(iter, Nparam, param, par_std, pcov, parFlag, NparID)

% print out standard deviations and relative standard deviations of estimated parameters
% and correlation coefficients among them.
%
% Chapter 5: Filter Error Method
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA
%
% Inputs:
%    iter          number of iterations
%    Nparam        total number of parameters appearing in the postulated model
%    param         vector of estimated parameters
%    par_std       standard deviations of parameters at each iteration
%    pcov          parameter error covariance matrix
%    parFlag       flags for free and fixed parameters (=1, free parameter, 0: fixed)
%    NparID        number of unknown parameters being estimated
%
% Outputs:
%    par_std_rel   relative standard deviations


if  iter > 0,
    disp(' ')
    disp('Index  Parameter      Standard Dev.   Rel. Std. Dev.')

    iPar=0;
    for ip=1:Nparam,
        if  parFlag(ip) > 0,
            iPar = iPar + 1;
            par_std_rel = Inf;
            if param(ip) ~= 0,
                par_std_rel = 100*par_std(iPar,iter+1)/abs(param(ip));
            end
            par_prnt = sprintf('%3i   %13.5e   %10.4e   %8.2f',...
                                  ip, param(ip), par_std(iPar,iter+1), par_std_rel);
            disp(par_prnt)
        end
    end

    % Correlation coefficients matrix: pcorr(i,j) = pcov(i,j)/sqrt(pcov(i,i)*p_cov(j,j))
    hlf = ones(NparID);
    for ip=1:NparID, 
        hlf(ip,:) = hlf(ip,:) / sqrt(pcov(ip,ip));
    end
    pcorr = pcov .* hlf .* hlf';
    
    disp(' ')
    disp('The following free parameters have a correlation of more than 0.9:');
    disp('par_i   par_j   corr_coeff');

    for ip=2:NparID,
        for jp=1:ip-1,
            scorr = abs(pcorr(ip,jp));
            if  scorr > 0.9,
                cor_prnt = sprintf( '%3i     %3i    %8.2f', ip, jp, scorr );
                disp(cor_prnt)
            end
        end
    end
end
