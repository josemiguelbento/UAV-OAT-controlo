function par_std_rel = par_accuracy(iter, Nparam, param, param_min,...
                                    param_max, par_std, pcov, parFlag, NparID,...
                                    NX0ID, Nx, Nzi, x0, parFlagX0,...
                                    NbX, NBXID, bXpar, parFlagBX)

% print out standard deviations and relative standard deviations of 
% estimated parameters and correlation coefficients among them.
%
% Chapter 4: Output Error Method
% "Flight Vehicle System Identification - A Time Domain Methodology"
% Second Edition
% Author: Ravindra V. Jategaonkar
% Published by AIAA, Reston, VA 20191, USA
%
% Inputs:
%    iter          number of iterations
%    Nparam        total number of parameters in the postulated model
%    param         vector of estimated parameters
%    param_min     lower bounds
%    param_max     upper bounds
%    par_std       standard deviations of parameters at each iteration
%    pcov          parameter error covariance matrix
%    parFlag       flags for free and fixed parameters (=1, free; 0: fixed)
%    NparID        number of unknown parameters being estimated
%    NX0ID
%    Nx
%    Nzi
%    x0
%    parFlagX0
%    NbX
%    NBXID
%    bXpar
%    parFlagBX
%
% Outputs:
%    par_std_rel   relative standard deviations


%--------------------------------------------------------------------------
if  iter > 0,
    disp(' ')
    txt1 = 'Index  Parameter   Bound  Minimum     Maximum    ';
    txt2 = 'Standard Dev.   Rel. Std. Dev.';
    txt = sprintf('%s%s', txt1, txt2);
    disp(txt);
    
    % Print estimates, bounds, standard deviations etc for Nparam-Parameters
    if NparID > 0,
        iPar = 0;
        for ip=1:Nparam,
            if  parFlag(ip) > 0,
                iPar = iPar + 1;
                txtBounds = ' ';
                par_std_rel = Inf;
                if param(ip) ~= 0,
                    par_std_rel = 100*par_std(iPar,iter+1)/abs(param(ip));
                end
                if isfinite(param_min(ip)) == 0  |  isfinite(param_max(ip)) == 0, 
                    par_prnt = sprintf('%3i   %13.5e                              %10.4e   %8.2f',...
                                      ip, param(ip),...
                                      par_std(iPar,iter+1), par_std_rel);
                else
                    if param(ip) ~= param_min(ip) & param(ip) ~= param_max(ip), 
                        txtBounds = ' ';
                        par_prnt = sprintf('%3i   %13.5e  %s   %10.2e  %10.2e  %10.4e   %8.2f',...
                                          ip, param(ip), txtBounds,...
                                          param_min(ip), param_max(ip),...
                                          par_std(iPar,iter+1), par_std_rel);
                    else
                        txtBounds = '*';
                        par_prnt = sprintf('%3i   %13.5e  %s   %10.2e  %10.2e',...
                                            ip, param(ip), txtBounds,...
                                            param_min(ip), param_max(ip));
                    end
                end
                disp(par_prnt);
            end
        end
    end

    % Print estimates, standard deviations etc for X0 (Initial conditions)
    if NX0ID > 0,
        txt1 = 'Initial conditions x0:';
        disp(txt1);
        iPar = NparID;
        for kzi=1:Nzi,
            txt1 = 'Time segment ';
            par_prnt = sprintf('%s %3i', txt1, kzi);
            disp(par_prnt);
            for ip=1:Nx,                   % Loop over all initial conditions
                if parFlagX0(ip,kzi) > 0,  % do it for free x0 only
                    iPar = iPar + 1;
                    txtBounds = ' ';
                    par_std_rel = Inf;
                    if x0(ip,kzi) ~= 0,
                        par_std_rel = 100*par_std(iPar,iter+1)/abs(x0(ip,kzi));
                    end
                    par_prnt = sprintf('%3i   %13.5e                              %10.4e   %8.2f',...
                                       ip, x0(ip,kzi),...
                                       par_std(iPar,iter+1), par_std_rel);
                    disp(par_prnt);
               end
           end
        end
    end

    % Print estimates, standard deviations etc for bX (bias parameters)
    if NBXID > 0,
        txt1 = 'Bias Parameters bX:';
        disp(txt1);
        iPar = NparID+NX0ID;
        for kzi=1:Nzi,
            txt1 = 'Time segment ';
            par_prnt = sprintf('%s %3i', txt1, kzi);
            disp(par_prnt);
            for ip=1:NbX,                   % Loop over all initial conditions
                if parFlagBX(ip,kzi) > 0,   % do it for free bXpar only
                    iPar = iPar + 1;
                    txtBounds = ' ';
                    par_std_rel = Inf;
                    if bXpar(ip,kzi) ~= 0,
                        par_std_rel = 100*par_std(iPar,iter+1)/abs(bXpar(ip,kzi));
                    end
                    par_prnt = sprintf('%3i   %13.5e                              %10.4e   %8.2f',...
                                       ip, bXpar(ip,kzi),...
                                       par_std(iPar,iter+1), par_std_rel);
                    disp(par_prnt);
               end
            end
        end
    end

    %--------------------------------------------------------------------------
    % Correlation coefficients matrix: 
    % pcorr(i,j)=pcov(i,j)/sqrt(pcov(i,i)*p_cov(j,j))
    hlf = ones(NparID+NX0ID+NBXID, NparID+NX0ID+NBXID);
    for ip=1:NparID+NX0ID+NBXID, 
        hlf(ip,:) = hlf(ip,:) / sqrt(diag(pcov(ip,ip)));   % Eq. (4.89)
    end
    pcorr = pcov .* hlf .* hlf';
    
    disp(' ')
    disp('The following parameters have a correlation of more than 0.9:');
    disp('par_i   par_j   corr_coeff');

    for ip=2:NparID+NX0ID+NBXID,
        for jp=1:ip-1,
            scorr = abs(pcorr(ip,jp));
            if  scorr > 0.9,
                cor_prnt = sprintf('%3i     %3i    %8.2f', ip, jp, scorr);
                disp(cor_prnt)
            end
        end
    end
end

return
% end of function
