function par_std_rel = par_accuracy_lin(iter, Nparam, param, par_std, pcov)

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
%
% Outputs:
%    par_std_rel   relative standard deviations


if  iter > 0,
    disp(' ')
    disp('Index  Parameter      Standard Dev.   Rel. Std. Dev.')
    for i=1:Nparam,
            par_std_rel = Inf;
            if param(i) ~= 0,
                par_std_rel = 100*par_std(i,iter+1)/abs(param(i));
            end
            par_prnt = sprintf('%3i   %13.5e   %10.4e   %8.2f',...
                                  i, param(i), par_std(i,iter+1), par_std_rel);
            disp(par_prnt)
    end

    % Correlation coefficients matrix: pcorr(i,j) = pcov(i,j)/sqrt(pcov(i,i)*p_cov(j,j))
    hlf = ones(Nparam);
    for i=1:Nparam, 
        hlf(i,:) = hlf(i,:) / sqrt(pcov(i,i));
    end
    pcorr = pcov .* hlf .* hlf';
    
    disp(' ')
    disp('The following free parameters have a correlation of more than 0.9:');
    disp('par_i   par_j   corr_coeff');

    for i=2:Nparam,
        for j=1:i-1,
            scorr = abs(pcorr(i,j));
            if  scorr > 0.9,
                cor_prnt = sprintf( '%3i     %3i    %8.2f', i, j, scorr );
                disp(cor_prnt)
            end
        end
    end
end
